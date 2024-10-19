// To parse this JSON data, do
//
//     final nfcResponse = nfcResponseFromJson(jsonString);

import 'dart:convert';

NfcResponse nfcResponseFromJson(String str) => NfcResponse.fromJson(json.decode(str));

String nfcResponseToJson(NfcResponse data) => json.encode(data.toJson());

class NfcResponse {
  Isodep? isodep;
  Nfca? nfca;

  NfcResponse({
    this.isodep,
    this.nfca,
  });

  factory NfcResponse.fromJson(Map<String, dynamic> json) => NfcResponse(
        isodep: Isodep.fromJson(json["isodep"]),
        nfca: Nfca.fromJson(json["nfca"]),
      );

  Map<String, dynamic> toJson() => {
        "isodep": isodep?.toJson(),
        "nfca": nfca?.toJson(),
      };
}

class Isodep {
  List<int>? identifier;
  dynamic hiLayerResponse;
  List<int>? historicalBytes;
  bool? isExtendedLengthApduSupported;
  int? maxTransceiveLength;
  int? timeout;

  Isodep({
    this.identifier,
    this.hiLayerResponse,
    this.historicalBytes,
    this.isExtendedLengthApduSupported,
    this.maxTransceiveLength,
    this.timeout,
  });

  factory Isodep.fromJson(Map<String, dynamic> json) => Isodep(
        identifier: List<int>.from(json["identifier"].map((x) => x)),
        hiLayerResponse: json["hiLayerResponse"],
        historicalBytes: List<int>.from(json["historicalBytes"].map((x) => x)),
        isExtendedLengthApduSupported: json["isExtendedLengthApduSupported"],
        maxTransceiveLength: json["maxTransceiveLength"],
        timeout: json["timeout"],
      );

  Map<String, dynamic> toJson() => {
        "identifier": List<dynamic>.from(identifier!.map((x) => x)),
        "hiLayerResponse": hiLayerResponse,
        "historicalBytes": List<dynamic>.from(historicalBytes!.map((x) => x)),
        "isExtendedLengthApduSupported": isExtendedLengthApduSupported,
        "maxTransceiveLength": maxTransceiveLength,
        "timeout": timeout,
      };
}

class Nfca {
  List<int>? identifier;
  List<int>? atqa;
  int? maxTransceiveLength;
  int? sak;
  int? timeout;

  Nfca({
    this.identifier,
    this.atqa,
    this.maxTransceiveLength,
    this.sak,
    this.timeout,
  });

  factory Nfca.fromJson(Map<String, dynamic> json) => Nfca(
        identifier: List<int>.from(json["identifier"].map((x) => x)),
        atqa: List<int>.from(json["atqa"].map((x) => x)),
        maxTransceiveLength: json["maxTransceiveLength"],
        sak: json["sak"],
        timeout: json["timeout"],
      );

  Map<String, dynamic> toJson() => {
        "identifier": List<dynamic>.from(identifier!.map((x) => x)),
        "atqa": List<dynamic>.from(atqa!.map((x) => x)),
        "maxTransceiveLength": maxTransceiveLength,
        "sak": sak,
        "timeout": timeout,
      };
}
