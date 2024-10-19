import '../utils/map_util.dart';

class MobileInfo {
  int id = 0;
  int userID = 0;
  String? phoneBrand;
  String? model;
  String? gcm;
  String? seriNo;
  String? nameOfOs;
  String? osVersion;
  DateTime? createDate;
  String? appVersion;
  String? buildNumber;
  int? createBy;
  bool statu = false;
  DateTime? updateDate;
  int? updateBy;

  MobileInfo({
    this.id = 0,
    this.userID = 0,
    this.phoneBrand,
    this.model,
    this.gcm,
    this.seriNo,
    this.nameOfOs,
    this.osVersion,
    this.createDate,
    this.createBy,
    this.statu = false,
    this.updateBy,
    this.updateDate,
    this.appVersion,
    this.buildNumber,
  });

  MobileInfo.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    userID = MapUtil.getInt(json, 'userID');
    phoneBrand = MapUtil.getString(json, 'phoneBrand');
    model = MapUtil.getString(json, 'model');
    gcm = MapUtil.getString(json, 'gcm');
    seriNo = MapUtil.getString(json, 'seriNo');
    nameOfOs = MapUtil.getString(json, 'nameOfOs');
    osVersion = MapUtil.getString(json, 'osVersion');
    createDate = MapUtil.getDateTime(json, 'createDate');
    createBy = MapUtil.getInt(json, 'createBy');
    statu = MapUtil.getBool(json, 'statu');
    updateBy = MapUtil.getInt(json, 'updateBy');
    updateDate = MapUtil.getDateTime(json, 'updateDate');
    appVersion = MapUtil.getString(json, 'appVersion');
    buildNumber = MapUtil.getString(json, 'buildNumber');
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    MapUtil.add(data, 'userID', userID);
    MapUtil.add(data, 'phoneBrand', phoneBrand);
    MapUtil.add(data, 'model', model);
    MapUtil.add(data, 'gcm', gcm);
    MapUtil.add(data, 'seriNo', seriNo);
    MapUtil.add(data, 'nameOfOs', nameOfOs);
    MapUtil.add(data, 'osVersion', osVersion);
    MapUtil.add(data, 'statu', statu);
    MapUtil.add(data, 'createDate', createDate);
    MapUtil.add(data, 'createBy', createBy);
    MapUtil.add(data, 'updateDate', updateDate);
    MapUtil.add(data, 'updateBy', updateBy);
    MapUtil.add(data, 'appVersion', appVersion);
    MapUtil.add(data, 'buildNumber', buildNumber);

    return data;
  }
}
