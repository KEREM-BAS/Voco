import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voco/screens/login/login.view.dart';
import 'enums/snack_type.dart';
import 'models/payment_transaction.dart';
import 'models/responses/handle_callback_data_response.dart';
import 'providers/auth_provider.dart';
import 'utils/constants.dart';
import 'utils/main_util.dart';
import 'utils/routes.dart';
import 'utils/session.dart';
import 'utils/softpos_alertbox/softpos_alertbox_enums.dart';
import 'utils/softpos_alertbox/softpos_alertbox_functions.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const Locale english = Locale('en', 'US');
const Locale turkish = Locale('tr', 'TR');
const platform = MethodChannel('com.hstsoftpos.app/channel');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await _initializePlatform();
  await readPrefs();

  runApp(
    EasyLocalization(
      supportedLocales: const [english, turkish],
      path: 'assets/translations',
      saveLocale: true,
      startLocale: Session.instance.locale ?? turkish,
      fallbackLocale: turkish,
      child: const HstPosApp(),
    ),
  );
}

Dio get dio => Dio(
      BaseOptions(
        contentType: 'application/json',
        baseUrl: Session.instance.isTestEnv ? 'https://devapi.hstmobil.com.tr/api/External/' : 'https://api.hstmobil.com.tr/api/External/',
      ),
    );

Future<void> handleDeepLink(Uri? uri, BuildContext context) async {
  if (uri == null) {
    return;
  }

  try {
    List<String> pathSegments = uri.pathSegments;
    String? uniqId = pathSegments.length > 1 ? pathSegments[1] : null;

    if (uniqId == null || uniqId.isEmpty) {
      log('Missing uniqId');
      _showErrorDialog(context, 'Geçersiz uniqId. Lütfen daha sonra tekrar deneyiniz.');
      return;
    }
    String? decodedData = uri.queryParameters['data'];
    String? decodedSessionToken = uri.queryParameters['paymentSessionToken'];

    if (decodedData == null || decodedSessionToken == null) {
      return;
    }
    decodedData = Uri.decodeFull(decodedData);
    decodedSessionToken = Uri.decodeFull(decodedSessionToken);
    if (decodedData.isNotEmpty && decodedSessionToken.isNotEmpty) {
      if (Session.instance.isTestEnv) {
        await Clipboard.setData(ClipboardData(
            text: '{"referanceId": "$uniqId", "data": "$decodedData", "paymentSessionToken": "$decodedSessionToken", "url": "${uri.toString()}"}'));
      }
      await dio.post(
        "Handle-Callback-Data",
        data: {
          "referanceId": uniqId,
          "data": decodedData,
          "paymentSessionToken": decodedSessionToken,
        },
      );
    }
  } catch (e) {
    log('Error handling deep link: ${e.toString()}');
  }

  try {
    List<String> pathSegments = uri.pathSegments;
    String? uniqId = pathSegments.length > 1 ? pathSegments[1] : null;
    if (uniqId == null || uniqId.isEmpty) {
      _showErrorDialog(context, 'Geçersiz uniqId. Lütfen daha sonra tekrar deneyiniz.');
      return;
    }
    CallbackDataResponse? callbackDataResponse;
    Future<CallbackDataResponse?> fetchData(String uniqId) async {
      try {
        var response = await dio.post(
          "SoftPos-Sale-Result",
          queryParameters: {
            "referanceId": uniqId,
          },
        );

        if (response.statusCode != 200) {
          return null;
        }

        return CallbackDataResponse.fromJson(response.data);
      } catch (e) {
        return null;
      }
    }

    // Initial request
    callbackDataResponse = await fetchData(uniqId);

    if (callbackDataResponse == null) {
      _showErrorDialog(context, 'Beklenmeyen bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.');
      return;
    }

    // Retry if not completed and status is null
    while (!(callbackDataResponse?.isCompleted ?? false) || callbackDataResponse?.status == null) {
      callbackDataResponse = await fetchData(uniqId);

      if (callbackDataResponse == null) {
        _showErrorDialog(context, 'Beklenmeyen bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.');
        return;
      }
    }

    // Show success dialog
    if ((callbackDataResponse?.isCompleted ?? false) && (callbackDataResponse?.status ?? false)) {
      _showAlertDialog(
        context,
        callbackDataResponse,
        id: uniqId,
      );
    } else {
      _showErrorDialog(context, 'İşlem tamamlanamadı. Lütfen daha sonra tekrar deneyiniz.');
    }
  } catch (e) {
    _showErrorDialog(context, 'Beklenmeyen bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.');
  }
}

