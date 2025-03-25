import 'package:flutter/material.dart';
import 'package:voco/screens/end.of.day/end.of.day.view.dart';
import 'package:voco/screens/transactions/transaction.view.dart';

import '../../../utils/session.dart';
import '../../settings/settings.view.dart';

Widget HomeButtons(BuildContext context) {
  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        shrinkWrap: true,
        children: [
          HomeButton(
            "İşlemler",
            Icons.history,
            context,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TransactionsScreen(),
                ),
              );
            },
          ),
          HomeButton(
            "Ayarlar",
            Icons.settings,
            context,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsView(
                    merchant: Session.instance.merchant!,
                    terminal: Session.instance.terminal!,
                  ),
                ),
              );
            },
          ),
          HomeButton(
            "Gün Sonu",
            Icons.nightlight_round,
            context,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EndOfDayView(),
                ),
              );
            },
            imgPath: "assets/icons/report.png",
          ),
        ],
      ),
    ),
  );
}

Widget HomeButton(String text, IconData? icon, BuildContext context, void Function()? onPressed, {String? imgPath}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.43,
    height: MediaQuery.of(context).size.height * 0.21,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imgPath != null && imgPath.isNotEmpty
              ? Image.asset(
                  imgPath,
                  width: 30,
                  height: 30,
                )
              : Icon(
                  icon ?? Icons.help_outline,
                  color: Colors.white,
                  size: 40,
                ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
