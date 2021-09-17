import 'dart:convert';

import 'package:security_app/constants.dart';

import 'usuario.dart';
import 'api_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class LoginApi{

  static Future<ApiResponse<Usuario>> login(String user, String password) async {
    try{

      var url =Constants.urlEndpoint+'user/anotherLogin';

      print("url $url");

      Map params = {
        'login': user,
        'password' : password
      };

      //encode Map para JSON(string)
      var body = json.encode(params);

      var response = await http.post(Uri.parse(url),
          headers: {"Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
            "Access-Control-Allow-Methods": "POST, OPTIONS"},
          body: body);

      print("${response.statusCode}");
      print("login...");
      print(response.body);
      print("++++++++++++++++");

      Map mapResponse = json.decode(response.body);

      if(response.statusCode == 200){
        final usuario = Usuario.fromJson(mapResponse);
        await FlutterSession().set('logged', usuario);
        return ApiResponse.ok(usuario);
      }

      return ApiResponse.error("Erro ao fazer o login");

    }catch(error, exception){

      print("Erro : $error > $exception ");

      return ApiResponse.error("Sem comunicação ... tente mais tarde... ");

    }
  }
}