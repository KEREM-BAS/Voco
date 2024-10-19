import '../utils/map_util.dart';

class MerchantDocument {
  int documentId = 0;
  int merchantId = 0;
  String? fileName;
  String? filePath;
  int status = 0;
  int userId = 0;

  MerchantDocument.fromJson(Map<String, dynamic> json) {
    documentId = MapUtil.getInt(json, 'documentId');
    merchantId = MapUtil.getInt(json, 'merchantId');
    fileName = MapUtil.getString(json, 'fileName');
    filePath = MapUtil.getString(json, 'filePath');
    status = MapUtil.getInt(json, 'status');
    userId = MapUtil.getInt(json, 'userId');
  }
}

/*
{
  "documentId": 267,
  "fileName": "KimlikArka",
  "filePath": "C:\\MerchantDocuments\\177C394279E84CD78EB4AEBC3AB4A916.png",
  "status": 2,
  "createBy": 68,
  "createDate": "2023-06-05T17:26:12.177",
  "updateBy": null,
  "updateDate": null,
  "userId": 68,
  "merchantId": 10
}
*/