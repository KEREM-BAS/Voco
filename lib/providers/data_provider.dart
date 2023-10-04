import 'package:flutter/material.dart';
import 'package:voco/enums/snack_type.dart';
import 'package:voco/models/users.dart';
import 'package:voco/providers/base_provider.dart';
import 'package:voco/utils/main_util.dart';
import 'package:voco/utils/routes.dart';

class DataProvider extends BaseProvider {
  Future<UserData?> getData(
    BuildContext context,
    int page,
  ) async {
    try {
      dynamic response = await get(
        context,
        Routes.API_GET_USER,
        {},
        false,
      );

      if (response == null) {
        return null;
      }

      return UserData.fromJson(response);
    } catch (e) {
      debugPrint('Error occurred on DataProvider.getData() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }
    return null;
  }
}