Future<void> _openAppSettings() async {
  try {
    await platform.invokeMethod('openAppSettings');
  } on PlatformException catch (e) {
    log("Failed to open app settings: ${e.message}");
  }
}

Future<void> _initializePlatform() async {
  platform.setMethodCallHandler((call) async {
    switch (call.method) {
      case 'onDeepLinkReceived':
        final String deepLinkData = call.arguments as String;
        final Uri deepLink = Uri.parse(deepLinkData);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await handleDeepLink(deepLink, navigatorKey.currentState!.context);
        });
        break;
      case 'openAppSettings':
        _openAppSettings();
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'The method ${call.method} is not implemented',
        );
    }
  });
}

Future<void> printSlip(BuildContext context, String id) async {
  try {
    int? printerStatus = await const MethodChannel('com.hstsoftpos.app/channel').invokeMethod<int?>('getPrinterStatus');
    if (printerStatus == 240) {
      await QuickAlert.show(
        title: "Hata",
        context: context,
        type: QuickAlertType.error,
        text: "Fiş basılamadı. Ruloyu kontrol edin.",
        confirmBtnText: "Tamam",
      );
      return;
    }
    PaymentTransaction? payment = await Provider.of<AuthProvider>(context, listen: false).getTransactionById(context, id);

    if (payment == null) {
      MainUtil.showSnack(context, 'İşlem bilgileri alınamadı.', SnackType.ERROR);
      return;
    }

    Map<String, dynamic> paymentJson = payment.toJson();
    await const MethodChannel('com.hstsoftpos.app/channel').invokeMethod('printSlip', paymentJson);
  } catch (e) {
    log(e.toString());
    MainUtil.showSnack(context, 'Bir hata oluştu. Lütfen tekrar deneyin.', SnackType.ERROR);
  }
}

Future<void> _showAlertDialog(BuildContext context, CallbackDataResponse? response, {required String id}) async {
  if ((response?.isCompleted ?? false) && (response?.status ?? false)) {
    await Future.wait([
      printSlip(context, id),
      QuickAlert.show(
        title: "Başarılı",
        context: context,
        type: QuickAlertType.success,
        text: response?.errorDesc ?? "-",
        confirmBtnText: "Tamam",
      )
    ]);
  } else {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: response?.errorDesc ?? "-",
      confirmBtnText: "Kapat",
    );
  }
}

void _showErrorDialog(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: 'Hata',
    text: message,
    cancelBtnText: "Kapat",
  );
}

readPrefs() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey('token')) {
    debugPrint('token = ${pref.getString('token')}');
  } else {}
}

class HstPosApp extends StatefulWidget {
  const HstPosApp({super.key});

  @override
  _HstPosAppState createState() => _HstPosAppState();
}

class _HstPosAppState extends State<HstPosApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'HSTPos',
        debugShowCheckedModeBanner: false,
        locale: EasyLocalization.of(context)!.locale,
        localizationsDelegates: EasyLocalization.of(context)!.delegates,
        supportedLocales: EasyLocalization.of(context)!.supportedLocales,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        navigatorKey: navigatorKey,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColorLight: Colors.black,
          primaryColor: Constants.PRIMARY,
          fontFamily: 'Arial',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(decoration: TextDecoration.none),
            bodyMedium: TextStyle(decoration: TextDecoration.none),
            bodySmall: TextStyle(decoration: TextDecoration.none),
          ),
        ),
        initialRoute: "/",
        routes: Routes.getAllRoutes(),
        home: const LoginScreen(),
      ),
    );
  }
}
