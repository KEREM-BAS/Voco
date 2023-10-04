import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tokenProvider = FutureProvider<String>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? existingToken = prefs.getString('token');
  return existingToken ?? '';
});
