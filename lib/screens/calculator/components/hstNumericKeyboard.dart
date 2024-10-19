// ignore_for_file: file_names

import 'package:flutter/material.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumericKeyboardHst extends StatefulWidget {
  /// Color of the text [default = Colors.black]
  final Color textColor;
  final Color? buttonBgColor;

  /// Display a custom right icon
  final Widget? rightIcon;

  /// Action to trigger when right button is pressed
  final Function()? rightButtonFn;

  /// Display a custom left icon
  final Widget? leftIcon;

  /// Action to trigger when left button is pressed
  final Function()? leftButtonFn;

  /// Callback when an item is pressed
  final KeyboardTapCallback onKeyboardTap;

  /// Main axis alignment [default = MainAxisAlignment.spaceEvenly]
  final MainAxisAlignment mainAxisAlignment;

  final double? height;

  const NumericKeyboardHst({
    super.key,
    required this.onKeyboardTap,
    this.textColor = Colors.black,
    this.buttonBgColor = Colors.white,
    this.rightButtonFn,
    this.rightIcon,
    this.leftButtonFn,
    this.leftIcon,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.height,
  });

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardHstState();
  }
}

class _NumericKeyboardHstState extends State<NumericKeyboardHst> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.height!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Spacer(),
          OverflowBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('1'),
              _calcButton('2'),
              _calcButton('3'),
              _calcButtonIcon(widget.rightIcon, widget.rightButtonFn),
            ],
          ),
          const Spacer(),
          OverflowBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('4'),
              _calcButton('5'),
              _calcButton('6'),
              _calcButtonIcon(widget.leftIcon, widget.leftButtonFn),
            ],
          ),
          const Spacer(),
          OverflowBar(
            alignment: widget.mainAxisAlignment,
            children: <Widget>[
              _calcButton('7'),
              _calcButton('8'),
              _calcButton('9'),
              _calcButton('0'),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _calcButton(String value) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: () {
        widget.onKeyboardTap(value);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.buttonBgColor,
        ),
        width: width / 4.3,
        height: widget.height! / 3.5,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }

  Widget _calcButtonIcon(Widget? icon, Function()? tapFunction) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: tapFunction,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.buttonBgColor,
        ),
        width: width / 4.3,
        height: widget.height! / 3.5,
        child: icon,
      ),
    );
  }
}
