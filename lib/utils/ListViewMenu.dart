import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_app/home.dart';
import 'package:security_app/inner/changepass.dart';
import 'package:security_app/inner/elastic_alerts.dart';
import 'package:security_app/inner/newspapper.dart';
import 'package:security_app/inner/preferencias.dart';
import 'package:security_app/inner/ticketsview.dart';
import 'package:security_app/inner/zabbix_alerts.dart';

import '../constants.dart';
import '../custom_route.dart';
import 'HexColor.dart';

class ListViewMenu extends StatelessWidget {
  String screen;
  Map<String, dynamic> usr;
  BuildContext ctx;
  TextTheme textTheme;

  ListViewMenu(String screen, Map<String, dynamic> user, TextTheme theme){
    this.screen = screen;
    this.usr = user;
    textTheme = theme;
  }
  @override
  Widget build(BuildContext context) {
    ctx = context;
    int _selectedDestination = 0;
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
          child: Text(
            'Olá '+usr['name'].toString(),
            style: textTheme.headline6,
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
        (screen!="home"? ListTile(
          leading: Icon(Icons.home_outlined,color:HexColor(Constants.red)),
          title: Text('Home',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 0,
          onTap: () => selectDestination(0),
        ):SizedBox(height:10)),
        (screen!="elastic"?ListTile(
          leading: Icon(Icons.add_alarm_outlined,color:HexColor(Constants.red)),
          title: Text('Alertas SIEM',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 1,
          onTap: () => selectDestination(1),
        ):SizedBox(height: 10)),
        (screen!="zabbix"?ListTile(
          leading: Icon(Icons.add_comment_outlined,color:HexColor(Constants.red)),
          title: Text('Zabbix',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 2,
          onTap: () => selectDestination(2),
        ):SizedBox(height: 10)),
        (screen!="tickets"?ListTile(
          leading: Icon(Icons.support,color:HexColor(Constants.red)),
          title: Text('Tickets',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 3,
          onTap: () => selectDestination(3),
        ):SizedBox(height: 10)),
        (screen!="news"?ListTile(
          leading: Icon(Icons.menu_book,color:HexColor(Constants.red)),
          title: Text('Notícias',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 4,
          onTap: () => selectDestination(4),
        ):SizedBox(height: 10)),
        Divider(
          height: 1,
          thickness: 1,
        ),
        (screen!="changepass"?ListTile(
          leading: Icon(Icons.account_circle_outlined,color:HexColor(Constants.red)),
          title: Text('Alterar Senha',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 5,
          onTap: () => selectDestination(5),
        ):SizedBox(height: 10)),
        (screen!="preferencias"?ListTile(
          leading: Icon(Icons.folder_shared_outlined,color:HexColor(Constants.red)),
          title: Text('Preferências do Usuário',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 6,
          onTap: () => selectDestination(6),
        ):SizedBox(height: 10)),
        ListTile(
          leading: Icon(Icons.logout,color:HexColor(Constants.red)),
          title: Text('Sair',style:Theme.of(context).textTheme.subtitle1),
          selected: _selectedDestination == 7,
          onTap: () => selectDestination(7),
        ),
      ],
    );
  }


  void selectDestination(int index) {
    switch(index){
      case 0:
        Navigator.of(ctx).pushReplacement(FadePageRoute(
          builder: (context) => Home(),
        ));
        break;
      case 1:
        Navigator.of(ctx).pushReplacement(FadePageRoute(
          builder: (context) => ElasticAlerts(),
        ));
        break;
      case 2:
        Navigator.of(ctx).pushReplacement(FadePageRoute(
          builder: (context) => ZabbixAlerts(),
        ));
        break;
      case 3:
        Navigator.of(ctx).pushReplacement(FadePageRoute(
          builder: (context) => Ticketsview(),
        ));
        break;
      case 4:
        Navigator.of(ctx).pushReplacement(FadePageRoute(
          builder: (context) => Newspapper(),
        ));
        break;
      case 5:
        Navigator.of(ctx).pushReplacement(FadePageRoute(
          builder: (context) => Changepass(),
        ));
        break;
      case 6:
        Navigator.of(ctx).pushReplacement(FadePageRoute(
          builder: (context) => Preferencias(),
        ));
        break;
      case 7:
        exit(0);
        break;
    }
  }
}