// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hstpos/Pages/calculator/calculator.controller.dart';
// import '../../../Utils/constants/application.constant.dart';
// import 'package:intl/intl.dart';

// /// The main widget that displays the calculator amounts.
// class CalculatorAmountCard extends StatelessWidget {
//   const CalculatorAmountCard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Retrieve the CalculatorController instance
//     final CalculatorController controller = Get.find<CalculatorController>();

//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 10),
//         child: Card(
//           color: const Color(0xFF292D36),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             children: [
//               _AmountSection(
//                 label: 'Tutar',
//                 valueController: controller.amount,
//                 currency: ApplicationConstant.TURKISH_LIRA,
//               ),
//               const Divider(color: Colors.grey),
//               _AmountSection(
//                 label: 'Hizmet Bedeli',
//                 valueController: controller.serviceFee,
//                 currency: ApplicationConstant.TURKISH_LIRA,
//               ),
//               const Divider(color: Colors.grey),
//               _AmountSection(
//                 label: 'TOPLAM',
//                 valueController: controller.total,
//                 currency: ApplicationConstant.TURKISH_LIRA,
//                 isTotal: true,
//               ),
//               // Uncomment the following line if you have a numeric keyboard widget.
//               // _NumericKeyboard(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// A reusable widget for displaying a label and its corresponding value.
// class _AmountSection extends StatelessWidget {
//   final String label;
//   final RxDouble valueController;
//   final String currency;
//   final bool isTotal;

//   const _AmountSection({
//     required this.label,
//     required this.valueController,
//     required this.currency,
//     this.isTotal = false,
//   });

//   /// Formats the value according to the Turkish locale.
//   String _formatValue(double value) {
//     final formatter = NumberFormat("#,##0.00", "tr_TR");
//     return formatter.format(value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Label Section
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: Colors.grey[400],
//                 fontSize: 14,
//                 fontWeight: isTotal ? FontWeight.w900 : FontWeight.normal,
//               ),
//             ),
//           ),
//           // Value Section
//           Expanded(
//             flex: 4,
//             child: Obx(
//               () {
//                 double value = valueController.value;
//                 String formattedValue = _formatValue(value);
//                 return Text(
//                   '$formattedValue $currency',
//                   textAlign: TextAlign.right,
//                   style: TextStyle(
//                     color: value <= 0 ? Colors.grey : Colors.white,
//                     fontSize: 20 + (isTotal ? 2 : 0),
//                     fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Placeholder for a numeric keyboard widget.
// /// Uncomment and implement if you have a numeric keyboard.
// /// class _NumericKeyboard extends StatelessWidget {
// ///   @override
// ///   Widget build(BuildContext context) {
// ///     return Container(
// ///       // Your numeric keyboard implementation.
// ///     );
// ///   }
// /// }