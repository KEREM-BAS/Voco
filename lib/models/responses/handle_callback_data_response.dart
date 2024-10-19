import '../../utils/map_util.dart';

class CallbackDataResponse {
  bool? isCompleted;
  bool? status;
  int? errorCode;
  String? errorDesc;
  String? authCode;
  String? maskedPan;
  String? bankResponseCode;

  CallbackDataResponse({
    this.isCompleted,
    this.status,
    this.errorCode,
    this.errorDesc,
    this.authCode,
    this.maskedPan,
    this.bankResponseCode,
  });

  CallbackDataResponse.fromJson(Map<String, dynamic> json) {
    isCompleted = MapUtil.getBool(json, 'isCompleted');
    status = MapUtil.getBool(json, 'status');
    errorCode = MapUtil.getInt(json, 'errorCode');
    errorDesc = MapUtil.getString(json, 'errorDesc');
    authCode = MapUtil.getString(json, 'authCode');
    maskedPan = MapUtil.getString(json, 'maskedPan');
    bankResponseCode = MapUtil.getString(json, 'bankResponseCode');
  }

  static Map<String, dynamic> translateTransactionCode(String code) {
    switch (code) {
      case "00":
        return {"success": true, "message": "ONAYLANDI"};
      case "01":
        return {"success": false, "message": "BANKASINI ARAYINIZ"};
      case "02":
        return {"success": false, "message": "KATEGORI YOK"};
      case "03":
        return {"success": false, "message": "UYE KODU HATALI /TANIMSIZ"};
      case "04":
        return {"success": false, "message": "KARTA EL KOYUNUZ / SAKINCALI"};
      case "05":
        return {"success": false, "message": "RED / ONAYLANMADI/CVV HATALI"};
      case "06":
        return {"success": false, "message": "HATALI ISLEM"};
      case "07":
        return {"success": false, "message": "KARTA EL KOYUNUZ"};
      case "08":
        return {"success": true, "message": "KIMLIK KONTROLU / ONAYLANDI"};
      case "11":
        return {"success": true, "message": "V.I.P KODU / ONAYLANDI"};
      case "12":
        return {"success": false, "message": "HATALI ISLEM / RED"};
      case "13":
        return {"success": false, "message": "HATALI MIKTAR / RED"};
      case "14":
        return {"success": false, "message": "KART-HESAP NO HATALI"};
      case "15":
        return {"success": false, "message": "MUSTERI YOK"};
      case "19":
        return {"success": false, "message": "ISLEMI TEKRAR GIR"};
      case "21":
        return {"success": false, "message": "ISLEM YAPILAMADI"};
      case "24":
      case "25":
      case "26":
      case "27":
      case "28":
        return {"success": false, "message": "DOSYASINA ULASILAMADI"};
      case "30":
        return {"success": false, "message": "FORMAT HATASI (UYEISYERI)"};
      case "32":
        return {"success": false, "message": "DOSYASINA ULASILAMADI"};
      case "33":
        return {"success": false, "message": "SURESI BITMIS/IPTAL KART"};
      case "34":
        return {"success": false, "message": "SAHTE KART"};
      case "38":
        return {"success": false, "message": "ŞIFRE AŞIMI / ELKOY"};
      case "41":
        return {"success": false, "message": "KAYIP KART"};
      case "43":
        return {"success": false, "message": "CALINTI KART"};
      case "51":
        return {"success": false, "message": "YETERSIZ HESAP/DEBIT KART"};
      case "52":
        return {"success": false, "message": "HESAP NO YU KONTROL EDIN"};
      case "53":
        return {"success": false, "message": "HESAP YOK"};
      case "54":
        return {"success": false, "message": "SURESI BITMIS KART"};
      case "55":
        return {"success": false, "message": "SIFRE HATALI"};
      case "57":
        return {"success": false, "message": "HARCAMA RED/BLOKELI"};
      case "58":
        return {"success": false, "message": "TERM.TRANSEC. YOK"};
      case "61":
        return {"success": false, "message": "CEKME LIMIT ASIMI"};
      case "62":
        return {"success": false, "message": "YASAKLANMIS KART"};
      case "65":
        return {"success": false, "message": "LIMIT ASIMI/BORC BAKIYE VAR"};
      case "75":
        return {"success": false, "message": "SIFRE TEKRAR ASIMI"};
      case "76":
        return {"success": false, "message": "KEY SYN. HATASI"};
      case "82":
        return {"success": false, "message": "CVV HATALI / RED"};
      case "91":
        return {"success": false, "message": "BANKASININ SWICI ARIZALI"};
      case "92":
        return {"success": false, "message": "BANKASI BILINMIYOR"};
      case "96":
        return {"success": false, "message": "BANKASININ SISTEMI ARIZALI"};
      case "TO":
        return {"success": false, "message": "TIME OUT"};
      case "GP":
        return {"success": false, "message": "GECERSIZ POS"};
      case "TB":
        return {"success": false, "message": "TUTARI BÖLÜNÜZ"};
      case "UP":
        return {"success": false, "message": "UYUMSUZ POS"};
      case "IP":
        return {"success": false, "message": "IPTAL POS"};
      case "CS":
        return {"success": false, "message": "CICS SORUNU"};
      case "BG":
        return {"success": false, "message": "BİLGİ GİTMEDİ"};
      case "NA":
        return {"success": false, "message": "NO AMEX"};
      case "OI":
        return {"success": false, "message": "OKEY İPTAL OTOR."};
      case "NI":
        return {"success": false, "message": "IPTAL İPTAL EDİLEMEDİ"};
      case "NS":
        return {"success": false, "message": "NO SESION(HAT YOK)"};
      default:
        return {"success": false, "message": "Bilinmeyen kod $code"};
    }
  }
}
