import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:security_app/ChangPassApi.dart';
import 'package:security_app/utils/FirebaseMessagingHandle.dart';
import 'package:security_app/utils/HexColor.dart';
import 'package:security_app/utils/ListViewMenu.dart';
import '../constants.dart';

void main() => runApp(new Preferencias());

class Preferencias extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: FlutterSession().get("logged"),
        builder: (context,snapshot){
          return (snapshot.hasData ? new MaterialApp(
            title: 'TI & Segurança',
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: new PrefPage(title: 'Preferências do usuário', user: snapshot.data),
          ) : CircularProgressIndicator());
        },
      ),
    );
  }
}

class PrefPage extends StatefulWidget {
  PrefPage({Key key, this.title,this.user}) : super(key: key);

  final String title;
  final Map<String, dynamic> user;

  @override
  _PrefPageState createState() => new _PrefPageState();
}

class _PrefPageState extends State<PrefPage> {
  var firebaseFCM;

  GlobalKey<FormState> _key = new GlobalKey();

  Map<String, bool> pushMessage = {
    'Alertas SIEM ': true,
    'Alertas Zabbix': true,
    'Alertas Tickets MovieDesk': true,
  };

  final String keyElastic = "Alertas SIEM ";
  final String keyZabbix = "Alertas Zabbix";
  final String keyTickets = "Alertas Tickets MovieDesk";
  void initState() {
    super.initState();
    pushMessage = {
      'Alertas SIEM ': widget.user['pm_elastic'],
      'Alertas Zabbix': widget.user['pm_zabbix'],
      'Alertas Tickets MovieDesk': widget.user['pm_tickets'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    firebaseFCM = new FCMHandle(widget.user,"preferencias", context);


    return new Scaffold(
      appBar: AppBar(title: Text(widget.title),
          backgroundColor: HexColor(Constants.red)
      ),
      drawer: Drawer(
        child: ListViewMenu('preferencias',widget.user,textTheme),
      ),
      body:  Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        width: double.maxFinite,
        child: new Form(
          key: _key,
          child: _formUI(),
        ),
      ),
    );
  }
  Widget _formUI() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Center(child: Text('Notificações por Mensagem Push',style: TextStyle(color: HexColor(Constants.red), fontWeight: FontWeight.w700, fontSize: 18.0))),
        new SizedBox(height: 15.0),
        new Column(children:getOptionsCheckBox()),
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Salvar',style:TextStyle(color: HexColor(Constants.red), fontWeight: FontWeight.w700, fontSize: 14.0)),
        )
      ],
    );
  }

  List<CheckboxListTile> getOptionsCheckBox(){
    return pushMessage.keys
        .map((roomName) => CheckboxListTile(
      title: Text(roomName),
      value: pushMessage[roomName],
      checkColor: Colors.white,
      activeColor: HexColor(Constants.red),
      onChanged: (bool value) {
        setState(() {
          pushMessage[roomName] = value;
        });
      },
    )).toList();
  }


  _sendForm() {
    bool elastic,zabbix,ticket;
    pushMessage.forEach((key, value){
      print('Key: $key');
      print('Value: $value');
      print('------------------------------');
      if(key==keyElastic)
        elastic = value;
      if(key==keyZabbix)
        zabbix = value;
      if(key==keyTickets)
        ticket = value;
    });
    changePref(widget.user['id'].toString(), elastic,zabbix,ticket);
  }

  Future<String> changePref(String iduser,bool elastic, bool zabbix, bool tickets) {
    return ChangePassApi.changePush(iduser,elastic,zabbix,tickets).then((resp) {
      print('LoginAPI. ${resp.ok}');
      if(!resp.ok){
        Fluttertoast.showToast(
            msg: "Não foi possível alterar as preferências!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: HexColor(Constants.red),
            textColor: Colors.white,
            fontSize: 16.0
        );
        return 'user not exists';
      }else {
        Fluttertoast.showToast(
            msg: "Preferências alteradas com sucesso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: HexColor(Constants.red),
            textColor: Colors.white,
            fontSize: 16.0
        );
        return 'senha alterada';
      }
    });
  }

}