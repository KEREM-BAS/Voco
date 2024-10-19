import '../utils/map_util.dart';

class BatchReport {
  int id = 0;
  int batchId = 0;
  int totalSumSaleCount = 0;
  double totalSumSaleAmount = 0.0;
  DateTime? createDate;
  int merchantId = 0;
  int terminalId = 0;
  double totalAmount = 0.0;
  int totalCount = 0;
  int currencyCode = 0;
  int totalCancelCount = 0;
  double totalCancelAmount = 0.0;
  int merchantInvoiceId = 0;
  int batchSumStatus = 0;

  BatchReport.fromJson(Map<String, dynamic> json) {
    id = MapUtil.getInt(json, 'id');
    batchId = MapUtil.getInt(json, 'batchId');
    totalSumSaleCount = MapUtil.getInt(json, 'totalSumSaleCount');
    totalSumSaleAmount = MapUtil.getDouble(json, 'totalSumSaleAmount');
    createDate = MapUtil.getDateTime(json, 'createDate');
    merchantId = MapUtil.getInt(json, 'merchantId');
    terminalId = MapUtil.getInt(json, 'terminalId');
    totalAmount = MapUtil.getDouble(json, 'totalAmount');
    totalCount = MapUtil.getInt(json, 'totalCount');
    currencyCode = MapUtil.getInt(json, 'currencyCode');
    totalCancelCount = MapUtil.getInt(json, 'totalCancelCount');
    totalCancelAmount = MapUtil.getDouble(json, 'totalCancelAmount');
    merchantInvoiceId = MapUtil.getInt(json, 'merchantInvoiceId');
    batchSumStatus = MapUtil.getInt(json, 'batchSumStatus');
  }
}

/*
{
  "id": 6,
  "batchId": 9,
  "totalSumSaleCount": 142,
  "totalSumSaleAmount": 3114.22,
  "createDate": "2023-04-20T12:49:35.847",
  "merchantId": 7,
  "terminalId": 3,
  "totalAmount": 3114.22,
  "totalCount": 142,
  "currencyCode": 949,
  "totalCancelCount": 0,
  "totalCancelAmount": 0,
  "merchantInvoiceId": null,
  "batchSumStatus": 1
}
*/