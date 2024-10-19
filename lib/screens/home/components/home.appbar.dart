// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget HomeAppbar(BuildContext context) {
  return HstAppBar(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage('assets/images/hst-icon.png'),
          fit: BoxFit.fitHeight,
          height: MediaQuery.of(context).size.height * 0.07,
        ),
        // const Text(
        //   'Kolay Ödeme Sistemleri',
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontWeight: FontWeight.w800,
        //   ),
        // ),
      ],
    ),
    centerTitle: true,
    leftAction: null,
    // rightAction: Obx(
    //   () => IconButton(
    //     icon: Icon(
    //       controller.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
    //       color: Colors.black,
    //     ),
    //     onPressed: () {
    //       controller.toggleDarkMode();
    //     },
    //   ),
    // ),
    // child: Image(
    //   image: const AssetImage('assets/images/hst-icon.png'),
    //   width: Get.width / 4,
    // ),
    // Row(
    //   children: [
    //     Container(
    //       alignment: Alignment.topRight,
    //       decoration: BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.grey.withOpacity(0.5),
    //             spreadRadius: 1,
    //             blurRadius: 7,
    //             offset: const Offset(0, 3),
    //           ),
    //         ],
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(15),
    //         image: DecorationImage(
    //           image: controller.image ?? const AssetImage('assets/icons/profile.png'),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //       constraints: BoxConstraints(minWidth: Get.width / 6, minHeight: Get.width / 6),
    //       child: const SizedBox(),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(left: 10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           Text(
    //             controller.merchant?.companyName ?? '',
    //             overflow: TextOverflow.ellipsis,
    //             style: const TextStyle(
    //               color: Colors.black,
    //               fontSize: 18,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           Visibility(
    //             visible: GetxStorage.getLoggedInUser()?.userRole == 1,
    //             child: Text(
    //               "Günlük Ciro: " + ConverterHelper.format(controller.merchantDailyTotal) + " ₺",
    //               style: const TextStyle(
    //                 color: Colors.black,
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.normal,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // ),
    // Obx(
    //   () => FlutterSwitch(
    //     value: controller.isEnabledDeveloperMode.value,
    //     onToggle: (value) {
    //       controller.toggleDeveloperMode(value);
    //     },
    //   ),
    // ),
  );
}
// ignore_for_file: must_be_immutable

class HstAppBar extends StatefulWidget implements PreferredSizeWidget {
  bool centerTitle = false;
  Widget title;
  Widget? leftAction;
  Widget? rightAction;

  HstAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.leftAction,
    this.rightAction,
  });

  @override
  State<HstAppBar> createState() => _HstAppBarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _HstAppBarState extends State<HstAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.10,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/appbar-bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: widget.leftAction ?? const SizedBox.shrink(),
          ),
          Expanded(
            flex: 5,
            child: widget.title,
          ),
          Expanded(
            flex: 1,
            child: widget.rightAction ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
