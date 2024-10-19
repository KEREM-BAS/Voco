import '../../utils/map_util.dart';

class LinkSaleRequest {
  int merchantId = 0;
  int userId = 0;
  double amount = 0.0;
  int currencyCode = 949;
  String? orderId;
  int installment = 1;
  String? cardHolderName;
  String? cardNumber;
  int expireYear = 0;
  int expireMonth = 0;
  int cvc = 0;
  String terminalName;
  int terminalId = 0;
  String? clientIP;
  bool isSecureTransaction = true;
  String? customerGSM;
  String? customerEmail;
  String? linkSaleDescription;
  String? callbackUrl;

  LinkSaleRequest({
    required this.merchantId,
    required this.userId,
    this.amount = 0.0,
    this.currencyCode = 949,
    this.orderId = '',
    this.installment = 1,
    this.cardHolderName = '',
    this.cardNumber = '',
    this.expireYear = 0,
    this.expireMonth = 0,
    this.cvc = 0,
    required this.terminalName,
    required this.terminalId,
    this.clientIP = '',
    this.isSecureTransaction = true,
    this.customerGSM = '',
    this.customerEmail = '',
    this.linkSaleDescription,
    this.callbackUrl,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    MapUtil.add(data, 'merchantId', merchantId);
    MapUtil.add(data, 'userId', userId);
    MapUtil.add(data, 'amount', amount);
    MapUtil.add(data, 'currencyCode', currencyCode);
    MapUtil.add(data, 'orderId', orderId, includeNull: true);
    MapUtil.add(data, 'installment', installment);
    MapUtil.add(data, 'cardHolderName', cardHolderName, includeNull: true);
    MapUtil.add(data, 'cardNumber', cardNumber, includeNull: true);
    MapUtil.add(data, 'expireYear', expireYear, includeNull: true);
    MapUtil.add(data, 'expireMonth', expireMonth, includeNull: true);
    MapUtil.add(data, 'cvc', cvc, includeNull: true);
    MapUtil.add(data, 'terminalName', terminalName);
    MapUtil.add(data, 'terminalId', terminalId);
    MapUtil.add(data, 'clientIP', clientIP, includeNull: true);
    MapUtil.add(data, 'isSecureTransaction', isSecureTransaction);
    MapUtil.add(data, 'customerGSM', customerGSM, includeNull: true);
    MapUtil.add(data, 'customerEmail', customerEmail, includeNull: true);
    MapUtil.add(data, 'linkSaleDescription', linkSaleDescription, includeNull: true);
    MapUtil.add(data, 'callbackUrl', callbackUrl);
    return data;
  }
}
