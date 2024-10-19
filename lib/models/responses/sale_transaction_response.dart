import '../../utils/map_util.dart';
import '../../utils/validators.dart';

class SaleTransactionResponse {
  String? orderId;
  String? paymentId;
  String? returnUrl;
  String? errorCode;
  String? status;
  String? paymentData;
  bool hasError = false;
  int returnType = 0;

  SaleTransactionResponse({
    this.orderId,
    this.paymentId,
    this.returnUrl,
    this.errorCode,
    this.status,
    this.paymentData,
    this.returnType = 0,
  });

  SaleTransactionResponse.fromJson(Map<String, dynamic> json) {
    orderId = MapUtil.getString(json, 'orderId');
    paymentId = MapUtil.getString(json, 'paymentId');
    returnUrl = MapUtil.getString(json, 'returnUrl');
    errorCode = MapUtil.getString(json, 'errorCode');
    status = MapUtil.getString(json, 'status');
    paymentData = MapUtil.getString(json, 'paymentData');
    hasError = Validators.isNotEmptyOrNull(errorCode) && errorCode != '0' && errorCode != '00';
    returnType = MapUtil.getInt(json, 'returnType');
  }
}
