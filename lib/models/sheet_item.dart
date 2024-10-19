import 'package:flutter/material.dart';

class SheetItem {
  Widget? leading;
  String title = '';
  Widget? addToTitle;
  String? subTitle;
  Widget? trailing;
  VoidCallback? onTap;
  bool isTitleBold = false;
  int midFlex = 6;
  int leadingFlex = 1;
  int trailingFlex = 1;
  double height = 0;

  SheetItem({
    this.leading,
    this.title = '',
    this.subTitle,
    this.trailing,
    this.onTap,
    this.addToTitle,
    this.isTitleBold = false,
    this.leadingFlex = 1,
    this.trailingFlex = 1,
    this.midFlex = 6,
    this.height = 0,
  });
}
