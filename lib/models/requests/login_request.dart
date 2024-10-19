import '../../utils/map_util.dart';

class LoginRequest {
  String userName;
  String password;
  String lat;
  String long;
  String? version;

  LoginRequest({
    required this.userName,
    required this.password,
    this.lat = '0.0',
    this.long = '0.0',
    this.version,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    MapUtil.add(data, 'userName', userName);
    MapUtil.add(data, 'password', password);
    MapUtil.add(data, 'lat', lat);
    MapUtil.add(data, 'long', long);
    MapUtil.add(data, 'version', version);
    return data;
  }
}
