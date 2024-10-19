// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hstpos/Pages/home/home.controller.dart';

// import '../../../Utils/constants/application.constant.dart';
// import '../../../components/hst.widget.dart';

// Widget HomeTransactions() {
//   HomeController controller = Get.find<HomeController>();
//   return SizedBox(
//     height: Get.height * 0.5,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Divider(),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: Get.width * 0.025),
//             child: Obx(
//               () => Container(
//                 child: controller.transactions.value?.isEmpty ?? true
//                     ? Container(
//                         alignment: Alignment.topCenter,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 20),
//                           child: controller.isLoading.value
//                               ? const CircularProgressIndicator(
//                                   color: ApplicationConstant.BUTTON_BG,
//                                 )
//                               : Text(
//                                   "messages.no_transactions".tr,
//                                   style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//                                 ),
//                         ),
//                       )
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: controller.transactions.value!.length,
//                         itemBuilder: (context, index) {
//                           return TransactionTile(controller.transactions.value![index]!);
//                         },
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
