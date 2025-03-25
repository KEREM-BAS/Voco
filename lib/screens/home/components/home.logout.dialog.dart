import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voco/utils/form_util.dart';

import '../../../utils/routes.dart';
import '../../../utils/session.dart';

Future<bool> homeLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.remove('TOKEN-${Session.instance.loggedInUser != null ? Session.instance.loggedInUser!.gsmNumber! : ''}');
              await pref.remove('USER_NAME');
              await pref.remove('USER_PASSWORD');
              Session.instance.clear();
              Navigator.of(context).pushNamedAndRemoveUntil(Routes.LOGIN, ModalRoute.withName("/login"));
            },
            child: const Text('Evet'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

Future<bool> onBackPressed(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Dikkat'),
          titleTextStyle: const TextStyle(color: Colors.grey, fontSize: 24),
          content: const Text(
            'Uygulamadan çıkmak istediğinize emin misiniz?',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: <Widget>[
            FormUtil.elevatedButton(
              () => Navigator.of(context).pop(false),
              false,
              "İptal",
              100,
              10,
              buttonColor: Colors.grey,
              fontSize: 16,
              height: 40,
            ),
            const SizedBox(height: 16),
            FormUtil.elevatedButton(
              () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
              false,
              "Çıkış",
              100,
              10,
              fontSize: 16,
              height: 40,
            ),
          ],
        ),
      ) ??
      false;
}
