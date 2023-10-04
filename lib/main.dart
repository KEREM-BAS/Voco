import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voco/screens/home/home_screen.dart';
import 'package:voco/screens/intro/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool tokenExists = pref.containsKey('token');

  await readPrefs();
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: tokenExists ? HomeScreen() : LoginScreen(),
      ),
    ),
  );
}

readPrefs() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey('token')) {
    debugPrint('token = ${pref.getString('token')}');
  } else {}
}
