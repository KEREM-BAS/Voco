import '../utils/map_util.dart';
import '../utils/validators.dart';

class MerchantBank {
  int id = 0;
  String? bankCode;
  String? bankBranch;
  String? bankName;
  String? iban;
  int merchantId = 0;
  bool isDefault = false;
  String? displayName;
  int logicDeleteKey = 0;
  DateTime? createDate;
  int? createById;
  DateTime? updateDate;
  int? updateById;

  MerchantBank({
    this.id = 0,
    this.bankCode,
    this.bankBranch,
    this.bankName,
    this.iban,
    this.merchantId = 0,
    this.isDefault = false,
    this.displayName,
    this.logicDeleteKey = 0,
    this.createDate,
    this.createById,
    this.updateDate,
    this.updateById,
  });

  MerchantBank.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    bankCode = MapUtil.getString(json, 'bankCode');
    bankBranch = MapUtil.getString(json, 'bankBranch');
    bankName = MapUtil.getString(json, 'bankName');
    iban = MapUtil.getString(json, 'iban');
    if (iban == null || Validators.isEmptyOrNull(iban)) {
      iban = MapUtil.getString(json, 'ibanNumber');
    }
    merchantId = MapUtil.getInt(json, 'merchantId');
    isDefault = MapUtil.getBool(json, 'isDefaultBank');
    displayName = MapUtil.getString(json, 'displayName');
    logicDeleteKey = MapUtil.getInt(json, 'logicDeleteKey');
    createDate = MapUtil.getDateTime(json, 'createDate');
    createById = MapUtil.getInt(json, 'createById');
    updateDate = MapUtil.getDateTime(json, 'updateDate');
    updateById = MapUtil.getInt(json, 'updateById');
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    MapUtil.add(data, 'id', id);
    MapUtil.add(data, 'bankCode', bankCode);
    MapUtil.add(data, 'bankBranch', bankBranch);
    MapUtil.add(data, 'iban', iban);
    MapUtil.add(data, 'merchantId', merchantId);
    MapUtil.add(data, 'isDefault', isDefault);
    MapUtil.add(data, 'displayName', displayName);
    MapUtil.add(data, 'logicDeleteKey', logicDeleteKey);
    MapUtil.add(data, 'createDate', createDate);
    MapUtil.add(data, 'createById', createById);
    MapUtil.add(data, 'updateDate', updateDate);
    MapUtil.add(data, 'updateById', updateById);

    return data;
  }
}
