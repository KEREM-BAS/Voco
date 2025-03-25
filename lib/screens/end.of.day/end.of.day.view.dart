import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voco/providers/auth_provider.dart';
import '../../enums/snack_type.dart';
import '../../models/payment_transaction.dart';
import '../../models/requests/transaction_report_request.dart';
import '../../utils/constants.dart';
import '../../utils/main_util.dart';
import '../../utils/session.dart';
import '../../utils/softpos_alertbox/softpos_alertbox_enums.dart';
import '../../utils/softpos_alertbox/softpos_alertbox_functions.dart';
import '../home/components/home.appbar.dart';

class EndOfDayView extends StatefulWidget {
  const EndOfDayView({super.key});

  @override
  State<EndOfDayView> createState() => _EndOfDayViewState();
}

class _EndOfDayViewState extends State<EndOfDayView> {
  final GlobalKey<ScaffoldState> _mainScaffold = GlobalKey<ScaffoldState>();
  List<PaymentTransaction> transactionList = [];
  Map<String, List<PaymentTransaction>> transactionsMap = {};

  bool loading = true;
  DateTime? selectedDate;
  int? transactionStatus;

  @override
  void initState() {
    super.initState();
    _getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _mainScaffold,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            HstAppBar(
              title: const Text(
                'Gün Sonu Raporu',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Constants.SECONDARY,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              leftAction: MainUtil.backAction(context),
              rightAction: transactionList.isNotEmpty
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.print,
                        color: Constants.SECONDARY,
                      ),
                    )
                  : null,
            ),
            _filterSection(),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _filterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.grey.shade600),
                            const SizedBox(width: 10),
                            Text(
                              selectedDate != null ? DateFormat('dd/MM/yy').format(selectedDate!) : 'Tarih Seç',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IntrinsicWidth(
                    child: DropdownButton<int?>(
                      value: transactionStatus,
                      hint: const Text('Durum Seç'),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Hepsi')),
                        DropdownMenuItem(value: 2, child: Text('Başarılı')),
                        DropdownMenuItem(value: 3, child: Text('Başarısız')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          transactionStatus = value;
                        });
                      },
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down, color: Constants.SECONDARY),
                      underline: Container(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _getTransactions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.PRIMARY,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Filtrele',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Constants.PRIMARY,
            ),
          )
        : RefreshIndicator(
            onRefresh: _refreshTransactions,
            child: _transactionsRow(),
          );
  }

  Widget _transactionsRow() {
    return transactionsMap.isEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(
              child: Text(
                'İşlem bulunamadı',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: transactionsMap.keys.length,
            itemBuilder: (context, index) {
              String key = transactionsMap.keys.elementAt(index);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Constants.SECONDARY,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactionsMap[key]!.length,
                    itemBuilder: (context, subIndex) {
                      return Column(
                        children: [
                          _transactionLine(transactionsMap[key]![subIndex]),
                          const Divider(indent: 16, endIndent: 16, color: Colors.grey),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
  }

  Future<void> _refreshTransactions() async {
    await _getTransactions();
  }

  Widget _transactionLine(PaymentTransaction tran) {
    return ListTile(
      onTap: () {},
      visualDensity: VisualDensity.compact,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: _transactionStatusColor(tran),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '${tran.createDate!.day}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/icons/clock.png'),
            width: 20,
          ),
          const SizedBox(width: 10),
          Text(
            DateFormat('HH:mm:ss').format(tran.createDate!),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
      subtitle: Text(
        _getTranStatus(tran),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Text(
        MainUtil.formatAmount(
          tran.amount,
          currency: tran.currency,
        ),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Constants.PRIMARY,
        ),
      ),
    );
  }

  String _getTranStatus(PaymentTransaction transaction) {
    switch (transaction.transactionStatus) {
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
        return 'Tanımsız (${transaction.transactionStatus})';
    }
  }

  Color _transactionStatusColor(PaymentTransaction transaction) {
    switch (transaction.transactionStatus) {
      case 1:
        return Colors.grey.shade600;
      case 2:
        return Colors.green.shade600;
      case 3:
        return Colors.red.shade600;
      case 4:
        return Colors.orange.shade600;
      case 5:
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Future<void> _getTransactions() async {
    setState(() {
      transactionsMap = {};
      loading = true;
    });

    TransactionReportRequest request = TransactionReportRequest(
      merchantId: Session.instance.merchant!.merchantId,
      terminalID: Session.instance.terminal!.id,
      transactionTypes: 4,
      transactionStatus: transactionStatus ?? 0,
      currencyCode: 0,
      pageCount: 1000,
      pageNumber: 1,
      startDate:
          selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!.toUtc()) : DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc()),
      endDate: selectedDate != null
          ? DateFormat('yyyy-MM-dd')
              .format(selectedDate!.toUtc().add(const Duration(hours: 23, minutes: 59, seconds: 59)).subtract(const Duration(days: 1)))
          : DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc().subtract(const Duration(days: 1))),
    );

    List<PaymentTransaction>? transactions =
        await Provider.of<AuthProvider>(context, listen: false).getTransactions(context, request, showProgress: false);
    setState(() {
      loading = false;
      if (transactions != null) {
        generateTransactionMap(transactions);
        transactionList = transactions;
      }
    });
  }

  void generateTransactionMap(List<PaymentTransaction> transactions) {
    Map<String, List<PaymentTransaction>> generatedMap = {};

    for (PaymentTransaction pt in transactions) {
      String key = getKey(pt.createDate!.toLocal());
      if (!generatedMap.containsKey(key)) {
        List<PaymentTransaction> items = [pt];
        generatedMap[key] = items;
      } else {
        generatedMap[key]!.add(pt);
      }
    }

    setState(() {
      transactionsMap = generatedMap;
    });
  }

  String getKey(DateTime date) {
    List<String> months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    return '${date.day} ${months[date.month - 1]} - ${date.year}';
  }

  Future<void> printEndOfDay(BuildContext context) async {
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
      List<Map<String, dynamic>> transactionListJson = transactionList.map((e) => e.toJson()).toList();
      await const MethodChannel('com.hstsoftpos.app/channel').invokeMethod('printEndOfDaySlip', transactionListJson);
    } catch (e) {
      log(e.toString());
      MainUtil.showSnack(context, 'Bir hata oluştu. Lütfen tekrar deneyin.', SnackType.ERROR);
    }
  }
}
