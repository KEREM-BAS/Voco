import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
