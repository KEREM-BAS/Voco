// // calculator.controller.dart

// import 'package:get/get.dart';
// import 'package:hstpos/Apis/transaction/transaction.api.dart';
// import 'package:hstpos/Models/base/base.response.dart';
// import 'package:hstpos/Models/transaction/transaction.sale.request.dart';
// import 'package:hstpos/Models/transaction/transaction.sale.response.dart';
// import 'package:hstpos/Pages/calculator/calculator.binding.dart';
// import 'package:hstpos/Utils/helpers/storage.helper.dart';
// import 'package:hstpos/components/hst.widget.dart';
// import 'package:uuid/uuid.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CalculatorController extends GetxController {
//   var amount = 0.0.obs;
//   var serviceFee = 0.0.obs;
//   var total = 0.0.obs;

//   var amountFontSize = 60.0.obs;

//   var decimalFlag = false.obs;
//   int decimalIndex = 0;
//   int deleteIndex = 1;

//   // Dependencies
//   var transactionApi = Get.find<TransactionApi>();

//   // Progress Dialog
//   ProgressDialog? progressDialog;

//   // Formatted amount
//   String formattedAmount() {
//     // Format the amount with two decimal places using 'tr_TR' locale
//     return NumberFormat('#,##0.00', 'tr_TR').format(amount.value);
//   }

//   // Formatted service fee
//   String formattedServiceFee() {
//     return NumberFormat('#,##0.00', 'tr_TR').format(serviceFee.value);
//   }

//   // Formatted total
//   String formattedTotal() {
//     return NumberFormat('#,##0.00', 'tr_TR').format(total.value);
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize any necessary variables or services here
//     calculateServiceFee();
//     calculateTotal();
//   }

//   // Handle keyboard tap
//   void onKeyboardTap(String value) {
//     String amountStr = amount.value.toStringAsFixed(2);

//     List<String> parts = amountStr.split('.');
//     String gtZero = parts[0];
//     String ltZero = parts[1];

//     if (decimalFlag.value) {
//       if (decimalIndex < 2) {
//         ltZero = ltZero.replaceRange(decimalIndex, decimalIndex + 1, value);
//         decimalIndex += 1;
//       }
//     } else {
//       if (gtZero.length < 8) {
//         // Limit to prevent overflow
//         gtZero += value;
//       }
//     }

//     amountStr = '$gtZero.$ltZero';

//     amount.value = double.parse(amountStr);
//     calculateServiceFee();
//     calculateTotal();

//     // Adjust font size based on amount
//     if (amount.value > 100000) {
//       amountFontSize.value = 50.0;
//     } else if (amount.value > 10000) {
//       amountFontSize.value = 45.0;
//     } else {
//       amountFontSize.value = 60.0;
//     }
//   }

//   // Handle backspace tap
//   void onBackspaceTap() {
//     String amountStr = amount.value.toStringAsFixed(2);

//     List<String> parts = amountStr.split('.');
//     String gtZero = parts[0];
//     String ltZero = parts[1];

//     if (decimalFlag.value) {
//       if (decimalIndex > 0) {
//         ltZero = ltZero.replaceRange(decimalIndex - 1, decimalIndex, '0');
//         decimalIndex -= 1;
//       } else {
//         decimalFlag.value = false;
//       }
//     } else {
//       if (gtZero.length > 1) {
//         gtZero = gtZero.substring(0, gtZero.length - 1);
//       } else {
//         gtZero = '0';
//       }
//     }

//     amountStr = '$gtZero.$ltZero';

//     amount.value = double.parse(amountStr);
//     calculateServiceFee();
//     calculateTotal();

//     if (amount.value < 1) {
//       decimalFlag.value = false;
//       decimalIndex = 0;
//       deleteIndex = 1;
//     }
//   }

//   // Toggle decimal point
//   void onDecimalToggle() {
//     decimalFlag.value = !decimalFlag.value;
//     if (!decimalFlag.value) {
//       decimalIndex = 0;
//     }
//   }

//   // Calculate service fee (e.g., 5% of amount)
//   void calculateServiceFee() {
//     serviceFee.value = amount.value * 0.05;
//   }

//   // Calculate total
//   void calculateTotal() {
//     total.value = amount.value + serviceFee.value;
//   }

//   // Start soft POS payment
//   Future<void> startSoftPosPayment() async {
//     ProgressDialog dialog = ProgressDialog(Get.context!);
//     var uuid = const Uuid();
//     SaleRequest request = SaleRequest(
//       merchantId: GetxStorage.getMerchant()!.merchantId,
//       userId: GetxStorage.getLoggedInUser()!.userId!,
//       amount: double.parse(
//         formattedAmount().replaceAll(',', '').replaceAll('.', ''),
//       ),
//       currencyCode: 949,
//       terminalName: GetxStorage.getTerminal()?.terminalName ?? '-',
//       isSecureTransaction: true,
//       clientIP: await getClientIP(),
//       orderId: uuid.v1().replaceAll('-', ''),
//       terminalId: GetxStorage.getTerminal()?.id,
//       transactionType: 4,
//       cardHolderName: null,
//       cardNumber: null,
//       cvc: null,
//       expireMonth: null,
//       expireYear: null,
//     );

//     await dialog.show();
//     BaseResponse<SaleResponse?> result = await transactionApi.sale(request);
//     await dialog.hide();

//     if (result.data != null) {
//       if (result.data!.status == 'FAIL' || result.data!.status == 'ERROR' || (result.data!.paymentData == null && result.data!.returnUrl == null)) {
//         HstSnackbar(message: 'Şu an ödeme işlemini gerçekleştiremiyoruz, lütfen tekrar deneyiniz!');
//         return;
//       }
//       if (result.data!.returnType == 1) {
//         final url = Uri.parse(result.data!.returnUrl ?? '');
//         launchUrl(url, mode: LaunchMode.externalApplication);
//         await Get.delete<CalculatorBinding>();
//         Get.offAllNamed('/home');
//       }
//     }
//   }

//   // Format double value
//   String format(double? value, {bool twoDigits = true}) {
//     value ??= 0;
//     if (!twoDigits && isFractionGTZero(value)) {
//       return NumberFormat('#,##0.00###', 'tr_TR').format(value);
//     } else {
//       return NumberFormat('#,##0.00', 'tr_TR').format(value);
//     }
//   }

//   // Check if fraction part is greater than zero
//   bool isFractionGTZero(double value) {
//     if (value > 0) {
//       String temp = value.toStringAsFixed(5);

//       String fraction = temp.contains(',') ? temp.split(',')[1] : temp.split('.')[1];

//       if (int.parse(fraction) > 100) {
//         return true;
//       }
//     }
//     return false;
//   }

//   // Get client's public IP
//   Future<String> getClientIP() async {
//     try {
//       final response = await http.get(Uri.parse('https://api.ipify.org'));
//       if (response.statusCode == 200) {
//         return response.body;
//       } else {
//         throw Exception('Failed to get public IP');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
