import '../utils/map_util.dart';

class Merchant {
  int merchantId = 0;
  String? hostNumber;
  String? companyName;
  String? contactPhone;
  String? contactMail;
  String? contactFullName;
  String? city;
  String? district;
  String? address;
  int statu = 0;
  int merchantType = 0;
  bool isUseManuelBatchClose = false;
  int catgoryId = 0;
  String? webUrl;
  int createBy = 0;
  DateTime? createDate;
  int updateBy = 0;
  DateTime? updateDate;
  double totalMaxAmount = 0.0;
  double dailyMaxAmount = 0.0;
  bool? isUseSoftPos = false;
  int userId = 0;
  String? filePath;
  int parentMerchantId = 0;
  double commissionRate = 0.0;
  double commissionAmount = 0.0;
  double parentCommissionRate = 0.0;
  bool autoBatchClose = false;

  Merchant.fromJson(Map<String, dynamic> json) {
    merchantId = MapUtil.getInt(json, 'merchantId');
    hostNumber = MapUtil.getString(json, 'hostNumber');
    companyName = MapUtil.getString(json, 'companyName');
    contactPhone = MapUtil.getString(json, 'contactPhone');
    contactMail = MapUtil.getString(json, 'contactMail');
    contactFullName = MapUtil.getString(json, 'contactFullName');
    city = MapUtil.getString(json, 'city');
    district = MapUtil.getString(json, 'district');
    address = MapUtil.getString(json, 'address');
    statu = MapUtil.getInt(json, 'statu');
    merchantType = MapUtil.getInt(json, 'merchantType');
    isUseManuelBatchClose = MapUtil.getBool(json, 'isUseManuelBatchClose');
    catgoryId = MapUtil.getInt(json, 'catgoryId');
    webUrl = MapUtil.getString(json, 'webUrl');
    createBy = MapUtil.getInt(json, 'createBy');
    createDate = MapUtil.getDateTime(json, 'createDate');
    updateBy = MapUtil.getInt(json, 'updateBy');
    updateDate = MapUtil.getDateTime(json, 'updateDate');
    totalMaxAmount = MapUtil.getDouble(json, 'totalMaxAmount');
    dailyMaxAmount = MapUtil.getDouble(json, 'dailyMaxAmount');
    userId = MapUtil.getInt(json, 'userId');
    isUseSoftPos = MapUtil.getBool(json, 'isUseSoftPos');
    parentMerchantId = MapUtil.getInt(json, 'parentMerchantId');
    commissionRate = MapUtil.getDouble(json, 'commissionRate');
    commissionAmount = MapUtil.getDouble(json, 'commissionAmount');
    parentCommissionRate = MapUtil.getDouble(json, 'parentCommissionRate');
    autoBatchClose = MapUtil.getBool(json, 'autoBatchClose');
    filePath = MapUtil.getString(json, 'filePath');
  }
}
