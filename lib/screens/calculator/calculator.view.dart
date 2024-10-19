// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:voco/providers/auth_provider.dart';
import 'package:voco/screens/home/home.view.dart';
import 'package:voco/utils/constants.dart';
import '../../enums/snack_type.dart';
import '../../models/requests/sale_softpos_request.dart';
import '../../models/responses/sale_transaction_response.dart';
import '../../utils/loading.dart';
import '../../utils/main_util.dart';
import 'package:http/http.dart' as http;
import '../../utils/session.dart';
import 'components/hstNumericKeyboard.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  // Declare variables to store the state
  double amount = 0.0;

  double serviceFee = 0.0;

  double total = 0.0;

  double amountFontSize = 60.0;

  bool decimalFlag = false;

  int decimalIndex = 0;

  int deleteIndex = 1;

  // Format the amount with two decimal places using 'tr_TR' locale
  String formattedAmount(double amount) {
    return NumberFormat('#,##0.00', 'tr_TR').format(amount);
  }

  // Format the service fee with two decimal places using 'tr_TR' locale
  String formattedServiceFee(double serviceFee) {
    return NumberFormat('#,##0.00', 'tr_TR').format(serviceFee);
  }

  // Format the total with two decimal places using 'tr_TR' locale
  String formattedTotal(double total) {
    return NumberFormat('#,##0.00', 'tr_TR').format(total);
  }

  // Handle keyboard tap (you would typically move this logic outside)
  void onKeyboardTap(String value) {
    String amountStr = amount.toStringAsFixed(2);

    List<String> parts = amountStr.split('.');
    String gtZero = parts[0];
    String ltZero = parts[1];

    if (decimalFlag) {
      if (decimalIndex < 2) {
        ltZero = ltZero.replaceRange(decimalIndex, decimalIndex + 1, value);
        decimalIndex += 1;
      }
    } else {
      if (gtZero.length < 8) {
        gtZero += value;
      }
    }

    amountStr = '$gtZero.$ltZero';

    amount = double.parse(amountStr);
    serviceFee = calculateServiceFee(amount);
    total = calculateTotal(amount, serviceFee);

    // Adjust font size based on amount
    if (amount > 100000) {
      amountFontSize = 50.0;
    } else if (amount > 10000) {
      amountFontSize = 45.0;
    } else {
      amountFontSize = 60.0;
    }
  }

  // Handle backspace tap
  void onBackspaceTap() {
    String amountStr = amount.toStringAsFixed(2);

    List<String> parts = amountStr.split('.');
    String gtZero = parts[0];
    String ltZero = parts[1];

    if (decimalFlag) {
      if (decimalIndex > 0) {
        ltZero = ltZero.replaceRange(decimalIndex - 1, decimalIndex, '0');
        decimalIndex -= 1;
      } else {
        decimalFlag = false;
      }
    } else {
      if (gtZero.length > 1) {
        gtZero = gtZero.substring(0, gtZero.length - 1);
      } else {
        gtZero = '0';
      }
    }

    amountStr = '$gtZero.$ltZero';

    amount = double.parse(amountStr);
    serviceFee = calculateServiceFee(amount);
    total = calculateTotal(amount, serviceFee);

    if (amount < 1) {
      decimalFlag = false;
      decimalIndex = 0;
      deleteIndex = 1;
    }
  }

  // Toggle decimal point
  void onDecimalToggle() {
    decimalFlag = !decimalFlag;
    if (!decimalFlag) {
      decimalIndex = 0;
    }
  }

  // Calculate service fee (e.g., 5% of amount)
  double calculateServiceFee(double amount) {
    return amount * 0.05;
  }

  // Calculate total
  double calculateTotal(double amount, double serviceFee) {
    return amount + serviceFee;
  }

  Future<String> getClientIP() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to get public IP');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Start soft POS payment (dummy implementation, replace with actual API calls)
  Future<void> startSoftPosPayment() async {
    ProgressDialog dialog = ProgressDialog(context);
    var uuid = const Uuid();
    SaleSoftposRequest request = SaleSoftposRequest(
      merchantId: Session.instance.merchant!.merchantId,
      userId: Session.instance.loggedInUser!.userId,
      amount: double.parse(
        TextEditingController(text: MainUtil.format(total, twoDigits: true)).text.replaceAll('.', '').replaceAll(',', '.'),
      ),
      currencyCode: 949,
      terminalName: Session.instance.terminal!.terminalName ?? '-',
      isSecureTransaction: true,
      clientIP: await getClientIP(),
      orderId: uuid.v1().replaceAll('-', ''),
      terminalId: Session.instance.terminal?.id,
      transactionType: 4,
      cardHolderName: null,
      cardNumber: null,
      cvc: null,
      expireMonth: null,
      expireYear: null,
    );
    await dialog.show();
    SaleTransactionResponse? result = await Provider.of<AuthProvider>(context, listen: false).saleSoftpos(context, request);
    await dialog.hide();
    if (result != null) {
      // if (result.hasError) {
      //   MainUtil.showSnack(
      //     context,
      //     'Beklenmeyen bir hata oluştu, lütfen daha sonra tekrar deneyiniz!',
      //     SnackType.ERROR,
      //   );
      //   return;
      // }
      if (result.status == 'FAIL' || result.status == 'ERROR' || (result.paymentData == null && result.returnUrl == null)) {
        MainUtil.showSnack(
          context,
          'Şu an ödeme işlemini gerçekleştiremiyoruz, lütfen tekrar deneyiniz!',
          SnackType.ERROR,
        );
        return;
      }
      if (result.returnType == 1) {
        final url = Uri.parse(result.returnUrl ?? '');
        setState(() {
          Session.instance.paymenSessionToken = url.queryParameters['paymentSessionToken'];
        });
        launchUrl(url, mode: LaunchMode.externalApplication);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeView()), (Route<dynamic> route) => false);
      }
    } else {
      // setState(() {
      //   _buttonDisabled = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double getResponsiveFontSize(double baseSize) {
      return screenWidth * baseSize / 375;
    }

    return SafeArea(
      top: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Image(
                image: AssetImage('assets/images/hst-icon.png'),
                height: 50,
              ),
            ),
            CalculatorAmountCard(
              amount: amount,
              serviceFee: calculateServiceFee(amount),
              total: calculateTotal(amount, serviceFee),
            ),
            NumericKeyboardHst(
              height: screenHeight * 0.4,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              onKeyboardTap: (value) {
                setState(() {
                  onKeyboardTap(value);
                });
              },
              textColor: Colors.white,
              buttonBgColor: const Color.fromARGB(255, 104, 147, 148),
              rightButtonFn: () {
                setState(() {
                  onBackspaceTap();
                });
              },
              rightIcon: const Icon(
                Icons.backspace,
                color: Color.fromARGB(255, 247, 220, 1),
                size: 40,
              ),
              leftButtonFn: () {
                setState(() {
                  onDecimalToggle();
                });
              },
              leftIcon: Text(
                ',',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(30),
                  fontWeight: FontWeight.bold,
                  color: decimalFlag ? Colors.grey : Color.fromARGB(255, 247, 220, 1),
                ),
              ),
            ),
            CalculatorButtonRow(amount: amount, onCancel: () => Navigator.of(context).pop(), onProceed: () => startSoftPosPayment()),
          ],
        ),
      ),
    );
  }
}

