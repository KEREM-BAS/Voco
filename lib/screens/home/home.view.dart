import 'package:flutter/material.dart';
import '../../utils/refresh_service.dart';
import '../../utils/session.dart';
import 'components/home.appbar.dart';
import 'components/home.buttons.dart';
import 'components/home.logout.dialog.dart';
import 'components/home.sell.button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        return onBackPressed(context);
      },
      child: SafeArea(
        top: true,
        maintainBottomViewPadding: true,
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await RefreshService().refreshUser(context, showProgress: false);
            },
            child: Stack(
              children: [
                ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    HomeAppbar(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    HomeSellButton(context, isEnabled: isEnabled),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    HomeButtons(context),
                    // HomeTransactions(),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    right: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Üye İşyeri ID: ' " ${Session.instance.merchant?.merchantId ?? "-"}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Terminal ID: ' "${Session.instance.terminal?.id.toString() ?? "-"}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
