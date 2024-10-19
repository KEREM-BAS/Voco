import '../utils/map_util.dart';

class Bank {
  int id = 0;
  int merchantId = 0;
  String? bankCode;
  String? bankName;
  String? displayName;
  int statuId = 0;
  DateTime? createDate;
  DateTime? updateDate;
  DateTime? validFrom;
  DateTime? validThru;
  String? userName;
  String? password;
  int? createById;
  int? updateById;

  Bank({
    this.id = 0,
  });

  Bank.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    merchantId = MapUtil.getInt(json, 'merchantId');
    bankCode = MapUtil.getString(json, 'bankCode');
    bankName = MapUtil.getString(json, 'bankName');
    displayName = MapUtil.getString(json, 'displayName');
    statuId = MapUtil.getInt(json, 'statuId');
    createDate = MapUtil.getDateTime(json, 'createDate');
    updateDate = MapUtil.getDateTime(json, 'updateDate');
    validFrom = MapUtil.getDateTime(json, 'validFrom');
    validThru = MapUtil.getDateTime(json, 'validThru');
    userName = MapUtil.getString(json, 'userName');
    password = MapUtil.getString(json, 'password');
    createById = MapUtil.getInt(json, 'createById');
    updateById = MapUtil.getInt(json, 'updateById');
  }

  @override
  String toString() {
    return '$bankName';
  }
}
