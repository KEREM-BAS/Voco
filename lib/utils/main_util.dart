import 'package:flutter/material.dart';
import 'package:voco/enums/snack_type.dart';

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

  static void navigateTo(
    BuildContext context,
    Widget screen,
    bool willPop, {
    VoidCallback? callback,
  }) async {
    final _navigator = Navigator.of(context);

    if (willPop) {
      _navigator.pop();
    }

    await _navigator.push(
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
}
