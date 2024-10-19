import 'package:flutter/material.dart';
import 'package:voco/screens/transactions/transaction.view.dart';

import '../../../utils/session.dart';
import '../../settings/settings.view.dart';

Widget HomeButtons(BuildContext context) {
  return Center(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          HomeButton("Ayarlar", Icons.settings, context, () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingsView(
                  merchant: Session.instance.merchant!,
                  terminal: Session.instance.terminal!,
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}

Widget HomeButton(String text, IconData icon, BuildContext context, void Function()? onPressed) {
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
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 45,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
