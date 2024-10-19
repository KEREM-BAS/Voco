import '../../utils/map_util.dart';
import '../../utils/validators.dart';

class SaleTransactionRequest {
  int merchantId = 0;
  int userId = 0;
  double amount = 0.0;
  int currencyCode = 0;
  String? orderId;
  int installment = 1;
  String cardHolderName;
  String cardNumber;
  String expireYear;
  String expireMonth;
  String cvc;
  String terminalName;
  String? clientIP;
  bool isSecureTransaction = true;
  String? linkSaleDescription;

  SaleTransactionRequest({
    required this.merchantId,
    required this.userId,
    required this.amount,
    required this.currencyCode,
    this.orderId,
    this.installment = 1,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expireYear,
    required this.expireMonth,
    required this.cvc,
    required this.terminalName,
    this.clientIP,
    this.isSecureTransaction = true,
    this.linkSaleDescription,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    MapUtil.add(data, 'merchantId', merchantId);
    MapUtil.add(data, 'userId', userId);
    MapUtil.add(data, 'amount', amount);
    MapUtil.add(data, 'currencyCode', currencyCode);
    MapUtil.add(data, 'orderId', orderId);
    MapUtil.add(data, 'installment', installment);
    MapUtil.add(data, 'cardHolderName', Validators.isEmptyOrNull(cardHolderName) ? 'HST Pos' : cardHolderName);
    MapUtil.add(data, 'cardNumber', cardNumber);
    MapUtil.add(data, 'expireYear', expireYear);
    MapUtil.add(data, 'expireMonth', expireMonth);
    MapUtil.add(data, 'cvc', cvc);
    MapUtil.add(data, 'terminalName', terminalName);
    MapUtil.add(data, 'clientIP', clientIP);
    MapUtil.add(data, 'isSecureTransaction', isSecureTransaction);
    MapUtil.add(data, 'customerGSM', '', includeNull: true);
    MapUtil.add(data, 'customerEmail', '', includeNull: true);
    MapUtil.add(data, 'linkSaleDescription', '', includeNull: true);
    return data;
  }
}
