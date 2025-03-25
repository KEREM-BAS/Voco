import '../utils/map_util.dart';

class SoftposRates {
  int merchantId;
  double softRate1;
  double softRate2;
  double paymentRange1;

  SoftposRates({
    required this.merchantId,
    required this.softRate1,
    required this.softRate2,
    required this.paymentRange1,
  });

  factory SoftposRates.fromJson(Map<String, dynamic> json) {
    return SoftposRates(
      merchantId: MapUtil.getInt(json, 'merchantId'),
      softRate1: MapUtil.getDouble(json, 'softRate1'),
      softRate2: MapUtil.getDouble(json, 'softRate2'),
      paymentRange1: MapUtil.getDouble(json, 'paymentRange1'),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    MapUtil.add(data, 'merchantId', merchantId);
    MapUtil.add(data, 'softRate1', softRate1);
    MapUtil.add(data, 'softRate2', softRate2);
    MapUtil.add(data, 'paymentRange1', paymentRange1);
    return data;
  }
}
