import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voco/enums/snack_type.dart';
import 'package:voco/models/base_model.dart';
import 'package:voco/utils/constants.dart';
import 'package:voco/utils/main_util.dart';
import 'package:voco/utils/map_util.dart';
import 'package:voco/utils/validators.dart';

class BaseProvider with ChangeNotifier {
  static String BASE_URL = Constants.BASE_URL;

  static const ERROR_CODE = "ErrorCode";
  static const MESSAGE = "Message";
  static const EXCEPTION_MSG = "ExceptionMessage";
  static const MESSAGES = "Messages";
  static const DATA = "Data";

  final Map<String, String> _headers = {};

  post(
    BuildContext context,
    String path,
    Map<String, dynamic> parameters,
    Map<String, dynamic> headers,
    bool showLoading, {
    bool isDataResponse = false,
    bool isLogin = false,
  }) async {
    debugPrint('Calling --> ' + path);
    final url = BASE_URL + path;

    headers.forEach((k, v) {
      if (Validators.isNotEmptyOrNull(k) && Validators.isNotEmptyOrNull(v)) {
        _headers[k] = v;
      }
    });

    Dio dio = Dio(BaseOptions(
      validateStatus: (status) {
        if (status == 401) {
          debugPrint('Unauthorized');
          MainUtil.showSnack(context, 'Unauthorized', SnackType.ERROR);
          return false;
        }
        return true;
      },
    ));
    Response response;

    final body = jsonEncode(parameters);

    try {
      response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: _headers,
        ),
      );

      if (response.statusCode == 400) {
        MainUtil.showSnack(context, response.data["error"].toString(), SnackType.ERROR);
      }
      if (response.statusCode == 200) {
        return response.data;
      }
      debugPrint('Completed --> ' + path);
    } catch (error) {
      debugPrint('Error: $error');

      try {
        final dioError = error as DioError;
        Response errorResponse = dioError.response!;

        BaseResponse errResp = parseErrorResponse(errorResponse);

        throw FlutterError(errResp.message ?? '$error');
      } catch (e) {
        debugPrint('$e');

        throw FlutterError('$e');
      }
    }
  }

  parseListResponse(Response response) {
    List rsp = response.data;

    var resp = BaseResponse(
      data: rsp,
    );

    return resp;
  }

  parseErrorResponse(Response response) {
    Map<String, dynamic> rsp = response.data;

    int errorCode = MapUtil.getInt(rsp, ERROR_CODE);
    String message = rsp[EXCEPTION_MSG] ?? rsp[MESSAGE];
    final messages = rsp[MESSAGES];
    final data = rsp[DATA];

    final token = response.headers.value('Token');

    var resp = BaseResponse(
      errorCode: errorCode,
      message: message,
      messages: messages,
      data: data,
      token: token,
    );

    return resp;
  }

  get(
    BuildContext context,
    fullPath,
    Map headers,
    bool showLoading, {
    bool isDataResponse = false,
    bool isLogin = false,
  }) async {
    debugPrint('Calling --> ' + fullPath);
    final url = BASE_URL + fullPath;

    Dio dio = Dio();
    Response response;

    try {
      response = await dio.get(
        url,
        options: Options(
          headers: _headers,
        ),
      );

      debugPrint('Completed --> ' + fullPath);
      if (response.statusCode == 400) {
        MainUtil.showSnack(context, response.data["error"].toString(), SnackType.ERROR);
      }
      if (response.statusCode == 200) {
        return response.data;
      }
      return response.data;
    } catch (error) {
      debugPrint('Error: $error');

      try {
        final dioError = error as DioError;
        Response errorResponse = dioError.response!;

        BaseResponse errResp = parseErrorResponse(errorResponse);

        throw FlutterError(errResp.message ?? '$error');
      } catch (e) {
        debugPrint('$e');

        throw FlutterError('$error');
      }
    }
  }
}
