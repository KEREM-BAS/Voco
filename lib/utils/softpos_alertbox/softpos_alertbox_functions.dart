// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'softpos_alertbox_enums.dart';

class QuickAlert {
  static Future show({
    required BuildContext context,
    String? title,
    String? text,
    TextAlign? titleAlignment,
    TextAlign? textAlignment,
    Widget? widget,
    required QuickAlertType type,
    QuickAlertAnimType animType = QuickAlertAnimType.scale,
    bool barrierDismissible = true,
    VoidCallback? onConfirmBtnTap,
    VoidCallback? onCancelBtnTap,
    String confirmBtnText = 'Okay',
    String cancelBtnText = 'Cancel',
    Color confirmBtnColor = Colors.blue,
    TextStyle? confirmBtnTextStyle,
    TextStyle? cancelBtnTextStyle,
    Color backgroundColor = Colors.white,
    Color headerBackgroundColor = Colors.white,
    Color titleColor = Colors.black,
    Color textColor = Colors.black,
    Color? barrierColor,
    bool showCancelBtn = false,
    bool showConfirmBtn = true,
    double borderRadius = 15.0,
    String? customAsset,
    double? width,
    Duration? autoCloseDuration,
    bool disableBackBtn = false,
  }) {
    Timer? timer;
    if (autoCloseDuration != null) {
      timer = Timer(autoCloseDuration, () {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }

    final options = QuickAlertOptions(
      timer: timer,
      title: title,
      text: text,
      titleAlignment: titleAlignment,
      textAlignment: textAlignment,
      widget: widget,
      type: type,
      animType: animType,
      barrierDismissible: barrierDismissible,
      onConfirmBtnTap: onConfirmBtnTap,
      onCancelBtnTap: onCancelBtnTap,
      confirmBtnText: confirmBtnText,
      cancelBtnText: cancelBtnText,
      confirmBtnColor: confirmBtnColor,
      confirmBtnTextStyle: confirmBtnTextStyle,
      cancelBtnTextStyle: cancelBtnTextStyle,
      backgroundColor: backgroundColor,
      headerBackgroundColor: headerBackgroundColor,
      titleColor: titleColor,
      textColor: textColor,
      showCancelBtn: showCancelBtn,
      showConfirmBtn: showConfirmBtn,
      borderRadius: borderRadius,
      customAsset: customAsset,
      width: width,
    );

    Widget child = WillPopScope(
      onWillPop: () async {
        options.timer?.cancel();
        if (options.type == QuickAlertType.loading && !disableBackBtn && showCancelBtn) {
          if (options.onCancelBtnTap != null) {
            options.onCancelBtnTap!();
            return false;
          }
        }
        return !disableBackBtn;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        content: QuickAlertContainer(
          options: options,
        ),
      ),
    );

    if (options.type != QuickAlertType.loading) {
      child = RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyUpEvent && event.logicalKey == LogicalKeyboardKey.enter) {
            options.timer?.cancel();
            options.onConfirmBtnTap != null ? options.onConfirmBtnTap!() : Navigator.pop(context);
          }
        },
        child: child,
      );
    }

    return showGeneralDialog(
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      transitionBuilder: (context, anim1, __, widget) {
        switch (animType) {
          case QuickAlertAnimType.scale:
            return Animate.scale(child: child, animation: anim1);
          case QuickAlertAnimType.rotate:
            return Animate.rotate(child: child, animation: anim1);
          case QuickAlertAnimType.slideInDown:
            return Animate.slideInDown(child: child, animation: anim1);
          case QuickAlertAnimType.slideInUp:
            return Animate.slideInUp(child: child, animation: anim1);
          case QuickAlertAnimType.slideInLeft:
            return Animate.slideInLeft(child: child, animation: anim1);
          case QuickAlertAnimType.slideInRight:
            return Animate.slideInRight(child: child, animation: anim1);
          default:
            return child;
        }
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: autoCloseDuration != null ? false : barrierDismissible,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, _, __) => Container(),
    );
  }
}

class QuickAlertContainer extends StatelessWidget {
  final QuickAlertOptions options;

