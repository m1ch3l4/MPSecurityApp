import 'dart:async';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:security_app/utils/HexColor.dart';
import 'api_login.dart';
import 'constants.dart';
import 'custom_route.dart';
import 'home.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  final inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(10.0),
    top: Radius.circular(20.0),
  );

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> webLogin(LoginData data) {
    return LoginApi.login(data.name, data.password).then((resp) {
      print('LoginAPI. ${resp.ok}');
      if(!resp.ok){
        return 'user not exists';
      }else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: ' ',
      logo: 'images/logo.webp',
      logoTag: '',
      titleTag: "Security App",
      hideForgotPasswordButton: true,
      hideSignUpButton: true,
      emailValidator: (value) {
        if (!value.contains('@') || !(value.endsWith('.com.br')||value.endsWith('.com'))) {
          return "Email must contain '@' and end with '.com' or '.com.br'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        //return _loginUser(loginData);
        return webLogin(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return webLogin(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context)=>Home(),
        ));
      },
      onRecoverPassword: (_) => Future(null),
      showDebugButtons: false,
      theme: LoginTheme(
        buttonTheme:LoginButtonTheme(
          splashColor: HexColor(Constants.blue),
          backgroundColor: HexColor(Constants.red),
          highlightColor: HexColor(Constants.black),
        )
      ),
    );
  }
}
