import '../utils/map_util.dart';

class Terminal {
  int id = 0;
  String? terminalName;
  String? terminalCode;
  String? terminalStatus;
  int createBy = 0;
  DateTime? createDate;
  int updateBy = 0;
  DateTime? updateDate;
  String? userName;
  String? userPassword;
  bool isOtoBatch = false;
  int cityId = 0;
  int districtId = 0;
  String? address;
  int categoryId = 0;
  String? lat;
  String? long;
  int merchantId = 0;

  Terminal();

  Terminal.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    terminalName = MapUtil.getString(json, 'terminalName');
    terminalCode = MapUtil.getString(json, 'terminalCode');
    terminalStatus = MapUtil.getString(json, 'terminalStatus');
    createBy = MapUtil.getInt(json, 'createBy');
    createDate = MapUtil.getDateTime(json, 'createDate');
    updateBy = MapUtil.getInt(json, 'updateBy');
    updateDate = MapUtil.getDateTime(json, 'updateDate');
    userName = MapUtil.getString(json, 'userName');
    userPassword = MapUtil.getString(json, 'userPassword');
    isOtoBatch = MapUtil.getBool(json, 'isOtoBatch');
    cityId = MapUtil.getInt(json, 'cityId');
    districtId = MapUtil.getInt(json, 'districtId');
    address = MapUtil.getString(json, 'address');
    categoryId = MapUtil.getInt(json, 'categoryId');
    lat = MapUtil.getString(json, 'lat');
    long = MapUtil.getString(json, 'long');
    merchantId = MapUtil.getInt(json, 'merchantId');
  }
}

/** 
{
  "id": 3,
  "terminalName": "TestPos BM",
  "terminalCode": "terminal_65",
  "terminalStatus": "1",
  "createBy": 1,
  "createDate": "2023-03-02T00:00:00",
  "updateBy": null,
  "updateDate": null,
  "userName": "Kasa_965",
  "userPassword": "85",
  "isOtoBatch": false,
  "cityId": 1,
  "districtId": 1,
  "address": "Deneme Aders",
  "categoryId": 1,
  "lat": "test",
  "long": "test",
  "merchantId": 7
}
*/