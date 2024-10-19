// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voco/utils/main_util.dart';

import 'constants.dart';

class FormUtil {
  static InputBorder border(
    double width, {
    double radius = 25,
    Color? borderColor,
    bool isUnderlined = false,
  }) {
    if (isUnderlined) {
      return UnderlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: borderColor ?? Constants.PRIMARY,
          width: width,
          style: BorderStyle.solid,
        ),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      gapPadding: 0,
      borderSide: BorderSide(
        color: borderColor ?? Constants.PRIMARY,
        width: width,
        style: BorderStyle.solid,
      ),
    );
  }

  static Widget textField(
    TextEditingController ctrl,
    double width,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String hintText,
    Function validate,
    String validationMessage,
    TextInputType inputType,
    List<TextInputFormatter>? formatters, {
    double radius = 25,
    Color fillColor = Colors.white,
    String? labelText,
    double verticalMargin = 2,
    bool enabled = true,
    TextAlign textAlign = TextAlign.start,
    int minLines = 1,
    int maxLines = 1,
    Color? borderColor,
    String? prefixText,
    Function? onChanged,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool isBorderUnderlined = false,
    Color cursorColor = Constants.PRIMARY,
    TextStyle hintStyle = const TextStyle(fontSize: 12),
    bool ignoreEnabled = false,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 16,
    EdgeInsetsGeometry? contentPadding,
    bool obscureText = false,
    bool isCustomValidation = false,
    TextStyle? prefixStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: verticalMargin),
          width: width,
          child: TextFormField(
            autofocus: false,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              isDense: false,
              focusedBorder: border(
                2,
                radius: radius,
                borderColor: borderColor,
                isUnderlined: isBorderUnderlined,
              ),
              fillColor: fillColor,
              border: border(
                1,
                radius: radius,
                borderColor: borderColor,
                isUnderlined: isBorderUnderlined,
              ),
              enabledBorder: border(
                1,
                radius: radius,
                borderColor: borderColor,
                isUnderlined: isBorderUnderlined,
              ),
              hintText: hintText,
              hintStyle: hintStyle,
              prefixIcon: prefixIcon,
              prefixText: prefixText,
              prefixStyle: prefixStyle,
              suffixIcon: suffixIcon,
              errorMaxLines: 3,
              contentPadding: contentPadding,
            ),
            style: TextStyle(
              color: enabled || ignoreEnabled ? Colors.black : Colors.black26,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
            cursorColor: cursorColor,
            keyboardType: inputType,
            keyboardAppearance: Brightness.dark,
            controller: ctrl,
            validator: (val) {
              if (isCustomValidation) {
                return validate(val);
              } else {
                return validate(val) ? null : validationMessage;
              }
            },
            inputFormatters: formatters,
            enabled: enabled,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textAlign: textAlign,
            onChanged: (val) => onChanged != null ? onChanged(val) : {},
            textCapitalization: textCapitalization,
            textAlignVertical: TextAlignVertical.center,
            onTapOutside: (event) => MainUtil.closeKeyboardNew(),
            textInputAction: TextInputAction.done,
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }

  static Widget passwordField(
    TextEditingController ctrl,
    double width,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String hintText,
    Function validate,
    String validationMessage,
    bool obscureText,
    TextInputType inputType,
    List<TextInputFormatter>? formatters, {
    double radius = 25,
    Color? borderColor,
    Color fillColor = Colors.white,
    bool isBorderUnderlined = false,
    Color cursorColor = Constants.PRIMARY,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: width,
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              focusedBorder: border(
                2,
                radius: radius,
                borderColor: borderColor,
                isUnderlined: isBorderUnderlined,
              ),
              fillColor: fillColor,
              border: border(
                1,
                radius: radius,
                borderColor: borderColor,
                isUnderlined: isBorderUnderlined,
              ),
              enabledBorder: border(
                1,
                radius: radius,
                borderColor: borderColor,
                isUnderlined: isBorderUnderlined,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 12),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              errorMaxLines: 3,
            ),
            cursorColor: cursorColor,
            keyboardType: inputType,
            controller: ctrl,
            obscureText: obscureText,
            validator: (val) => validate(val) ? null : validationMessage,
            inputFormatters: formatters,
          ),
        ),
      ],
    );
  }

  static Widget button(
    VoidCallback onTap,
    bool isLight,
    String buttonLabel,
    double width,
    double borderRadius, {
    Color buttonColor = Constants.PRIMARY,
    double height = 50,
    double fontSize = 20,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isLight ? Colors.white : buttonColor,
        ),
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontSize: fontSize,
            color: isLight ? Constants.PRIMARY : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Widget elevatedButton(
    VoidCallback onTap,
    bool isLight,
    String buttonLabel,
    double width,
    double borderRadius, {
    Color buttonColor = Constants.PRIMARY,
    double height = 50,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color? borderColor,
    Color? fontColor,
    double borderWidth = 0,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isLight ? Colors.white : buttonColor,
        fixedSize: Size(width, height),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor ?? (isLight ? Colors.white : buttonColor),
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor ?? (isLight ? Constants.PRIMARY : Colors.white),
          fontWeight: fontWeight,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget elevatedIconButton(
    VoidCallback onTap,
    bool isLight,
    String buttonLabel,
    Widget icon,
    double width,
    double borderRadius, {
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 20,
    Color? borderColor,
    Color buttonColor = Constants.BUTTON_BG,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: icon,
      label: SizedBox(
        width: width * 0.7,
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontSize: fontSize,
            color: isLight ? Constants.PRIMARY : Colors.white,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLight ? Colors.white : buttonColor,
        fixedSize: Size(width, 50),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? (isLight ? Colors.white : Constants.PRIMARY)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  static Widget buttonWithIcon(
    VoidCallback onTap,
    bool isLight,
    String buttonLabel,
    double width,
    Widget icon,
    double iconSide, {
    double height = 50,
    double fontSize = 20,
    double borderRadius = 25,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isLight ? Colors.white : Constants.PRIMARY,
        ),
        child: Stack(
          alignment: const Alignment(0, 0),
          children: [
            Align(
              alignment: Alignment(iconSide, 0),
              child: icon,
            ),
            Align(
              alignment: const Alignment(0, 0),
              child: Text(
                buttonLabel,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isLight ? Constants.PRIMARY : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget link(bool isLight, String label, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Text(
        label,
        style: TextStyle(
          color: isLight ? Colors.white : Constants.PRIMARY,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Widget text(
    double width,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? initialValue,
    String? labelText, {
    double radius = 25,
    Color fillColor = Colors.white,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: width,
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              focusedBorder: border(2, radius: radius),
              fillColor: fillColor,
              border: border(1, radius: radius),
              enabledBorder: border(1, radius: radius),
              prefix: prefixIcon,
              suffix: suffixIcon,
            ),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            cursorColor: Constants.PRIMARY,
            enabled: false,
            initialValue: initialValue,
            textAlign: textAlign,
          ),
        ),
      ],
    );
  }

  static Widget tile(
    BuildContext context,
    String label,
    double width,
    VoidCallback onTap,
    Widget? leading,
    Widget? trailing,
  ) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: leading,
        trailing: trailing,
        title: Text(label),
      ),
    );
  }

  static Widget formLabel(
    String label, {
    double marginLeft = 20,
    double marginTop = 5,
    bool withAsterisk = false,
    Color textColor = Constants.PRIMARY,
    EdgeInsets padding = const EdgeInsets.all(1),
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Icon? icon,
  }) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft, top: marginTop),
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: icon,
                )
              : MainUtil.emptyWidget(),
          Text(
            label,
            softWrap: true,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
              decoration: TextDecoration.none,
            ),
          ),
          withAsterisk
              ? const Text(
                  ' *',
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              : MainUtil.emptyWidget(),
        ],
      ),
    );
  }

  static Widget elevatedButtonWithBgImage(
    VoidCallback onTap,
    bool isLight,
    String buttonLabel,
    double width,
    double borderRadius, {
    Color buttonColor = Constants.PRIMARY,
    double height = 50,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color? borderColor,
    Color? fontColor,
    double borderWidth = 0,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/button-bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          //fixedSize: Size(width, height),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: borderWidth,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontSize: fontSize,
            color: fontColor ?? (isLight ? Constants.PRIMARY : Colors.white),
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Widget backPopIcon(BuildContext context) {
    return GestureDetector(
      onTap: () => MainUtil.pop(context),
      child: const Icon(
        CupertinoIcons.left_chevron,
        color: Constants.SECONDARY,
        size: 60,
      ),
    );
  }
}
