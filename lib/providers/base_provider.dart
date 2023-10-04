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

    if (headers['token'] == null) {
      _headers.remove('token');
    }

    if (headers['Token'] == null) {
      _headers.remove('Token');
    }

    if (headers['lang'] == null) {
      _headers['lang'] = "";
    }

    if (headers['languageId'] == null) {
      _headers['languageId'] = '1';
    }

    headers.forEach((k, v) {
      if (Validators.isNotEmptyOrNull(k) && Validators.isNotEmptyOrNull(v)) {
        _headers[k] = v;
      }
    });

    Dio dio = Dio();
    Response response;

    final body = jsonEncode(parameters);

    try {
      /*
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      */

      response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: _headers,
        ),
      );

      // print('Response: ${response}');
      debugPrint('Completed --> ' + path);
      BaseResponse baseResponse = parseResponse(response, isDataResponse);

      return baseResponse;
    } catch (error) {
      debugPrint('Error: $error');

      try {
        final dioError = error as DioError;
        Response errorResponse = dioError.response!;

        BaseResponse errResp = parseErrorResponse(errorResponse);

        if (errResp.errorCode == 1155 || errResp.errorCode == 2002 || errResp.errorCode == 2003 || errResp.errorCode == 2004) {
          debugPrint('Completed with error: ${errResp.errorCode} --> ' + path);
          return BaseResponse(
            errorCode: errResp.errorCode,
            message: errResp.message,
            data: errResp.data,
          );
        }

        if (!isLogin &&
            errResp.message != null &&
            (errResp.message!.contains('Oturum') ||
                errResp.message!
                    .startsWith('Kullanıcınız uzun süre hareketsiz olduğu için oturum süreniz sonlandırılmıştır. Lütfen yeniden oturum açınız.'))) {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              MainUtil.showSnack(context, errResp.message ?? '', SnackType.ERROR);
            },
          );

          return null;
        }

        throw FlutterError(errResp.message ?? '$error');
      } catch (e) {
        debugPrint('$e');

        throw FlutterError('$e');
      }
    }
  }

  parseResponse(Response response, bool isDataResponse) {
    Map rsp = response.data;

    int errorCode = rsp[ERROR_CODE] ?? 0;
    String? message = rsp[MESSAGE];
    final messages = rsp[MESSAGES];
    final data = isDataResponse ? rsp : rsp[DATA];

    String? token;

    try {
      if (rsp.containsKey('Token') && rsp['Token'] != null) {
        token = rsp['Token'];
      } else {
        token = response.headers.value('Token');
      }
    } catch (e) {
      debugPrint('Error while getting token --> $e');
    }

    var resp = BaseResponse(
      errorCode: errorCode,
      message: message,
      messages: messages,
      data: data,
      token: token,
    );

    return resp;
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

    headers.forEach((k, v) => _headers[k] = v);

    if (headers['token'] == null) {
      _headers.remove('token');
    }

    if (headers['Token'] == null) {
      _headers.remove('Token');
    }

    if (headers['lang'] == null) {
      _headers['lang'] = '';
    }

    if (headers['languageId'] == null) {
      _headers['languageId'] = '1';
    }

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
      BaseResponse baseResponse = isDataResponse ? parseListResponse(response) : parseResponse(response, isDataResponse);

      return baseResponse;
    } catch (error) {
      debugPrint('Error: $error');

      try {
        final dioError = error as DioError;
        Response errorResponse = dioError.response!;

        BaseResponse errResp = parseErrorResponse(errorResponse);

        if (errResp.errorCode == 1155 || errResp.errorCode == 2002 || errResp.errorCode == 2003 || errResp.errorCode == 2004) {
          debugPrint('Completed with error: ${errResp.errorCode} --> ' + fullPath);
          return BaseResponse(
            errorCode: errResp.errorCode,
            message: errResp.message,
            data: errResp.data,
          );
        }

        if (!isLogin &&
            errResp.message != null &&
            (errResp.message!.contains('Oturum') ||
                errResp.message!
                    .startsWith('Kullanıcınız uzun süre hareketsiz olduğu için oturum süreniz sonlandırılmıştır. Lütfen yeniden oturum açınız.'))) {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              MainUtil.showSnack(context, errResp.message ?? '', SnackType.ERROR);
            },
          );

          return null;
        }

        throw FlutterError(errResp.message ?? '$error');
      } catch (e) {
        debugPrint('$e');

        throw FlutterError('$error');
      }
    }
  }
}