  const QuickAlertContainer({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final header = buildHeader(context);
    final title = buildTitle(context);
    final text = buildText(context);
    final buttons = buildButtons();
    final widget = buildWidget(context);

    final content = Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          const SizedBox(
            height: 5.0,
          ),
          text,
          widget!,
          const SizedBox(
            height: 10.0,
          ),
          buttons
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: options.backgroundColor,
        borderRadius: BorderRadius.circular(options.borderRadius!),
      ),
      clipBehavior: Clip.antiAlias,
      width: options.width ?? MediaQuery.of(context).size.shortestSide,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [header, content],
      ),
    );
  }

  Widget buildHeader(context) {
    String? anim = AppAnim.success;
    switch (options.type) {
      case QuickAlertType.success:
        anim = AppAnim.success;
        break;
      case QuickAlertType.error:
        anim = AppAnim.error;
        break;
      case QuickAlertType.warning:
        anim = AppAnim.warning;
        break;
      case QuickAlertType.confirm:
        anim = AppAnim.warning;
        break;
      case QuickAlertType.info:
        anim = AppAnim.warning;
        break;
      case QuickAlertType.loading:
        anim = AppAnim.warning;
        break;
      default:
        anim = AppAnim.warning;
        break;
    }

    if (options.customAsset != null) {
      anim = options.customAsset;
    }
    return Container(
      width: double.infinity,
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: options.headerBackgroundColor,
      ),
      child: Image.asset(
        anim ?? "",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildTitle(context) {
    final title = options.title ?? whatTitle();
    return Visibility(
      visible: title != null,
      child: Text(
        '$title',
        textAlign: options.titleAlignment ?? TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: options.titleColor,
                ) ??
            TextStyle(
              color: options.titleColor,
            ),
      ),
    );
  }

  Widget buildText(context) {
    if (options.text == null && options.type != QuickAlertType.loading) {
      return Container();
    } else {
      String? text = '';
      if (options.type == QuickAlertType.loading) {
        text = options.text ?? 'Loading';
      } else {
        text = options.text;
      }
      return Text(
        text ?? '',
        textAlign: options.textAlignment ?? TextAlign.center,
        style: TextStyle(
          color: options.textColor,
        ),
      );
    }
  }

  Widget? buildWidget(context) {
    if (options.widget == null && options.type != QuickAlertType.custom) {
      return Container();
    } else {
      Widget widget = Container();
      if (options.type == QuickAlertType.custom) {
        widget = options.widget ?? widget;
      }
      return options.widget;
    }
  }

  Widget buildButtons() {
    return QuickAlertButtons(
      options: options,
    );
  }

  String? whatTitle() {
    switch (options.type) {
      case QuickAlertType.success:
        return 'Success';
      case QuickAlertType.error:
        return 'Error';
      case QuickAlertType.warning:
        return 'Warning';
      case QuickAlertType.confirm:
        return 'Are You Sure?';
      case QuickAlertType.info:
        return 'Info';
      case QuickAlertType.custom:
        return null;
      case QuickAlertType.loading:
        return null;
      default:
        return null;
    }
  }
}

class QuickAlertButtons extends StatelessWidget {
  final QuickAlertOptions options;

  const QuickAlertButtons({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          cancelBtn(context),
          options.type != QuickAlertType.loading ? okayBtn(context) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget okayBtn(context) {
    if (!options.showConfirmBtn!) {
      return const SizedBox();
    }
    final showCancelBtn = options.type == QuickAlertType.confirm ? true : options.showCancelBtn!;

    final okayBtn = buildButton(
        context: context,
        isOkayBtn: true,
        text: options.confirmBtnText!,
        onTap: () {
          options.timer?.cancel();
          options.onConfirmBtnTap != null ? options.onConfirmBtnTap!() : Navigator.pop(context);
        });

    if (showCancelBtn) {
      return Expanded(child: okayBtn);
    } else {
      return okayBtn;
    }
  }

  Widget cancelBtn(context) {
    final showCancelBtn = options.type == QuickAlertType.confirm ? true : options.showCancelBtn!;

    final cancelBtn = buildButton(
        context: context,
        isOkayBtn: false,
        text: options.cancelBtnText!,
        onTap: () {
          options.timer?.cancel();
          options.onCancelBtnTap != null ? options.onCancelBtnTap!() : Navigator.pop(context);
        });

    if (showCancelBtn) {
      return Expanded(child: cancelBtn);
    } else {
      return const SizedBox();
    }
  }

  Widget buildButton({
    BuildContext? context,
    required bool isOkayBtn,
    required String text,
    VoidCallback? onTap,
  }) {
    final btnText = Text(
      text,
      style: defaultTextStyle(isOkayBtn),
      textAlign: TextAlign.center,
    );

    final okayBtn = MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: options.confirmBtnColor ?? Theme.of(context!).primaryColor,
      onPressed: onTap,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: btnText,
        ),
      ),
    );

    final cancelBtn = GestureDetector(
      onTap: onTap,
      child: Center(
        child: btnText,
      ),
    );

    return isOkayBtn ? okayBtn : cancelBtn;
  }

  TextStyle defaultTextStyle(bool isOkayBtn) {
    final textStyle = TextStyle(
      color: isOkayBtn ? Colors.white : Colors.grey,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    );

    if (isOkayBtn) {
      return options.confirmBtnTextStyle ?? textStyle;
    } else {
      return options.cancelBtnTextStyle ?? textStyle;
    }
  }
}
