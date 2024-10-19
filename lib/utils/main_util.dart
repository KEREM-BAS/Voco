import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voco/enums/snack_type.dart';
import 'package:voco/screens/home/home.view.dart';

import '../providers/auth_provider.dart';
import '../screens/login/login.view.dart';
import 'constants.dart';
import 'form_util.dart';
import 'session.dart';
import 'validators.dart';

class MainUtil {
  static void showSnack(
    BuildContext context,
    String message,
    SnackType type,
  ) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        //margin: const EdgeInsets.all(5),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: _bgColor(type),
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 1000,
      ),
    );
  }

  static Color _bgColor(SnackType type) {
    Color color = Colors.white;
    switch (type) {
      case SnackType.SUCCESS:
        color = Colors.green;
        break;
      case SnackType.ERROR:
        color = Colors.red;
        break;
      case SnackType.WARNING:
        color = Colors.orange;
        break;
      case SnackType.INFO:
        color = Colors.blue;
        break;
      default:
    }
    return color;
  }

  static void closeKeyboardNew() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static emptyWidget({double height = 0, double width = 0}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  static void closeKeyboard(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Route _createRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-2.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static void navigateBackTo(BuildContext context, Widget screen) async {
    closeKeyboard(context);

    await Navigator.of(context).push(
      _createRoute(screen),
    );
  }

  static navigateAction(BuildContext context, Widget screen, {bool isPop = false, Color iconColor = Constants.SECONDARY}) {
    return GestureDetector(
      onTap: () => isPop ? pop(context) : navigateBackTo(context, screen),
      child: Icon(
        CupertinoIcons.chevron_back,
        color: iconColor,
        size: 60,
      ),
    );
  }

  static void navigateTo(
    BuildContext context,
    Widget screen,
    bool willPop, {
    VoidCallback? callback,
  }) async {
    final navigator = Navigator.of(context);

    if (willPop) {
      navigator.pop();
    }

    await navigator.push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

    if (callback != null) {
      callback();
    }
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<void> openForgotPasswordDialog(
    BuildContext context,
    Function completeAction,
  ) async {
    return showDialog(
      useRootNavigator: true,
      context: context,
      builder: (dialogContext) {
        final phoneCtrl = TextEditingController();
        GlobalKey<FormState> form = GlobalKey<FormState>();

        return AlertDialog(
          alignment: Alignment.center,
          title: const Center(
            child: Text(
              'Şifre Yenileme',
              textAlign: TextAlign.center,
            ),
          ),
          scrollable: true,
          titleTextStyle: const TextStyle(
            color: Constants.PRIMARY,
            fontSize: 20,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: form,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Telefon',
                    labelStyle: const TextStyle(color: Constants.PRIMARY),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Constants.PRIMARY,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Constants.PRIMARY,
                        width: 2.0,
                      ),
                    ),
                    prefix: Container(
                      width: 40,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        '+90 ',
                        style: Constants.BLACK_16,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  controller: phoneCtrl,
                  validator: (val) => Validators.isEmptyOrNull(val) ? 'Zorunlu alan' : null,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey),
              ),
              child: const Text(
                'İptal',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                closeKeyboard(context);

                if (!form.currentState!.validate()) {
                  return;
                }
                MainUtil.pop(context);
                Session.instance.changePhone = phoneCtrl.text;
                bool isSuccess = await Provider.of<AuthProvider>(context, listen: false).forgotPassword(context, phoneCtrl.text);
                if (isSuccess) {
                  MainUtil.showSnack(context, 'Şifreniz sms ile iletilmiştir.', SnackType.INFO);
                  MainUtil.navigateTo(context, const LoginScreen(), false);
                } else {}
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Constants.PRIMARY),
              ),
              child: const Text(
                'Gönder',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showCustomDialog(
    BuildContext context,
    String title,
    String content,
    String buttonText,
    Function onConfirm,
    bool showCancel, {
    double confirmButtonWidth = 100,
    Function? onCancel,
    bool isDismissible = true,
    Widget? contentWidget,
  }) async {
    //var width = MediaQuery.of(context).size.width;

    return await showCupertinoDialog(
          barrierDismissible: isDismissible,
          context: context,
          useRootNavigator: true,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            titleTextStyle: const TextStyle(color: Colors.grey, fontSize: 24),
            content: SizedBox(
              //width: width * 0.9,
              child: contentWidget ?? Text(content),
            ),
            actionsAlignment: showCancel ? MainAxisAlignment.end : MainAxisAlignment.center,
            actions: <Widget>[
              if (showCancel)
                FormUtil.elevatedButton(
                  () => pop(dialogContext),
                  false,
                  'İptal',
                  100,
                  10,
                  buttonColor: Colors.grey,
                  height: 40,
                  fontSize: 16,
                ),
              const SizedBox(height: 16),
              FormUtil.elevatedButton(
                () async {
                  pop(dialogContext);
                  await onConfirm();
                },
                false,
                buttonText,
                confirmButtonWidth,
                10,
                height: 40,
                fontSize: 16,
              ),
            ],
          ),
        ) ??
        false;
  }

  static String format(double? value, {bool twoDigits = true}) {
    value ??= 0;
    if (!twoDigits && isFractionGTZero(value)) {
      return NumberFormat('#,##0.00###', 'tr').format(value);
    } else {
      return NumberFormat('#,##0.00', 'tr').format(value);
    }
  }

  static bool isFractionGTZero(double value) {
    if (value > 0) {
      String temp = value.toStringAsFixed(5);

      String fraction = temp.contains(',') ? temp.split(',')[1] : temp.split('.')[1];

      if (int.parse(fraction) > 100) {
        return true;
      }
    }
    return false;
  }

  static String formatAmount(
    dynamic amount, {
    int currencyCode = 949,
    String? currency,
  }) {
    return NumberFormat.currency(
      locale: 'tr',
      decimalDigits: 2,
      symbol: currencyCode == 949 ? Constants.LIRA_SYMBOL : currency ?? '',
      customPattern: '#,##0.00 ${currencyCode == 949 ? Constants.LIRA_SYMBOL : currency ?? ''}',
    ).format(amount);
  }

  static backAction(BuildContext context, {bool isPop = false, Color iconColor = Constants.SECONDARY, bool isDrawer = false}) {
    return GestureDetector(
      onTap: () => isPop ? pop(context) : navigateBackTo(context, const HomeView()),
      child: Icon(
        CupertinoIcons.chevron_back,
        color: iconColor,
        size: 60,
      ),
    );
  }
}
