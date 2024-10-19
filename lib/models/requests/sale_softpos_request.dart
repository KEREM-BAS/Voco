import '../../utils/map_util.dart';

class SaleSoftposRequest {
  int merchantId = 0;
  int userId = 0;
  double amount = 0.0;
  int currencyCode = 0;
  String? orderId;
  int installment = 1;
  String terminalName;
  int? terminalId;
  String? clientIP;
  bool isSecureTransaction = true;
  String? linkSaleDescription;
  int? transactionType;
  String? cardHolderName;
  String? cardNumber;
  String? expireYear;
  String? expireMonth;
  String? cvc;

  SaleSoftposRequest({
    required this.merchantId,
    required this.userId,
    required this.amount,
    required this.currencyCode,
    this.orderId,
    this.installment = 1,
    required this.terminalName,
    this.clientIP,
    this.isSecureTransaction = true,
    this.linkSaleDescription,
    this.transactionType,
    this.cardHolderName,
    this.cardNumber,
    this.expireYear,
    this.expireMonth,
    this.cvc,
    this.terminalId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    MapUtil.add(data, 'merchantId', merchantId);
    MapUtil.add(data, 'userId', userId);
    MapUtil.add(data, 'amount', amount);
    MapUtil.add(data, 'currencyCode', currencyCode);
    MapUtil.add(data, 'orderId', orderId);
    MapUtil.add(data, 'installment', installment);
    MapUtil.add(data, 'terminalName', terminalName);
    MapUtil.add(data, 'terminalId', terminalId);
    MapUtil.add(data, 'clientIP', clientIP);
    MapUtil.add(data, 'transactionType', transactionType);
    MapUtil.add(data, 'isSecureTransaction', isSecureTransaction);
    return data;
  }
}


// {
//   "merchantId": 7,
//   "userId": 65,
//   "amount": 2,
//   "currencyCode": 949,
//   "orderId": "34566346345498qqqaaa98GTR23489wrereww9",
//   "installment": 1,
//   "terminalName": "TestPos BM",
//   "terminalId": 3,
//   "clientIP": "127.0.0.1",
//   "isSecureTransaction": true,
//   "customerGSM": "string",
//   "customerEmail": "string",
//   "linkSaleDescription": "string",
//  "callbackUrl": "http:test.com",
//   "transactionType": 4,
// "useMessageBroker": true
// }
