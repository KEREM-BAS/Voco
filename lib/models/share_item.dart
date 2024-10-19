import 'dart:io';

class ShareItem {
  String? title;
  String? subTitle;
  ShareType? type;
  File? file;

  ShareItem({
    this.title,
    this.subTitle,
    this.type,
    this.file,
  });
}

enum ShareType {
  FILE,
  TEXT,
}
