import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;

enum QuickAlertAnimType {
  scale,
  rotate,
  slideInDown,
  slideInUp,
  slideInLeft,
  slideInRight,
}

class QuickAlertOptions {
  String? title;
  String? text;
  TextAlign? titleAlignment;
  TextAlign? textAlignment;
  Widget? widget;
  QuickAlertType type;
  QuickAlertAnimType? animType;
  bool? barrierDismissible = false;
  VoidCallback? onConfirmBtnTap;
  VoidCallback? onCancelBtnTap;
  String? confirmBtnText;
  String? cancelBtnText;
  Color? confirmBtnColor;
  TextStyle? confirmBtnTextStyle;
  TextStyle? cancelBtnTextStyle;
  Color? backgroundColor;
  Color? headerBackgroundColor;
  Color? titleColor;
  Color? textColor;
  bool? showCancelBtn;
  bool? showConfirmBtn;
  double? borderRadius;
  String? customAsset;
  double? width;
  Timer? timer;
  QuickAlertOptions({
    this.title,
    this.text,
    this.titleAlignment,
    this.textAlignment,
    this.widget,
    required this.type,
    this.animType,
    this.barrierDismissible,
    this.onConfirmBtnTap,
    this.onCancelBtnTap,
    this.confirmBtnText,
    this.cancelBtnText,
    this.confirmBtnColor,
    this.confirmBtnTextStyle,
    this.cancelBtnTextStyle,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.titleColor,
    this.textColor,
    this.showCancelBtn,
    this.showConfirmBtn,
    this.borderRadius,
    this.customAsset,
    this.width,
    this.timer,
  });
}

enum QuickAlertType {
  success,
  error,
  warning,
  confirm,
  info,
  loading,
  custom,
}

class AppAnim {
  static const success = 'assets/images/success.gif';
  static const error = 'assets/images/error.gif';
  static const warning = 'assets/images/warning.gif';
}

class Animate {
  static Transform scale({
    required Widget child,
    required Animation<double> animation,
  }) {
    return Transform.scale(
      scale: animation.value,
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  static Transform rotate({
    required Widget child,
    required Animation<double> animation,
  }) {
    return Transform.rotate(
      angle: math.radians(animation.value * 360),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  static Transform slideInDown({
    required Widget child,
    required Animation<double> animation,
  }) {
    final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
    return Transform(
      transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  static Transform slideInUp({
    required Widget child,
    required Animation<double> animation,
  }) {
    final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
    return Transform(
      transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  static Transform slideInLeft({
    required Widget child,
    required Animation<double> animation,
  }) {
    final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
    return Transform(
      transform: Matrix4.translationValues(curvedValue * 200, 0.0, 0.0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }

  static Transform slideInRight({
    required Widget child,
    required Animation animation,
  }) {
    final curvedValue = Curves.easeInOutBack.transform(animation.value) - 1.0;
    return Transform(
      transform: Matrix4.translationValues(curvedValue * -200, 0, 0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
  }
}
