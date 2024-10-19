import 'dart:convert';
import '../utils/validators.dart';

class BaseResponse {
  String? resultCode;
  String? message;
  bool success = false;
  Object? data;
  String? token;

  BaseResponse({
    this.resultCode,
    this.message,
    this.success = false,
    this.data,
    this.token,
  });

  @override
  String toString() {
    return jsonEncode(this);
  }

  int get errorCode => Validators.isEmptyOrNull(resultCode) ? 0 : int.parse(resultCode ?? '0');
}
