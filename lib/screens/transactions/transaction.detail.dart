import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voco/utils/main_util.dart';
import '../../enums/snack_type.dart';
import '../../models/payment_transaction.dart';
import '../../providers/auth_provider.dart';
import '../../utils/softpos_alertbox/softpos_alertbox_enums.dart';
import '../../utils/softpos_alertbox/softpos_alertbox_functions.dart';

class TransactionDetailModal extends StatelessWidget {
  final PaymentTransaction transaction;

  const TransactionDetailModal({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'İşlem Detayları',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),
            _detailRow('İşlem Tipi', _getTransactionType(transaction.transactionType)),
            _detailRow('Firma Adı', transaction.companyName ?? '-'),
            _detailRow('İşlem Durumu', _getTransactionStatus(transaction.transactionStatus)),
            _detailRow('İşlem Tarihi', transaction.createDate != null ? DateFormat('dd.MM.yyyy').format(transaction.createDate!) : '-'),
            _detailRow('Tutar', '${transaction.amount.toStringAsFixed(2)} ₺', isAmount: true),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => printSlip(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Fiş Tekrarı',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                if (transaction.transactionStatus == 2)
                  ElevatedButton(
                    onPressed: () => _showCancelRefundOptions(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'İptal / İade',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isAmount ? Colors.blueAccent : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> printSlip(BuildContext context) async {
    try {
      int? printerStatus = await const MethodChannel('com.hstsoftpos.app/channel').invokeMethod<int?>('getPrinterStatus');
      if (printerStatus == 240) {
        await QuickAlert.show(
          title: "Hata",
          context: context,
          type: QuickAlertType.error,
          text: "Fiş basılamadı. Ruloyu kontrol edin.",
          confirmBtnText: "Tamam",
        );
        return;
      }
      PaymentTransaction? payment =
          await Provider.of<AuthProvider>(context, listen: false).getTransactionById(context, transaction.hostTransactionId ?? "");

      if (payment == null) {
        MainUtil.showSnack(context, 'İşlem bilgileri alınamadı.', SnackType.ERROR);
        return;
      }

      Map<String, dynamic> paymentJson = payment.toJson();
      await const MethodChannel('com.hstsoftpos.app/channel').invokeMethod('printSlip', paymentJson);
    } catch (e) {
      log(e.toString());
      MainUtil.showSnack(context, 'Bir hata oluştu. Lütfen tekrar deneyin.', SnackType.ERROR);
    }
  }

  void _showCancelRefundOptions(BuildContext context) {
    // Show cancel/refund options logic here
    // Example: QuickAlert.show or a custom modal
  }

  String _getTransactionType(int type) {
    switch (type) {
      case 1:
        return 'Satış';
      case 2:
        return 'Link Satış';
      case 3:
        return 'Web POS';
      case 4:
        return "SoftPOS";
      default:
        return 'Bilinmeyen';
    }
  }

  String _getTransactionStatus(int status) {
    switch (status) {
      case 1:
        return 'Beklemede';
      case 2:
        return 'Başarılı';
      case 3:
        return 'Başarısız';
      case 4:
        return 'Banka Onayı Bekleniyor';
      case 5:
        return 'İptal Edildi';
      default:
        return 'Tanımsız ($status)';
    }
  }
}

void showTransactionDetailModal(BuildContext context, PaymentTransaction transaction) {
  showDialog(
    context: context,
    builder: (context) => TransactionDetailModal(transaction: transaction),
  );
}
