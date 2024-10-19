import '../../utils/map_util.dart';

class ActivationRequest {
  String activationCode;
  String? userName;

  ActivationRequest({
    required this.activationCode,
    this.userName,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    MapUtil.add(data, 'activationCode', activationCode);
    MapUtil.add(data, 'userName', userName);
    return data;
  }
}
