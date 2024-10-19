import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/merchant.dart';
import '../models/terminal.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'session.dart';

class RefreshService {
  Future<void> refreshUser(
    BuildContext context, {
    bool sendMobileInfo = false,
    bool showProgress = false,
  }) async {
    User? user = await Provider.of<AuthProvider>(context, listen: false).getUser(context, showProgress: showProgress);

    if (user != null) {
      Session.instance.loggedInUser = user;

      if (user.merchantId > 0) {
        Merchant? merchant = await Provider.of<AuthProvider>(context, listen: false).getMerchant(
          context,
          user.merchantId,
          showProgress: showProgress,
        );

        Session.instance.merchant = merchant;

        Terminal? terminal = await Provider.of<AuthProvider>(context, listen: false)
            .getMerchantTerminal(
              context,
              user.merchantId,
              showProgress,
            )
            .then((value) => value?.first);

        Session.instance.terminal = terminal;

        AuthProvider reportProvider = Provider.of<AuthProvider>(context, listen: false);

        double merchantDailyTotal = await reportProvider.getMerchantDailySum(
          context,
          merchant!.merchantId,
          showProgress: showProgress,
        );

        Session.instance.merchantTodayTotal = merchantDailyTotal;

        if (terminal != null) {
          double terminalDailyTotal = await reportProvider.getTerminalDailySum(
            context,
            terminal.id,
            showProgress: showProgress,
          );

          Session.instance.terminalTodayTotal = terminalDailyTotal;
        }
      }
    }
  }
}
