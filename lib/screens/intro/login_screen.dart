import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voco/providers/auth_provider.dart';
import 'package:voco/providers/riverpod_provider.dart';
import 'package:voco/screens/home/home_screen.dart';
import 'package:voco/utils/main_util.dart';

class LoginScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _emailPasswordWidget(),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: Text('Forgot Password ?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: 30),
                    _submitButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _entryEmailField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _entryPasswordField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          //name textfield
          Container(
            child: TextFormField(
              controller: passController,
              obscureText: isPassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromARGB(255, 96, 8, 198),
                    Color.fromARGB(255, 70, 6, 149),
                    Color.fromARGB(255, 92, 43, 152),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.all(16.0), primary: Colors.white, textStyle: const TextStyle(fontSize: 20)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  debugPrint('Form is valid');
                  bool a = await AuthProvider().login(context, emailController.text, passController.text);
                  if (a) {
                    MainUtil.navigateTo(context, HomeScreen(), true);
                  }
                } else {
                  debugPrint('Form is invalid');
                }
              },
              child: const Text('Sign in')),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Welcome back\n',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: [
            TextSpan(
                text: "Continue with Email",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                ))
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryEmailField("Email"),
        _entryPasswordField("Password", isPassword: true),
      ],
    );
  }
}
