import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:voco/enums/snack_type.dart';
import 'package:voco/models/base_model.dart';
import 'package:voco/providers/base_provider.dart';
import 'package:voco/utils/main_util.dart';
import 'package:voco/utils/routes.dart';

import '../models/merchant.dart';
import '../models/payment_transaction.dart';
import '../models/requests/login_request.dart';
import '../models/requests/sale_softpos_request.dart';
import '../models/requests/transaction_report_request.dart';
import '../models/responses/disabled_cards_response.dart';
import '../models/responses/sale_transaction_response.dart';
import '../models/terminal.dart';
import '../models/token.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/session.dart';

class AuthProvider extends BaseProvider {
  Future<int> login(
    BuildContext context,
    LoginRequest request,
    bool showProgress,
  ) async {
    try {
      var bytes = utf8.encode(request.password);
      var hash = sha512.convert(bytes);

      request.password = hash.toString().toLowerCase();
      //debugPrint(request.password);
      // 3627909a29c31381a071ec27f7c9ca97726182aed29a7ddd2e54353322cfb30abb9e3a6df2ac2c20fe23436311d678564d0c8d305930575f60e2d3d048184d79
      // 0x8AB014BFD9645AC1C05899C2F70CC8C5F85F6703E2DFAB4F658C85A5C4074F09BF6D3380B205465FF82FF4CAB4826CA26CC136B93AC2CBEB4DF4DE7640AD6849
      // 26e4f0aec6ab6290f1538840149e1ceed84ec59793a290ea05b999ec736cf94828e0c7b15f2c1a3888548a64bc7eaecf5edc574a5a5d130f80fe77c74ccf3aad
      //debugPrint('0x8AB014BFD9645AC1C05899C2F70CC8C5F85F6703E2DFAB4F658C85A5C4074F09BF6D3380B205465FF82FF4CAB4826CA26CC136B93AC2CBEB4DF4DE7640AD6849');

      BaseResponse? response = await post(
        context,
        Routes.API_LOGIN,
        request.toJson(),
        {},
        showProgress,
        isDataResponse: false,
        isLogin: true,
      );

      if (response == null) {
        return -1;
      }

      if (response.errorCode > 0) {
        if (response.errorCode == 2020) {
          return 0;
        }

        MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return -1;
      }

      Token token = Token.fromJson(response.data as Map<String, dynamic>);

      Session.instance.token = token.token;
      Session.instance.tokenExpiration = token.expiration;

      return token.status;
    } catch (e) {
      debugPrint('Error occurred on AuthProvider.login() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }
    return -1;
  }

  Future<User?> getUser(
    BuildContext context, {
    bool showProgress = true,
  }) async {
    try {
      BaseResponse? response = await post(
        context,
        Routes.API_GET_USER,
        {},
        {},
        showProgress,
      );

      if (response == null) {
        return null;
      }

      if (response.errorCode > 0) {
        MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return null;
      }

      User user = User.fromJson(response.data as Map<String, dynamic>);

      Session.instance.loggedInUser = user;
      //Session.instance.token = user.userToken;

      return user;
    } catch (e) {
      debugPrint('Error occurred on AuthProvider.login() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }
    return null;
  }

  Future<Merchant?> getMerchant(
    BuildContext context,
    int merchantId, {
    bool showProgress = true,
  }) async {
    try {
      BaseResponse? response = await post(
        context,
        '${Routes.API_GET_MERCHANT}$merchantId',
        {},
        {},
        showProgress,
      );

      if (response == null) {
        return null;
      }

      if (response.errorCode > 0) {
        MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return null;
      }

      return Merchant.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error occurred on MerchantProvider.getMerchant() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return null;
  }

  Future<Terminal?> getTerminal(
    BuildContext context,
    int terminalId,
  ) async {
    try {
      BaseResponse? response = await post(
        context,
        '${Routes.API_GET_TERMINAL}$terminalId',
        {},
        {},
        true,
      );

      if (response == null) {
        return null;
      }

      if (response.errorCode > 0) {
        MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return null;
      }

      return Terminal.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error occurred on TerminalProvider.getTerminal() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return null;
  }

  Future<List<Terminal?>?> getMerchantTerminal(
    BuildContext context,
    int merchantId,
    bool? showProgress,
  ) async {
    try {
      BaseResponse? response = await post(
        context,
        '${Routes.API_GET_MERCHANT_TERMINAL}$merchantId',
        {},
        {},
        showProgress ?? true,
      );

      if (response == null) {
        return null;
      }

      if (response.errorCode > 0) {
        MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return null;
      }

      List<Terminal> terminals = (response.data as List).map((e) => Terminal.fromJson(e as Map<String, dynamic>)).toList();

      return terminals;
    } catch (e) {
      debugPrint('Error occurred on TerminalProvider.getMerchantTerminal() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return null;
  }

  Future<double> getMerchantDailySum(
    BuildContext context,
    int merchantId, {
    bool showProgress = true,
  }) async {
    try {
      BaseResponse? response = await post(
        context,
        '${Routes.API_REPORT_MERCHANT_DAILY_SUM}?merchantId=$merchantId',
        {},
        {},
        showProgress,
      );

      if (response == null || response.errorCode > 0) {
        return 0.0;
      }

      return response.data as double;
    } catch (e) {
      debugPrint('Error occurred on ReportProvider.getMerchantDailySum() => $e');
      //MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return 0.0;
  }

  Future<double> getTerminalDailySum(
    BuildContext context,
    int terminalId, {
    bool showProgress = true,
  }) async {
    try {
      BaseResponse? response = await post(
        context,
        '${Routes.API_REPORT_TERMINAL_DAILY_SUM}?terminalId=$terminalId',
        {},
        {},
        showProgress,
      );

      if (response == null || response.errorCode > 0) {
        return 0.0;
      }

      return response.data as double;
    } catch (e) {
      debugPrint('Error occurred on ReportProvider.getTerminalDailySum() => $e');
      //MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return 0.0;
  }

  Future<bool> forgotPassword(BuildContext context, String userName) async {
    try {
      BaseResponse? response = await post(
        context,
        Routes.API_FORGOT_PASS,
        {
          'userName': userName,
        },
        {},
        true,
      );

      if (response == null) {
        return false;
      }

      if (response.errorCode > 0) {
        MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error occurred on AuthProvider.registerActivation() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return false;
  }

  Future<SaleTransactionResponse?> saleSoftpos(
    BuildContext context,
    SaleSoftposRequest request,
  ) async {
    try {
      BaseResponse? response = await post(
        context,
        Routes.API_TRANSACTION_SALE,
        request.toJson(),
        {},
        true,
      );

      if (response == null) {
        return null;
      }

      if (response.errorCode > 0) {
        DisabledCards? disabledCards = await getDisabledCardById(context, request.installment == 1 ? 2 : 1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(
              backgroundColor: Constants.PRIMARY,
              label: "Detay",
              textColor: Colors.black,
              onPressed: () {
                MainUtil.showCustomDialog(
                  context,
                  'Aktif Olmayan Kartlar',
                  disabledCards != null ? disabledCards.cardsNotPassedDesc! : "",
                  'Tamam',
                  () {
                    Navigator.of(context).pop();
                  },
                  false,
                );
              },
            ),
            duration: const Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
            content: Text(
              response.message!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.red,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 1000,
          ),
        );
        // MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return null;
      }

      return SaleTransactionResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error occurred on TransactionProvider.sale() => $e');
      DisabledCards? disabledCards = await getDisabledCardById(context, request.installment == 1 ? 2 : 1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            backgroundColor: Constants.PRIMARY,
            label: "Detay",
            textColor: Colors.black,
            onPressed: () {
              MainUtil.showCustomDialog(
                context,
                'Aktif Olmayan Kartlar',
                disabledCards != null ? disabledCards.cardsNotPassedDesc! : "",
                'Tamam',
                () {
                  Navigator.of(context).pop();
                },
                false,
              );
            },
          ),
          duration: const Duration(seconds: 10),
          behavior: SnackBarBehavior.floating,
          content: Text(
            e.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 1000,
        ),
      );
    }

    return null;
  }

  Future<DisabledCards?> getDisabledCardById(BuildContext context, int id) async {
    try {
      BaseResponse? response = await post(
        context,
        Routes.API_GET_CARDS_NOT_PASSED_BY_ID + id.toString(),
        {},
        {},
        true,
      );

      if (response == null) {
        return null;
      }

      if (response.errorCode > 0) {
        MainUtil.showSnack(context, response.message!, SnackType.ERROR);
        return null;
      }

      return DisabledCards.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error occurred on TransactionProvider.getDisabledCardById() => $e');
      MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return null;
  }

  Future<List<PaymentTransaction>?> getTransactions(
    BuildContext context,
    TransactionReportRequest request, {
    bool showProgress = true,
  }) async {
    try {
      BaseResponse? response = await post(
        context,
        Routes.API_REPORT_TRANSACTION,
        request.toJson(),
        {},
        showProgress,
      );

      if (response == null || response.errorCode > 0) {
        return null;
      }

      List<PaymentTransaction>? transactions;
      if (response.data != null) {
        transactions = (response.data as List).map((e) => PaymentTransaction.fromJson(e as Map<String, dynamic>)).toList();
      }
      return transactions;
    } catch (e) {
      debugPrint('Error occurred on ReportProvider.getTransactions() => $e');
      // MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }

    return null;
  }

  Future<PaymentTransaction?> getTransactionById(
    BuildContext context,
    String id,
  ) async {
    try {
      BaseResponse? response = await post(
        context,
        Routes.API_GET_TRANSACTION_BY_ID + id.toString(),
        {},
        {},
        false,
      );

      if (response == null || response.errorCode > 0) {
        return null;
      }

      return PaymentTransaction.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error occurred on ReportProvider.getTransactionById() => $e');
      // MainUtil.showSnack(context, '$e', SnackType.ERROR);
    }
    return null;
  }
}
