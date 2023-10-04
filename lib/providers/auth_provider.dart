import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voco/enums/snack_type.dart';
import 'package:voco/models/base_model.dart';
import 'package:voco/providers/base_provider.dart';
import 'package:voco/utils/main_util.dart';
import 'package:voco/utils/routes.dart';

class AuthProvider extends BaseProvider {
  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      dynamic response = await post(
        context,
        Routes.API_LOGIN,
        {
          "email": email,
          "password": password,
        },
        {},
        false,
      );

      if (response == null) {
        return false;
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', response['token']);
      return true;
    } catch (e) {
      debugPrint('Error occurred on AuthProvider.login() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }
    return false;
  }
}
