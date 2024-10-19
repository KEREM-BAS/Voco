// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Constants {
  static const LIRA_SYMBOL = '₺';

  /// COLORS
  static const PRIMARY = Color.fromRGBO(13, 181, 105, 1);
  static const SECONDARY = Color.fromRGBO(18, 10, 60, 1);

  static const BG_COLOR = Color.fromRGBO(240, 240, 240, 1);
  static const BUTTON_BG = Color.fromRGBO(18, 10, 60, 1);

  static const HOME_BG_BOTTOM = Color.fromRGBO(250, 250, 250, 1);
  static const PZ_TABS = Color.fromRGBO(61, 61, 59, 1);
  static const SEPARATOR = Color.fromRGBO(238, 191, 82, 1);

  /// HTTP CONSTANTS
  /// http://devapi.hstmobil.com.tr:8081/api/
  /// http://apitester.hstmobil.com.tr:8081/api/
  static const MOBILE = '2';
  static const SERVICE_TEST_URL = 'https://devapi.hstmobil.com.tr/api/';
  static const SERVICE_PROD_URL = 'https://api.hstmobil.com.tr/api/';
  static const CONTENT_URL = 'https://wallet.vizyonpay.com.tr';
  static const IMAGE_URL = "https://merchantdocument.hstmobil.com.tr/";
  static const IMAGE_URL_TEST = "https://merchantdocument.hstmobil.com.tr/";

  /// APP CONSTANTS
  static const String APP_STORE_URL = 'https://apps.apple.com/tr/app/hstpos/id6447300301';
  static const String PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=com.hstpos.app';

  static const String COMPANY_NAME = 'Vizyon Elektronik Para ve Ödeme Hizmetleri A.Ş.';
  static const String COMPANY_PHONE = '+90 850 533 03 33';
  static const String COMPANY_MAIL = 'info@vizyonpay.com.tr';
  static const String COMPANY_ADDRESS = 'Esentepe mahallesi Büyükdere caddesi Maya Akar Center '
      'No:102B Kat:8 D:37-38, 34394 Şişli/İstanbul';
  static const String COMPANY_IBAN = 'TR96 0000 0000 0000 0000 94';
  static const String COMPANY_LAT = '41.0681658';
  static const String COMPANY_LONG = '29.0070833';

  static const String FACEBOOK_URL = 'https://www.facebook.com/HST-Mobil-108579282187434';
  static const String TWITTER_URL = 'https://twitter.com/HstMobil';
  static const String INSTAGRAM_URL = 'https://www.instagram.com/hstmobil/';
  static const String LINKEDIN_URL = 'https://tr.linkedin.com/company/hst-mobil-odeme-sistemleri';
  static const String YOUTUBE_URL = 'https://www.youtube.com/faturavizyon';

  /// TEXT STYLES
  static const TEXT_STYLE = TextStyle(
    color: Colors.white,
  );

  static const ITALIC_INFO = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontStyle: FontStyle.italic,
  );

  static const INTRO_TEXT_STYLE = TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const HINT_STYLE = TextStyle(
    color: Constants.PRIMARY,
    fontSize: 13.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const HINT_STYLE_DARK = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const HINT_STYLE_LINK = TextStyle(
    color: Colors.white70,
    fontSize: 13.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.underline,
  );

  static const HINT_STYLE_DARK_LINK = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.underline,
  );

  static TextStyle HINT_STYLE_UNDERLINED(double width) {
    return TextStyle(
      color: Constants.PRIMARY,
      fontSize: 50.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: width / 70,
    );
  }

  static TextStyle HINT_STYLE_UNDERLINED_DARK(double width) {
    return TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: width / 13,
    );
  }

  static TextStyle INPUT_STYLE_SPACED(double width) {
    return TextStyle(
      color: Constants.SECONDARY,
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: width / 10,
      decoration: TextDecoration.none,
    );
  }

  static const INPUT_STYLE = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const INPUT_AMOUNT_STYLE = TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const INPUT_STYLE_DISABLED = TextStyle(
    color: Colors.black54,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BUTTON_TEXT_STYLE = TextStyle(
    color: Constants.PRIMARY,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const BOTTOM_HEADER_STYLE = TextStyle(
    color: Colors.black87,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const HEADER_STYLE = TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_10 = TextStyle(
    color: Colors.black,
    //fontFamily: 'Comic Sans',
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_11 = TextStyle(
    color: Colors.black,
    fontSize: 11.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_12 = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_12_W600 = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const WHITE_12_W600 = TextStyle(
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_12_W600_ROBOTO = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontFamily: 'Roboto',
  );

  static const BLACK_14 = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_14_ARIAL = TextStyle(
    fontFamily: 'Arial',
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_14_ITALIC = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  static const BLACK_14_W600 = TextStyle(
    color: Colors.black,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_16 = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_16_W600 = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_18 = TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const BLACK_18_W600 = TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const CARD_TITLE = TextStyle(
    color: Colors.white,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  static const CARD_AMOUNT = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static TextStyle TRANSFER_AMOUNT(Color color, {double fontSize = 60}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    );
  }

  static const CARD_TITLE_SUB = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const CARD_TITLE_SUB13 = TextStyle(
    color: Colors.black,
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static const CARD_SHARE = TextStyle(
    color: Colors.black,
    fontSize: 11.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const TEXT_STYLE_TABS = TextStyle(
    color: SECONDARY,
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const TEXT_STYLE_BOTTOMSHEET = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  static const TEXT_STYLE_BOTTOMSHEET_BOLD = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const TEXT_STYLE_LISTITEM = TextStyle(
    color: Colors.black,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static const LISTITEM_SUBTITLE = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );

  static const NEGATIVE = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static const CURRENCY_NEGATIVE = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: 'Roboto',
  );

  static const NEGATIVE_14 = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    fontFamily: 'Roboto',
  );

  static const POSITIVE = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static const CURRENCY_POSITIVE = TextStyle(
    color: Colors.green,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    fontFamily: 'Roboto',
  );

  static Color LOGIN_INPUT_BG = const Color.fromRGBO(41, 44, 56, 0.8);
  static Color LOGIN_THUMB = const Color.fromRGBO(117, 206, 223, 1);

  static const TRANSACTION_AVATAR_STYLE = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const BS_BUTTON_TEXT_STYLE = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const ALERT_STYLE = TextStyle(
    color: Constants.PRIMARY,
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const GREEN_18_BOLD = TextStyle(
    color: Colors.green,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const GREEN_16_BOLD = TextStyle(
    color: Colors.green,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  static const DRAWER_STYLE = TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  static String LOREM_IPSUM =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut pharetra nibh. Phasellus neque nunc, commodo quis sollicitudin vel, posuere eget neque. Ut sit amet pretium lorem. Phasellus suscipit eu tortor in sollicitudin. Morbi at hendrerit nisl, ut sollicitudin est. Etiam bibendum arcu sed libero ullamcorper, quis viverra augue hendrerit. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\n'
      'Morbi non dictum libero. Phasellus blandit, lacus in tincidunt pharetra, odio enim finibus arcu, vel semper metus lacus non sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ultricies, erat sit amet finibus pharetra, nisi mi ultrices sem, sed facilisis nisi urna sed ipsum. Nulla pharetra condimentum libero vel porta. Maecenas molestie, arcu sit amet tincidunt elementum, tortor augue tincidunt enim, eget tristique metus nunc vitae tortor. Sed eget dignissim ligula. Donec dapibus elit non ligula accumsan, sit amet semper lectus dictum. Nam non leo sit amet nunc aliquet eleifend at vitae sem. Morbi sed justo at turpis dapibus pellentesque dictum quis velit. Praesent est augue, luctus vitae elementum vel, varius vitae turpis. Fusce vel commodo augue. Nam pretium placerat suscipit. Integer viverra dapibus arcu a suscipit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.\n\n'
      'Cras quam ex, tempor ut velit nec, interdum lobortis tellus. Vestibulum sit amet finibus sem. Donec quis elit placerat, facilisis elit quis, auctor lorem. Nulla facilisi. Ut est dolor, elementum ac auctor et, laoreet tempor massa. Vestibulum bibendum mi eu luctus consectetur. Phasellus sed erat vel nisl rhoncus lobortis at ornare lacus. Nam cursus commodo urna, sit amet feugiat erat consequat et. Nunc euismod turpis felis, nec congue magna auctor vel. Donec rhoncus vulputate quam at dictum.\n\n'
      'Nulla iaculis magna sagittis, aliquet mauris vel, facilisis magna. Fusce quam turpis, maximus sed tortor id, vestibulum bibendum eros. Nullam tincidunt turpis in leo vulputate iaculis. Suspendisse molestie nec justo et auctor. Ut efficitur augue libero, id facilisis odio sagittis eget. Etiam imperdiet tempus elit et lacinia. Donec suscipit, sapien commodo iaculis pretium, turpis augue aliquam nisi, a accumsan purus arcu eu felis. Phasellus arcu eros, tincidunt nec turpis ut, congue auctor purus. Maecenas lectus eros, rhoncus sed tempus vel, vulputate at arcu. Proin mollis mauris urna, id sollicitudin mauris fermentum vel. In non tortor et nulla rhoncus eleifend. Suspendisse potenti. Vivamus sit amet risus vitae ex maximus fermentum. Vivamus malesuada eros ac laoreet fringilla. Etiam sagittis dictum arcu sit amet iaculis. Aenean ac nunc eu neque semper malesuada.\n\n'
      'Cras aliquet, lorem at facilisis scelerisque, lorem ipsum pellentesque turpis, nec viverra libero nisi eu tellus. Nunc vitae diam vel neque eleifend dignissim id id neque. Quisque facilisis dolor eget ultricies dapibus. Morbi imperdiet ex vel ante tincidunt aliquet. Sed a dictum nibh. Mauris eleifend enim diam, sit amet commodo nibh vestibulum nec. Aliquam erat volutpat. Nullam eu tellus aliquet, lobortis elit eget, maximus nisl. Quisque faucibus ac ante id interdum. Sed quis augue vel velit posuere consequat. Donec eget arcu finibus, aliquam orci eu, aliquam lorem. Fusce in semper felis, ornare blandit risus. Cras sit amet ex sed libero fermentum malesuada.';
}
