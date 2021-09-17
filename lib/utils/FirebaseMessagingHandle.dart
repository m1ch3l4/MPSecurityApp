import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_app/inner/elastic_alerts.dart';
import 'package:security_app/inner/newspapper.dart';
import 'package:security_app/inner/ticketsview.dart';
import 'package:security_app/inner/zabbix_alerts.dart';
import 'package:security_app/model/MessageModel.dart';

import '../constants.dart';
import '../custom_route.dart';
import '../home.dart';
import 'HexColor.dart';

class FCMHandle{
  String user;
  String company;
  BuildContext ctx;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var messageFCM = new MessageData('titulo','texto','tipo');
  //final Function updateData;
  String screen;
  Map<String, dynamic> usr;

  FCMHandle(Map<String,dynamic> user, String scr, BuildContext ctx){
    this.usr = user;
    this.screen = scr;
    this.ctx = ctx;
    _registerOnFirebase();
    getMessage();
  }

  _registerOnFirebase() {
    //widget.user = await FlutterSession().get("logged");
    print("**user id: ");
    print(user);
    print("**company id:");
    print(company);
    print("**********************");
    if(usr['pm_elastic'])
    _firebaseMessaging.subscribeToTopic('/topics/elastic'+usr['company_id'].toString());
    print('/topics/elastic'+usr['company_id'].toString());
    if(usr['pm_zabbix'])
    _firebaseMessaging.subscribeToTopic('/topics/zabbix'+usr['company_id'].toString());
    if(usr['pm_tickets']);
    _firebaseMessaging.subscribeToTopic('/topics/techsupport'+usr['id'].toString());
    _firebaseMessaging.subscribeToTopic('all');
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
            print("onMessage*************");
            print('Pure.message: $message');
            print("***********************");
            messageFCM.text = message["notification"]["body"];
            messageFCM.title = message["notification"]["title"];
            if (Platform.isAndroid) {
              messageFCM.type = message["data"]["type"];
            } else if (Platform.isIOS) {
              messageFCM.type = message["type"];
            }
          showMessage(messageFCM);
          //TODO: ver como chamar um método do ctx
        },
        onResume: (Map<String, dynamic> message) async {
          //Fluttertoast.showToast(msg: "onResume $message");
          print("***************************************");
          print(message);
          print("***************************************");
          if (Platform.isAndroid) {
            messageFCM.type = message["data"]["type"];
          } else if (Platform.isIOS) {
            messageFCM.type = message["type"];
          }
          switch(messageFCM.type){
            case 'elastic':
              Navigator.of(ctx).pushReplacement(FadePageRoute(builder: (context) => ElasticAlerts(),));
              break;
            case 'zabbix':
              Navigator.of(ctx).pushReplacement(FadePageRoute(builder: (context) => ZabbixAlerts(),));
              break;
            case 'techsupport':
              Navigator.of(ctx).pushReplacement(FadePageRoute(builder: (context) => Ticketsview(),));
              break;
            default:
            //Navigator.of(context).pop();
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          //Fluttertoast.showToast(msg: "onLaunch $message");
        });
  }

  void showMessage(MessageData message){
    print("Show message..$message");
    if(message.title!="titulo") {
      showDialog(
          context: ctx,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Text(message.title,
                  style: TextStyle(color: HexColor(Constants.red))),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(message.text)
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ciente',
                      style: TextStyle(color: HexColor(Constants.blue))),
                  onPressed: () {
                    switch (message.type) {
                      case 'elastic':
                        Navigator.of(context).pushReplacement(FadePageRoute(
                          builder: (context) => ElasticAlerts(),));
                        break;
                      case 'zabbix':
                        Navigator.of(context).pushReplacement(FadePageRoute(
                          builder: (context) => ZabbixAlerts(),));
                        break;
                      case 'techsupport':
                        Navigator.of(context).pushReplacement(FadePageRoute(
                          builder: (context) => Home(),));
                        break;
                      case 'news':
                        Navigator.of(context).pushReplacement(
                            FadePageRoute(builder: (context) => Newspapper(),));
                        break;
                      default:
                        Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          }
      );
    }
  }

}