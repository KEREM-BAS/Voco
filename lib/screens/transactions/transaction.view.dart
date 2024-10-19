import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voco/providers/auth_provider.dart';

import '../../models/payment_transaction.dart';
import '../../models/requests/transaction_report_request.dart';
import '../../utils/constants.dart';
import '../../utils/main_util.dart';
import '../../utils/session.dart';
import '../home/components/home.appbar.dart';
import 'transaction.detail.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final GlobalKey<ScaffoldState> _mainScaffold = GlobalKey<ScaffoldState>();
  Map<String, List<PaymentTransaction>> transactionsMap = {};

  bool loading = true;

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
                'İşlemler',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Constants.SECONDARY,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              leftAction: MainUtil.backAction(context),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Constants.SECONDARY,
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
            child: const Center(child: Text('İşlem bulunamadı')),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(), // Allow pull-to-refresh
            itemCount: transactionsMap.keys.length,
            itemBuilder: (context, index) {
              String key = transactionsMap.keys.elementAt(index);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
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
                          const Divider(indent: 10, endIndent: 10),
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
    // Fetch new transactions data
    await _getTransactions();
  }

  Widget _transactionLine(PaymentTransaction tran) {
    return ListTile(
      onTap: () => showTransactionDetailModal(context, tran),
      visualDensity: VisualDensity.compact,
      leading: Container(
        width: 50,
        height: 50,
        color: _transactionStatusColor(tran),
        alignment: Alignment.center,
        child: Text(
          '${tran.createDate!.day}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
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
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(width: 10),
          Text(
            DateFormat('HH:mm:ss').format(tran.createDate!),
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          )
        ],
      ),
      subtitle: Text(
        _getTranStatus(tran),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Text(
        MainUtil.formatAmount(
          tran.amount,
          currency: tran.currency,
        ),
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
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
      transactionStatus: 0,
      currencyCode: 0,
      pageCount: 1000,
      pageNumber: 1,
      startDate: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30))),
      endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    List<PaymentTransaction>? transactions =
        await Provider.of<AuthProvider>(context, listen: false).getTransactions(context, request, showProgress: false);
    setState(() {
      loading = false;
      if (transactions != null) {
        generateTransactionMap(transactions);
      }
    });
  }

  void generateTransactionMap(List<PaymentTransaction> transactions) {
    Map<String, List<PaymentTransaction>> generatedMap = {};

    for (PaymentTransaction pt in transactions) {
      String key = getKey(pt.createDate!);
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
    return '${months[date.month - 1]} - ${date.year}';
  }
}
