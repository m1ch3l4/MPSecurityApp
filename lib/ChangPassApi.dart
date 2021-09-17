import 'dart:convert';

import 'package:flutter_session/flutter_session.dart';
import 'package:security_app/usuario.dart';

import 'api_response.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class ChangePassApi{

  static Future<ApiResponse<Usuario>> changePass(String iduser, String password) async {
    try{

      var url =Constants.urlEndpoint+'user/changepass';

      print("url $url");

      Map params = {
        'id': iduser,
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

      Map mapResponse = json.decode(response.body);

      if(response.statusCode == 200){
        final usuario = Usuario.fromJson(mapResponse);
        await FlutterSession().set('logged', usuario);
        return ApiResponse.ok(usuario);
      }else{
        return ApiResponse.error("Erro");
      }

      return ApiResponse.error("Falha ao trocar a senha");

    }catch(error, exception){

      print("Erro : $error > $exception ");

      return ApiResponse.error("Sem comunicação ... tente mais tarde... ");

    }
  }

  static Future<ApiResponse<Usuario>> changePush(String iduser, bool elastic, bool zabbix, bool tickets) async {
    try{

      var url =Constants.urlEndpoint+'user/pushmessage';

      print("url $url");

      Map params = {
        'id': iduser,
        'pmElastic' : elastic,
        'pmZabbix': zabbix,
        'pmMoviedesk': tickets
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

      Map mapResponse = json.decode(response.body);

      if(response.statusCode == 200){
        final usuario = Usuario.fromJson(mapResponse);
        print("no changepass...");
        print(response.body);
        print("**********");
        await FlutterSession().set('logged', usuario);
        return ApiResponse.ok(usuario);
      }else{
        return ApiResponse.error("Erro");
      }

      return ApiResponse.error("Falha ao trocar a senha");

    }catch(error, exception){

      print("Erro : $error > $exception ");

      return ApiResponse.error("Sem comunicação ... tente mais tarde... ");

    }
  }

}