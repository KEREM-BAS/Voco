import 'package:voco/screens/home/home.view.dart';
import '../screens/login/login.view.dart';

class Routes {
  /******************/
  /**  Service URLs */
  /******************/
  /// AUTH
  static const API_REGISTER = 'Auth/register';
  static const API_LOGIN = 'Auth/login';
  static const API_LOGIN_ACTIVATION_CODE_REFRESH = 'Auth/LoginActivationCodeRefresh';
  static const API_LOGIN_ACTIVATION_CHECK = 'Auth/LoginActivationCheck';
  static const API_ACTIVATION_CODE_CHECK = 'Auth/ActivationCodeCheck';

  /// USER OPERATION
  static const API_GET_USER = 'UserOperation/get-user';
  static const API_FORGOT_PASS = 'UserOperation/forgot-password';
  static const API_UPDATE_USER = 'UserOperation/update-user';
  static const API_CHANGE_PASSWORD = 'UserOperation/Change-User-Password';
  static const API_GET_USER_LIST = 'UserOperation/Get-User-List';

  /// TERMINAL
  static const API_GET_TERMINAL = 'Terminal/Get-terminal?TerminalId=';
  static const API_GET_TERMINAL_LIST = 'Terminal/Get-terminal-list';
  static const API_GET_TERMINAL_LIST_BY_CATEGORY = 'Terminal/Get-CategoryId-terminal-list?categoryId=';
  static const API_CREATE_TERMINAL = 'Terminal/Create-terminal';
  static const API_UPDATE_TERMINAL = 'Terminal/Update-terminal';
  static const API_GET_MERCHANT_TERMINAL_LIST = 'Terminal/Get-Merchant-terminal-list';
  static const API_GET_MERCHANT_TERMINAL = 'Terminal/Get-Merchant-terminal-list-By-MerchentId?merchantId=';

  /// MERCHANT
  static const API_GET_MERCHANT = 'Merchant/Get-Merchant?MerchantId=';
  static const API_MERCHANT_LIST = 'Merchant/Merchant-List';
  static const API_CREATE_MERCHANT = 'Merchant/Create-merchant';
  static const API_UPDATE_MERCHANT = 'Merchant/Update-merchant';
  static const API_MERCHANT_DOCUMENT = 'Merchant/Merchant-Document-save';
  static const API_MERCHANT_PROFILE_IMAGE = 'Merchant/Merchant-Image-Profile-save';
  static const API_MERCHANT_INVITE_PERSONNEL = 'Merchant/Invite-Merchant-Personnel';
  static const API_MERCHANT_GET_DOCUMENT = 'Merchant/Get-Merchant-Document?merchantId=';
  static const API_MERCHANT_GET_CITY = 'Merchant/Get-City';
  static const API_MERCHANT_GET_DISTRICT = 'Merchant/Get-District?cityNo=';
  static const API_GET_SOFTPOS_RATES = 'Merchant/Taxi-Pos-Rates?merchantId=';

  /// CARDSNOTPASSED
  static const API_GET_CARDS_NOT_PASSED_BY_ID = 'CardsNotPassed/Get-Card-Not-Passed-By-Id?id=';

  /// TRANSACTION
  static const API_TRANSACTION_SALE = 'Transaction/sale';
  static const API_TRANSACTION_SALE_RESULT = 'Transaction/VizyonPos-Sale-Result';
  static const API_TRANSACTION_LINK_SALE = 'Transaction/link-sale';
  static const API_GET_TRANSACTION_BY_ID = 'External/Transaction-Detail-By-HostId?orderId=';

  /// REPORT
  static const API_REPORT_TRANSACTION = 'Report/transaction-report';
  static const API_REPORT_TERMINAL_DAILY_SUM = 'Report/Get-Terminal-Today-Sum';
  static const API_REPORT_MERCHANT_DAILY_SUM = 'Report/Get-Merchants-Today-Sum';

  /// INSTALLMENT
  static const API_INSTALLMENT_GET_ALL = 'Installment/Get-All-Installment';
  static const API_INSTALLMENT_BY_ID = 'Installment/Get-Installment-ById';

