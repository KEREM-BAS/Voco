import 'package:flutter/material.dart';

import '../../utils/map_util.dart';

class TransactionResult {
  String? paymentId;
  String? orderId;
  double amount = 0.0;
  int installment = 1;
  String? paymentStatus;
  String? errorMessage;
  String? errorCode;
  int statusId = 0;

  TransactionResult.fromJson(Map<String, dynamic> json) {
    debugPrint('TransactionResult : $json');

    paymentId = MapUtil.getString(json, 'paymentId');
    orderId = MapUtil.getString(json, 'orderId');
    amount = MapUtil.getDouble(json, 'amount');
    installment = MapUtil.getInt(json, 'installment');
    paymentStatus = MapUtil.getString(json, 'status');
    errorMessage = MapUtil.getString(json, 'message');
    errorCode = MapUtil.getString(json, 'code');
    statusId = MapUtil.getInt(json, 'statusId');

    // code'da statusId gelecek
    // 1 - Pending
    // 3 - Success
  }

  @override
  String toString() {
    return '{"paymentId": "$paymentId", "orderId": "$orderId", "amount": $amount, "installment": $installment, "status": "$paymentStatus", "message": "$errorMessage", "code": "$errorCode", "statusId": $statusId}';
  }

  // TransactionStatus getStatus() {
  //   TransactionStatus status = TransactionStatus.ERROR;
  //   switch (statusId) {
  //     case 1:
  //       status = TransactionStatus.PENDING;
  //       break;
  //     case 3:
  //       status = TransactionStatus.SUCCESSFUL;
  //       break;
  //     default:
  //   }
  //   return status;
  // }
}

/*

{
    "paymentId": "b7e80ed7-1a21-4add-2925-08db359e8039",
    "orderId": "20230411020544797",
    "amount": 1.0,
    "installment": 1,
    "paymentStatus": "Pending",
    "card": {
        "binNumber": "450634",
        "lastFourDigits": "7967",
        "type": "Credit",
        "brand": "World",
        "category": "Individual",
        "bankName": "YAPI VE KREDİ BANKASI A.Ş."
    },
    "earnedPoint": 0.0,
    "earnedPointAmount": 0.0,
    "usedPoint": 0.0,
    "usedPointAmount": 0.0,
    "paymentSecurityMode": "3D",
    "errorMessage": null,
    "errorCode": null,
    "transactions": []
}

*/