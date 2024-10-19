import '../../utils/map_util.dart';

class RegistrationRequest {
  String? firstName;
  String? lastName;
  String? gsmNumber;
  String? email;
  String? contractVersion;
  int kvkkVersion = 0;
  int districtId = 0;
  int cityId = 0;
  String? referenceCode;

  /// Commercial -> MerchantType = 1
  /// Individual -> MerchantType = 3
  bool isCommercial = false;

  String? taxNumber;
  String? taxCompany;
  String? companyName;
  String? companyTitle;
  String? webUrl;
  String? address;

  RegistrationRequest({
    this.firstName,
    this.lastName,
    this.gsmNumber,
    this.email,
    this.contractVersion,
    this.kvkkVersion = 0,
    this.districtId = 0,
    this.cityId = 0,
    this.isCommercial = false,
    this.referenceCode,
    this.address,
    this.webUrl,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    MapUtil.add(data, 'firstName', firstName, includeNull: true);
    MapUtil.add(data, 'lastName', lastName, includeNull: true);
    MapUtil.add(data, 'gsmNumber', gsmNumber);
    MapUtil.add(data, 'email', email);
    MapUtil.add(data, 'contractVersion', contractVersion);
    MapUtil.add(data, 'kvkkVersion', kvkkVersion);
    MapUtil.add(data, 'districtId', districtId);
    MapUtil.add(data, 'cityId', cityId);
    MapUtil.add(data, 'merchantType', isCommercial ? 1 : 3);
    MapUtil.add(data, 'taxNumber', taxNumber);
    MapUtil.add(data, 'taxCompany', taxCompany);
    MapUtil.add(data, 'companyName', companyName);
    MapUtil.add(data, 'companyTitle', companyTitle);
    MapUtil.add(data, 'webUrl', webUrl);
    MapUtil.add(data, 'referenceCode', referenceCode);
    MapUtil.add(data, 'address', address);

    return data;
  }
}

/*
{
  "firstName": "string",
  "lastName": "string",
  "gsmNumber": "string",
  "taxNumber": "string",
  "taxCompany": "string",
  "companyName": "string",
  "companyTitle": "string",
  "webUrl": "string",
  "merchantType": 0,
  "email": "string",
  "contractVersion": "string",
  "kvkkVersion": 0,
  "districtId": 0
}
*/
