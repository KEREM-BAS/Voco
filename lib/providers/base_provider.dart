// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../enums/snack_type.dart';
import '../models/base_model.dart';
import '../utils/constants.dart';
import '../utils/loading.dart';
import '../utils/main_util.dart';
import '../utils/map_util.dart';
import '../utils/routes.dart';
import '../utils/session.dart';
import '../utils/validators.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BaseProvider with ChangeNotifier {
  static const SUCCESS = "success";
  static const RESULT_CODE = "resultCode";
  static const MESSAGE = "message";
  static const DATA = "data";

  final Map<String, String> _headers = {
    'Channel': '2',
    'ChannelId': '2',
    //'Authorization': 'ZXJwYUFwaVVzZXI6JGxDY2RUSV5EIUFII2w4bFA=',
  };

  post(
    BuildContext context,
    String path,
    Map<String, dynamic> parameters,
    Map<String, dynamic> headers,
    bool showLoading, {
    bool isDataResponse = false,
    bool isLogin = false,
    String contentType = 'application/json',
    FormData? formData,
    bool isStringResponse = false,
  }) async {
    final pr = ProgressDialog(context);
    pr.style(message: tr('texts.wait'));

    await showProgress(pr, showLoading);

    bool isConnected = await checkInternetConnectionFirst(context);

    if (!isConnected) {
      await hideProgress(pr, showLoading);
      return null;
    }

    log(path, name: "Calling");

    String baseUrl = Constants.SERVICE_PROD_URL;

    if (Session.instance.isTestEnv) {
      baseUrl = Constants.SERVICE_TEST_URL;
    }

    final url = baseUrl + path;

    if (headers['token'] == null) {
      _headers.remove('token');
    }

    if (headers['Token'] == null) {
      _headers.remove('Token');
    }

    if (Validators.isNotEmptyOrNull(Session.instance.token)) {
      _headers['Authorization'] = 'Bearer ${Session.instance.token}';
    }

    _headers['content-type'] = contentType;

    headers.forEach((k, v) {
      if (Validators.isNotEmptyOrNull(k) && Validators.isNotEmptyOrNull(v)) {
        _headers[k] = v;
      }
    });

    Dio dio = Dio();

    /*   dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    )); */

    Response response;

    final body = formData ?? jsonEncode(parameters);

    try {
      response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: _headers,
          contentType: contentType,
        ),
      );

      log(path, name: "Completed");
      BaseResponse baseResponse = parseResponse(response, isDataResponse, isStringResponse: isStringResponse);

      await hideProgress(pr, showLoading);
      if (path == Routes.API_CHANGE_PASSWORD) {
        await hideProgress(pr, showLoading);
      }
      return baseResponse;
    } catch (error) {
      log(error.toString(), name: "Error");

      try {
        final dioError = error as DioException;
        Response errorResponse = dioError.response!;

        if (errorResponse.statusCode == 401) {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              MainUtil.showSnack(context,
                  'Kullanıcınız uzun süre hareketsiz olduğu için oturum süreniz sonlandırılmıştır. Lütfen yeniden oturum açınız.', SnackType.ERROR);
              clearSessionAndGoToLogin(context);
            },
          );

          return null;
        } else if (errorResponse.statusCode == 415) {
          return BaseResponse(
            success: false,
            resultCode: '415',
            message: errorResponse.statusMessage,
          );
        } else if (errorResponse.statusCode == 500 && path != Routes.API_MERCHANT_INVITE_PERSONNEL) {
          return BaseResponse(
            success: false,
            resultCode: '500',
            message: 'Sunucuya erişilemiyor. Lütfen daha sonra tekrar deneyiniz.',
          );
        }

        BaseResponse errResp = parseErrorResponse(errorResponse);

        if (errResp.errorCode == 1155 || errResp.errorCode == 2002 || errResp.errorCode == 2003 || errResp.errorCode == 2004) {
          debugPrint('Completed with error: ${errResp.errorCode} --> $path');
          return BaseResponse(
            resultCode: errResp.errorCode.toString(),
            message: errResp.message,
            data: errResp.data,
          );
        }

        if (errResp.errorCode == 2020) {
          debugPrint('Completed with activation error: ${errResp.errorCode} --> $path');
          return BaseResponse(
            resultCode: errResp.errorCode.toString(),
            message: errResp.message,
            data: errResp.data,
          );
        }

        if (!isLogin &&
            errResp.message != null &&
            (errResp.errorCode == 401 ||
                errResp.message!.contains('Oturum') ||
                errResp.message!
                    .startsWith('Kullanıcınız uzun süre hareketsiz olduğu için oturum süreniz sonlandırılmıştır. Lütfen yeniden oturum açınız.'))) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              MainUtil.showSnack(context, 'Oturumunuz zaman aşımına uğradı', SnackType.ERROR);
              clearSessionAndGoToLogin(context);
            },
          );
          return null;
        }

        await hideProgress(pr, showLoading);
        throw FlutterError(errResp.message ?? '$error');
      } catch (e) {
        debugPrint('$e');
        await hideProgress(pr, showLoading);
        throw FlutterError('$e');
      } finally {
        await hideProgress(pr, showLoading);
      }
    }
  }

  clearSessionAndGoToLogin(BuildContext context) {
    Session.instance.clear();
    // context.pushReplacement(Routes.LOGIN);
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.LOGIN, ModalRoute.withName("/login"));
  }

  Future<bool> checkInternetConnectionFirst(BuildContext context) async {
    if (!Session.instance.checkInternet) {
      return true;
    }

    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    bool isConnected = true;

    // ignore: unrelated_type_equality_checks
    if (result == ConnectivityResult.none) {
      isConnected = false;
    } else {
      try {
        final addresses = await InternetAddress.lookup('www.google.com');
        if (addresses.isNotEmpty && addresses[0].rawAddress.isNotEmpty) {
          isConnected = true;
        }
      } catch (e) {
        debugPrint('$e');
        isConnected = false;
      }
    }

    if (!isConnected) {
      MainUtil.showSnack(
        context,
        tr('messages.internetConnection'),
        SnackType.ERROR,
      );

      Timer(
        const Duration(seconds: 3),
        () => clearSessionAndGoToLogin(context),
      );
    }

    return isConnected;
  }

  parseResponse(Response response, bool isDataResponse, {bool isStringResponse = false}) {
    Map rsp = {};

    if (isStringResponse) {
      rsp[SUCCESS] = true;
      rsp[DATA] = response.data;
    } else {
      rsp = response.data;
    }

    final resultCode = rsp[RESULT_CODE];
    final message = rsp[MESSAGE];
    final success = rsp[SUCCESS] ?? (rsp['succeeded'] ?? false);
    final data = isDataResponse ? rsp : rsp[DATA];

    //final token = response.headers.value('Token');

    var resp = BaseResponse(
      resultCode: resultCode,
      message: message,
      success: success,
      data: data,
    );

    return resp;
  }

  parseListResponse(Response response) {
    List rsp = response.data;

    var resp = BaseResponse(
      data: rsp,
    );

    return resp;
  }

  parseErrorResponse(Response response) {
    Map<String, dynamic> rsp = response.data;

    String resultCode = MapUtil.getString(rsp, RESULT_CODE, retryKey: 'ResultCode');
    String message = MapUtil.getString(rsp, MESSAGE, retryKey: 'Message');
    final success = MapUtil.getBool(rsp, SUCCESS);
    final data = rsp[DATA];

    if (rsp.containsKey('status') && MapUtil.getInt(rsp, 'status') == 400) {
      message = MapUtil.getString(rsp, 'title');
    }

    var resp = BaseResponse(
      resultCode: resultCode,
      message: message,
      success: success,
      data: data,
    );

    return resp;
  }

  get(
    BuildContext context,
    fullPath,
    Map headers,
    bool showLoading, {
    bool isDataResponse = false,
    bool isLogin = false,
  }) async {
    final pr = ProgressDialog(context);
    pr.style(message: tr('texts.wait'));

    await showProgress(pr, showLoading);

    bool isConnected = await checkInternetConnectionFirst(context);

    if (!isConnected) {
      await hideProgress(pr, showLoading);
      return null;
    }

    log("Calling --> " + fullPath);

    String baseUrl = Constants.SERVICE_PROD_URL;

    if (Session.instance.isTestEnv) {
      baseUrl = Constants.SERVICE_TEST_URL;
    }

    final url = baseUrl + fullPath;

    headers.forEach((k, v) => _headers[k] = v);

    if (headers['token'] == null) {
      _headers.remove('token');
    }

    if (headers['Token'] == null) {
      _headers.remove('Token');
    }

    if (headers['lang'] == null) {
      _headers['lang'] = Session.instance.locale!.languageCode;
    }

    if (headers['languageId'] == null) {
      _headers['languageId'] = Session.instance.locale!.languageCode == 'en' ? '2' : '1';
    }

    if (!Validators.isNotEmptyOrNull(Session.instance.token)) {
      _headers['Authorization'] = 'Bearer ${Session.instance.token}';
    }

    Dio dio = Dio();
    Response response;

    try {
      response = await dio.get(
        url,
        options: Options(
          headers: _headers,
        ),
      );

      debugPrint('Completed --> ' + fullPath);
      BaseResponse baseResponse = isDataResponse ? parseListResponse(response) : parseResponse(response, isDataResponse);
      await hideProgress(pr, showLoading);
      return baseResponse;
    } catch (error) {
      debugPrint('Error: $error');

      try {
        final dioError = error as DioException;
        Response errorResponse = dioError.response!;

        BaseResponse errResp = parseErrorResponse(errorResponse);

        if (errResp.errorCode == 1155 || errResp.errorCode == 2002 || errResp.errorCode == 2003 || errResp.errorCode == 2004) {
          debugPrint('Completed with error: ${errResp.errorCode} --> ' + fullPath);
          return BaseResponse(
            resultCode: errResp.errorCode.toString(),
            message: errResp.message,
            data: errResp.data,
          );
        }

        if (!isLogin &&
            errResp.message != null &&
            (errResp.message!.contains('Oturum') ||
                errResp.message!
                    .startsWith('Kullanıcınız uzun süre hareketsiz olduğu için oturum süreniz sonlandırılmıştır. Lütfen yeniden oturum açınız.'))) {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              MainUtil.showSnack(context, errResp.message ?? '', SnackType.ERROR);
              clearSessionAndGoToLogin(context);
            },
          );
          return null;
        }

        throw FlutterError(errResp.message ?? '$error');
      } catch (e) {
        debugPrint('$e');
        await hideProgress(pr, showLoading);
        throw FlutterError('$error');
      }
    }
  }

  Future<void> showProgress(ProgressDialog pr, bool showLoading) async {
    if (showLoading) {
      await pr.show();
    }
  }

  Future<void> hideProgress(ProgressDialog pr, bool showLoading) async {
    if (showLoading) {
      await pr.hide();
    }
  }
}
