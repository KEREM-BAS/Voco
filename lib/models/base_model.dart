import 'dart:convert';

class BaseResponse {
  int errorCode = 0;
  String? message;
  List? messages;
  Object? data;
  String? token;

  BaseResponse({
    this.errorCode = 0,
    this.message,
    this.messages,
    this.data,
    this.token,
  });

  @override
  String toString() {
    return jsonEncode(this);
  }
}
