import 'package:easy_localization/easy_localization.dart';
import 'package:voco/utils/session.dart';

import '../utils/map_util.dart';

class PaymentTransaction {
  int paymentTransactionID = 0;
  String? orderId;
  double amount = 0.0;
  String? pan;
  String? kartHolderName;
  int transactionType = 0;
  DateTime? createDate;
  String? responseMessage;
  String? responseCode;
  String? pfHostId;
  int transactionStatus = 0;
  int merchantId = 0;
  String? hostTransactionId;
  double commission = 0.0;
  double parentCommission = 0.0;
  DateTime? transactionRequestDate;
  int terminalId = 0;
  int batchId = 0;
  String? companyName;
  int totalCount = 0;
  int installmentCount = 1;
  String? terminalUserName;
  int currencyCode = 949;
  String? currency;

  PaymentTransaction.fromJson(Map<String, dynamic> json) {
    paymentTransactionID = MapUtil.getInt(json, 'paymentTransactionID');
    orderId = MapUtil.getString(json, 'orderId');
    amount = MapUtil.getDouble(json, 'amount');
    pan = MapUtil.getString(json, 'pan');
    kartHolderName = MapUtil.getString(json, 'kartHolderName');
    transactionType = MapUtil.getInt(json, 'transactionType');
    createDate = MapUtil.getDateTime(json, 'createDate');
    responseMessage = MapUtil.getString(json, 'responseMessage');
    responseCode = MapUtil.getString(json, 'responseCode');
    pfHostId = MapUtil.getString(json, 'pfHostId');
    transactionStatus = MapUtil.getInt(json, 'transactionStatus');
    merchantId = MapUtil.getInt(json, 'merchantId');
    hostTransactionId = MapUtil.getString(json, 'hostTransactionId');
    commission = MapUtil.getDouble(json, 'commission');
    parentCommission = MapUtil.getDouble(json, 'parentCommission');
    transactionRequestDate = MapUtil.getDateTime(json, 'transactionRequestDate');
    terminalId = MapUtil.getInt(json, 'terminalId');
    batchId = MapUtil.getInt(json, 'batchId');
    companyName = MapUtil.getString(json, 'companyName');
    totalCount = MapUtil.getInt(json, 'totalCount');
    installmentCount = MapUtil.getInt(json, 'installmentCount');
    terminalUserName = MapUtil.getString(json, 'terminalUserName');
    currencyCode = MapUtil.getInt(json, 'currencyCode');
    currency = MapUtil.getString(json, 'currency');
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentTransactionID': paymentTransactionID,
      'orderId': orderId,
      'amount': amount,
      'pan': pan,
      'kartHolderName': kartHolderName,
      'transactionType': transactionType,
      'createDate': createDate != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(createDate!) : null,
      'responseMessage': responseMessage,
      'responseCode': responseCode,
      'pfHostId': pfHostId,
      'transactionStatus': transactionStatus,
      'merchantId': merchantId,
      'hostTransactionId': hostTransactionId,
      'commission': commission,
      'parentCommission': parentCommission,
      'transactionRequestDate': transactionRequestDate != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(transactionRequestDate!) : null,
      'terminalId': terminalId,
      'batchId': batchId,
      'companyName': companyName,
      'totalCount': totalCount,
      'installmentCount': installmentCount,
      'terminalUserName': terminalUserName,
      'currencyCode': currencyCode,
      'currency': currency,
      "title": Session.instance.merchant?.companyName,
    };
  }
}




/*

{
    "paymentTransactionID": 220,
    "orderId": "effddab5c1ed4cca9363fa7513ee0a33",
    "amount": 100.0,
    "pan": "123456******5678",
    "kartHolderName": "sdf sdf",
    "transactionType": 1,
    "createDate": "2023-04-04T13:47:51.357",
    "responseMessage": "ok",
    "responseCode": "0000",
    "pfHostId": 1,
    "transactionStatus": 1,
    "merchantId": 1,
    "hostTransactionId": null,
    "commission": 5.0,
    "parentCommission": null,
    "transactionRequestDate": "2023-04-04T13:47:51.483",
    "terminalId": 1,
    "batchId": 5,
    "companyName": "Arif Comp",
    "totalCount": 140
}

*/