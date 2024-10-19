// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hstpos/Pages/calculator/calculator.controller.dart';

// import '../../../Utils/constants/application.constant.dart';

// Widget CalculatorButtonRow() {
//   CalculatorController controller = Get.find<CalculatorController>();
//   return Row(
//     children: [
//       SizedBox(
//         width: Get.width * 0.5,
//         height: 65,
//         child: ElevatedButton(
//           onPressed: () async {
//             Get.back();
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.grey,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(0),
//             ),
//           ),
//           child: const Text(
//             "İptal",
//             style: TextStyle(
//               color: ApplicationConstant.SECONDARY,
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       Obx(
//         () => SizedBox(
//           width: Get.width * 0.5,
//           height: 65,
//           child: ElevatedButton(
//             onPressed: () async {
//               if (controller.amount > 0) {
//                 await controller.startSoftPosPayment();
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: controller.amount <= 0 ? Colors.grey : const Color(0xff26F4CE),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(0),
//               ),
//             ),
//             child: Text(
//               "Devam",
//               style: TextStyle(
//                 color: controller.amount <= 0 ? Colors.black26 : ApplicationConstant.SECONDARY,
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
