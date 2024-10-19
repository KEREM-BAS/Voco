import 'package:flutter/material.dart';
import '../../../utils/softpos_alertbox/softpos_alertbox_enums.dart';
import '../../../utils/softpos_alertbox/softpos_alertbox_functions.dart';
import '../../calculator/calculator.view.dart';
import 'home.check.softpos.dart';

// ignore: non_constant_identifier_names
Widget HomeSellButton(BuildContext context, {required bool isEnabled}) {
  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.25,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () async {
                isEnabled = false;
                if (await checkSoftPosApp(context: context)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CalculatorView(),
                    ),
                  );
                }
                isEnabled = true;
              }
            : () async {
                await QuickAlert.show(
                  context: context,
                  title: "Uyarı",
                  type: QuickAlertType.warning,
                  text: "Softpos yetkiniz bulunmamaktadır lütfen bizimle iletişime geçiniz.",
                  confirmBtnText: "Tamam",
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop(true);
                  },
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Colors.green : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Ödeme Al',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
