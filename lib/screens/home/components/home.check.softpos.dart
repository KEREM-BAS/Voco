import 'package:flutter/material.dart';
import 'package:voco/providers/auth_provider.dart';
import 'package:voco/utils/session.dart';
import '../../../utils/softpos_alertbox/softpos_alertbox_enums.dart';
import '../../../utils/softpos_alertbox/softpos_alertbox_functions.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> checkSoftPosApp({String? packageName, required BuildContext context}) async {
  return true;
  // AuthProvider merchantApi = AuthProvider();
  // var user = Session.instance.loggedInUser;
  // if ((user?.merchantId ?? 0) > 0) {
  //   var merchantResponseBase = await merchantApi.getMerchant(context, user!.merchantId);
  //   if (merchantResponseBase != null) {
  //     if (merchantResponseBase.isUseSoftPos == false) {
  //       await QuickAlert.show(
  //         context: context,
  //         title: "Uyarı",
  //         type: QuickAlertType.warning,
  //         text: "Softpos yetkiniz bulunmamaktadır lütfen bizimle iletişime geçiniz.",
  //         confirmBtnText: "Tamam",
  //         onConfirmBtnTap: () {
  //           Navigator.of(context).pop(true);
  //         },
  //       );
  //       return false;
  //     }
  //   }
  // }
  // if (true) {
  //   return true;
  //   // ignore: dead_code
  // } else {
  //   await QuickAlert.show(
  //     context: context,
  //     type: QuickAlertType.warning,
  //     title: "Uyarı",
  //     text: "Softpos uygulaması yüklü değil. Temassız ödeme işlemleri için lütfen uygulamayı yükleyiniz.",
  //     confirmBtnText: "Yükle",
  //     cancelBtnText: "İptal",
  //     onConfirmBtnTap: () {
  //       final url = Uri.parse('https://play.google.com/store/apps/details?id=${packageName ?? 'com.provisionpay.softpos.paybyme'}');
  //       launchUrl(url, mode: LaunchMode.externalApplication);
  //       Navigator.of(context).pop(true);
  //     },
  //     onCancelBtnTap: () async {
  //       Navigator.of(context).pop(false);
  //     },
  //   );
  //   return false;
  // }
}