class CalculatorButtonRow extends StatelessWidget {
  final double amount;
  final VoidCallback onCancel;
  final Future<void> Function() onProceed;

  const CalculatorButtonRow({
    super.key,
    required this.amount,
    required this.onCancel,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 65,
          child: ElevatedButton(
            onPressed: onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: const Text(
              "İptal",
              style: TextStyle(
                color: Constants.SECONDARY,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 65,
          child: ElevatedButton(
            onPressed: amount > 0 ? onProceed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: amount <= 0 ? Colors.grey : Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(
              "Devam",
              style: TextStyle(
                color: amount <= 0 ? Colors.grey : Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppStyles {
  static const Color cardStartColor = Color.fromARGB(255, 104, 147, 148);
  static const Color cardEndColor = Color(0xFFa1d6e2);
  static const Color dividerColor = Colors.white54;
  static const Color textColor = Colors.white;
  static const double borderRadius = 20.0;
}

// Helper function for responsive font size
double getResponsiveFontSize(BuildContext context, double fontSize) {
  double baseWidth = 375.0; // Base screen width (e.g., iPhone 8)
  double screenWidth = MediaQuery.of(context).size.width;
  return fontSize * screenWidth / baseWidth;
}

class CalculatorAmountCard extends StatelessWidget {
  final double amount;
  final double serviceFee;
  final double total;

  const CalculatorAmountCard({
    super.key,
    required this.amount,
    required this.serviceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppStyles.cardStartColor,
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            AmountSection(
              label: 'Tutar',
              value: amount,
              currency: '₺',
            ),
            const Divider(color: AppStyles.dividerColor),
            AmountSection(
              label: 'Hizmet Bedeli',
              value: serviceFee,
              currency: '₺',
            ),
            const Divider(color: AppStyles.dividerColor),
            AmountSection(
              label: 'TOPLAM',
              value: total,
              currency: '₺',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

// AmountSection widget with responsive text and formatting
class AmountSection extends StatelessWidget {
  final String label;
  final double value;
  final String currency;
  final bool isTotal;

  const AmountSection({
    super.key,
    required this.label,
    required this.value,
    required this.currency,
    this.isTotal = false,
  });

  // Formats the value with currency symbol and appropriate decimal places
  String formatValue(double value) {
    final formatter = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '$currency ',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    // Responsive font sizes
    double labelFontSize = getResponsiveFontSize(context, 16);
    double valueFontSize = getResponsiveFontSize(context, isTotal ? 24 : 20);

    // Text styles
    TextStyle labelStyle = TextStyle(
      color: AppStyles.textColor,
      fontSize: labelFontSize,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
    );

    TextStyle valueStyle = TextStyle(
      color: AppStyles.textColor,
      fontSize: valueFontSize,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          const Spacer(),
          Text(
            formatValue(value),
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}
