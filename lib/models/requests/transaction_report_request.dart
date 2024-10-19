import '../../utils/map_util.dart';

class TransactionReportRequest {
  int terminalID = 0;
  int merchantId = 0;
  String? startDate;
  String? endDate;
  int transactionTypes = 0;
  int transactionStatus = 0;
  String orderNumber = '';
  String transactionId = '';
  int batchId = 0;
  int pageNumber = 1;
  int pageCount = 20;
  bool isAsc = true;
  bool isAllReport = false;
  int currencyCode = 0;

  TransactionReportRequest({
    this.terminalID = 0,
    this.merchantId = 0,
    this.startDate,
    this.endDate,
    this.transactionTypes = 0,
    this.transactionStatus = 0,
    this.orderNumber = '',
    this.transactionId = '',
    this.batchId = 0,
    this.pageNumber = 1,
    this.pageCount = 20,
    this.isAsc = true,
    this.isAllReport = false,
    this.currencyCode = 0,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    MapUtil.add(data, 'terminalID', terminalID);
    MapUtil.add(data, 'merchantId', merchantId);
    MapUtil.add(data, 'startDate', startDate);
    MapUtil.add(data, 'endDate', endDate);
    MapUtil.add(data, 'transactionTypes', transactionTypes == 0 ? null : transactionTypes, includeNull: true);
    MapUtil.add(data, 'transactionStatus', transactionStatus == 0 ? null : transactionStatus, includeNull: true);
    data['orderNumber'] = orderNumber;
    data['transactionId'] = transactionId;
    MapUtil.add(data, 'batchId', batchId == 0 ? null : batchId);
    MapUtil.add(data, 'pageNumber', pageNumber);
    MapUtil.add(data, 'pageCount', pageCount);
    MapUtil.add(data, 'isAsc', isAsc);
    MapUtil.add(data, 'isAllReport', isAllReport);
    MapUtil.add(data, 'currencyCode', currencyCode);
    return data;
  }
}
