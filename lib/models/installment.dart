import '../utils/map_util.dart';

class Installment {
  int id = 0;
  int installmentCount = 0;
  double minAmount = 0.0;
  double maxAmount = 0.0;
  double fixedAmount = 0.0;
  double commissionRatio = 0.0;
  bool isActive = true;

  Installment({
    this.id = 0,
    this.installmentCount = 0,
    this.minAmount = 0.0,
    this.maxAmount = 0.0,
    this.fixedAmount = 0.0,
    this.commissionRatio = 0.0,
    this.isActive = true,
  });

  Installment.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    installmentCount = MapUtil.getInt(json, 'installmentCount');
    minAmount = MapUtil.getDouble(json, 'minAmount');
    maxAmount = MapUtil.getDouble(json, 'maxAmount');
    fixedAmount = MapUtil.getDouble(json, 'fixedAmount');
    commissionRatio = MapUtil.getDouble(json, 'commissionRatio');
    isActive = MapUtil.getBool(json, 'isActive');
  }

  @override
  String toString() {
    return installmentCount == 1 ? 'Tek Çekim' : '$installmentCount Taksit';
  }
}

/*
{
  "id": 1,
  "installmentCount": 1,
  "minAmount": 0,
  "maxAmount": 1000000,
  "fixedAmount": 0,
  "commissionRatio": 2.85,
  "isActive": true
}
*/