import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/requests/login_request.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/form_util.dart';
import '../../utils/loading.dart';
import '../../utils/main_util.dart';
import '../../utils/refresh_service.dart';
import '../../utils/routes.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _hidePassword = true;
  bool rememberMe = true;
  bool _usernameEnabled = false;

  @override
  void initState() {
    super.initState();
    _readPrefs();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            // Close the keyboard by unfocusing the current focus node
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Container(
                      height: height * 0.2,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage('assets/images/hst-icon.png'),
                                fit: BoxFit.fitWidth,
                                width: width * 0.5,
                              ),
                              // MainUtil.emptyWidget(height: 10),
                              // const Text(
                              //   'Kolay Ödeme Sistemleri',
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //     fontWeight: FontWeight.w800,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _loginForm,
                      child: Column(
                        children: [
                          FormUtil.formLabel(
                            'TELEFON NUMARASI',
                            textColor: Colors.white,
                            fontSize: 18,
                            marginLeft: width * 0.05,
                            fontWeight: FontWeight.w500,
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          FormUtil.textField(
                            _phoneCtrl,
                            width * 0.8,
                            Container(
                              width: 40,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                '+90 ',
                                style: Constants.BLACK_16,
                              ),
                            ),
                            null,
                            '',
                            Validators.isNotEmptyOrNull,
                            'Telefon numarası zorunlu alan',
                            TextInputType.phone,
                            [LengthLimitingTextInputFormatter(10)],
                            fillColor: Colors.transparent,
                            borderColor: Colors.white,
                            radius: 0,
                            isBorderUnderlined: true,
                            cursorColor: Colors.white,
                            enabled: _usernameEnabled,
                          ),
                          MainUtil.emptyWidget(height: 20),
                          FormUtil.formLabel(
                            'ŞİFRE',
                            textColor: Colors.white,
                            fontSize: 18,
                            marginLeft: width * 0.05,
                            fontWeight: FontWeight.w500,
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          FormUtil.passwordField(
                            _passwordCtrl,
                            width * 0.8,
                            null,
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                child: Icon(
                                  _hidePassword ? Icons.visibility_off : Icons.visibility,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            '',
                            Validators.isNotEmptyOrNull,
                            'Şifre zorunlu alan',
                            _hidePassword,
                            TextInputType.number,
                            [LengthLimitingTextInputFormatter(6)],
                            fillColor: Colors.transparent,
                            borderColor: Colors.white,
                            radius: 0,
                            isBorderUnderlined: true,
                            cursorColor: Colors.white,
                          ),
                          MainUtil.emptyWidget(height: 10),
                          SizedBox(
                              width: width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (val) {
                                      setState(() {
                                        rememberMe = val!;
                                        if (!_usernameEnabled && !val) {
                                          _usernameEnabled = true;
                                        }
                                      });
                                    },
                                    checkColor: Constants.PRIMARY,
                                    activeColor: Colors.white,
                                  ),
                                  MainUtil.emptyWidget(width: 10),
                                  const Text(
                                    'Beni Hatırla',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )),
                          MainUtil.emptyWidget(height: 40),
                          SizedBox(
                            width: width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FormUtil.elevatedButton(
                                  () async => await _login(),
                                  true,
                                  'GİRİŞ YAP',
                                  width * 0.35,
                                  25,
                                  height: 40,
                                  fontColor: Constants.SECONDARY,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: GestureDetector(
                              onTap: () => MainUtil.openForgotPasswordDialog(
                                context,
                                () => MainUtil.pop(context),
                              ),
                              child: const Text(
                                'Şifremi Unuttum',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _login() async {
    MainUtil.closeKeyboard(context);

    if (!_loginForm.currentState!.validate()) {
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    if (!pref.containsKey("DONT_SHOW_SOFTPOS_DIALOG")) {
      pref.setBool("DONT_SHOW_SOFTPOS_DIALOG", false);
    }
    await pref.setBool('REMEMBER_ME', rememberMe);
    if (rememberMe) {
      await pref.setString('USER_NAME', _phoneCtrl.text);
      await pref.setString('USER_PASSWORD', _passwordCtrl.text);
    } else {
      await pref.remove('USER_NAME');
    }

    LoginRequest request = LoginRequest(userName: _phoneCtrl.text, password: _passwordCtrl.text);

    ProgressDialog progress = ProgressDialog(context);
    progress.style(message: tr('texts.wait'));

    await progress.show();

    int tokenResult = await Provider.of<AuthProvider>(context, listen: false).login(context, request, false);

    if (tokenResult < 0) {
      await progress.hide();
      return;
    }

    if (tokenResult == 0) {
      RefreshService refresher = RefreshService();
      await refresher.refreshUser(context, sendMobileInfo: true, showProgress: false);

//      context.pushReplacement("/home");
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME, ModalRoute.withName("/"));

      /*
      MainUtil.navigateTo(
          context,
          ActivationScreen(
            type: ActivationType.LOGIN,
            phone: _phoneCtrl.text,
          ),
          false);
          */
    } else {
      if (tokenResult == 4) {
        // MainUtil.navigateTo(
        //   context,
        //   ChangeInfoScreen(
        //     type: ChangeType.PASSWORD,
        //     isLoggedIn: false,
        //   ),
        //   false,
        // );
      }
    }
  }

  _readPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool prefRemember = false;

    if (pref.containsKey('REMEMBER_ME')) {
      prefRemember = pref.getBool('REMEMBER_ME') != null ? pref.getBool('REMEMBER_ME')! : false;
      rememberMe = prefRemember;
    } else {
      prefRemember = false;
      rememberMe = true;
    }

    setState(() {
      rememberMe = prefRemember;
    });

    String? prefUserName = pref.getString('USER_NAME');
    String? prefPassword = pref.getString('USER_PASSWORD');

    if (prefRemember && Validators.isNotEmptyOrNull(prefUserName) && Validators.isNotEmptyOrNull(prefPassword)) {
      setState(() {
        _phoneCtrl.text = prefUserName!;
        _passwordCtrl.text = prefPassword!;
        _usernameEnabled = false;
      });
      await _login();
    } else {
      setState(() {
        _usernameEnabled = true;
      });
    }
  }
}
