import '../utils/map_util.dart';

class Token {
  String? token;
  DateTime? expiration;
  int status = 0;

  Token({
    this.token,
    this.expiration,
    this.status = 0,
  });

  Token.fromJson(Map<String, dynamic> json) {
    token = MapUtil.getString(json, 'token');
    expiration = MapUtil.getDateTime(json, 'expiration');
    status = MapUtil.getInt(json, 'status');
  }
}