  /// BATCH
  static const API_BATCH_DAILY_SUM_REPORT = 'Batch/Daily-Batch-Sum-Report';
  static const API_BATCH_AUTO_CLOSE = 'Batch/Batch-auto-close';
  static const API_BATCH_MERCHANT_CLOSE = 'Batch/Batch-merchant-close';

  /// USER MOBILE
  static const API_USER_MOBILE_GET_LIST = 'MobileInfo/Get-Mobile-List';
  static const API_USER_MOBILE_GET_BY_USER_ID = 'MobileInfo/Get-User-Mobile-By-UserId';
  static const API_USER_MOBILE_GET_BY_ID = 'MobileInfo/Get-User-Mobile-By-Id';
  static const API_USER_MOBILE_ADD = 'UserMobile/api/MobileInfo/Add-User-Mobile';
  static const API_USER_MOBILE_VERSION = 'UserMobile/api/MobileInfo/Mobile-Version';

  /// BANK
  static const API_BANK_GET_LIST = 'Bank/Get-Bank-List';
  static const API_BANK_GET_LIST_BY_MERCHANT_ID = 'Bank/Get-Bank-List-By-MerchantId';
  static const API_BANK_GET_LIST_BY_BANK_CODE = 'Bank/Get-Bank-List-By-BankCode';
  static const API_BANK_GET_LIST_BY_BANK_ID = 'Bank/Get-Bank-List-By-BankId';

  /// MERCHANT BANK
  static const API_MERCHANT_BANK_GET_LIST = 'MerchantBank/Get-All-Merchant-Banks';
  static const API_MERCHANT_BANK_GET_LIST_BY_MERCHANT_ID = 'MerchantBank/Get-Merchant-Bank-List-ByMerchantId';
  static const API_MERCHANT_BANK_GET_BY_ID = 'MerchantBank/Get-Merchant-Bank-ById';
  static const API_MERCHANT_BANK_CREATE = 'MerchantBank/Create-Merchant-Bank';
  static const API_MERCHANT_BANK_UPDATE = 'MerchantBank/Update-Merchant-Bank';
  static const API_MERCHANT_BANK_DELETE = 'MerchantBank/Delete-Merchant-Bank';

  /******************/
  /**   APP Routes  */
  /// ***************

  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const DETAILS = '/details/:id';

  static getAllRoutes() {
    return {
      LOGIN: (context) => const LoginScreen(),
      HOME: (context) {
        try {
          // Uri uri = Uri(query: ModalRoute.of(context)!.settings.arguments.toString());
          return const HomeView();
          /* data: uri.queryParameters["data"], sessionToken: uri.queryParameters["paymentSessionToken"] */
        } catch (e) {
          return const HomeView();
        }
      },
      DETAILS: (context) {
        // final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return const HomeView();
        /* isSuccessful: args['id'] */
      },
    };
  }
}

// GoRouter goRouter = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const WelcomeScreen(),
//     ),
//     GoRoute(
//       path: "/home",
//       pageBuilder: (context, state) {
//         try {
//           log(state.uri.queryParameters["data"].toString(), name: "data");
//           log(state.uri.queryParameters["paymentSessionToken"].toString(), name: "paymentSessionToken");
//           String? fullPath = state.fullPath;
//           if (fullPath != null) {
//             Uri uri = Uri.parse(fullPath);
//             if (uri.queryParameters["data"]?.isNotEmpty ?? false) {
//               return MaterialPage(
//                 child: HomeScreen(
//                   data: uri.queryParameters["data"],
//                   sessionToken: uri.queryParameters["paymentSessionToken"],
//                 ),
//               );
//             }
//           }
//         } catch (e) {
//           log(e.toString());
//         }
//         return MaterialPage(child: HomeScreen());
//       },
//     ),
//     GoRoute(
//       path: "/login",
//       builder: (context, state) => const LoginScreen(),
//     ),
//   ],
// );
