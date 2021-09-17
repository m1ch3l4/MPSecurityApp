import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:security_app/ChangPassApi.dart';
import 'package:security_app/utils/FirebaseMessagingHandle.dart';
import 'package:security_app/utils/HexColor.dart';
import 'package:security_app/utils/ListViewMenu.dart';
import '../constants.dart';

void main() => runApp(new Changepass());

class Changepass extends StatelessWidget {

  static const routeName = '/news';
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
            home: new PassPage(title: 'Alterar senha de acesso', user: snapshot.data),
          ) : CircularProgressIndicator());
        },
      ),
    );
  }
}

class PassPage extends StatefulWidget {
  PassPage({Key key, this.title,this.user}) : super(key: key);

  final String title;
  final Map<String, dynamic> user;

  @override
  _PassPageState createState() => new _PassPageState();
}

class _PassPageState extends State<PassPage> {
  var firebaseFCM;

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  // Initially password is obscure
  bool _obscureText = true;
  String senha, confsenha;

  void initState() {
    super.initState();
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    firebaseFCM = new FCMHandle(widget.user,"changepass", context);

    return new Scaffold(
      appBar: AppBar(title: Text(widget.title),
          backgroundColor: HexColor(Constants.red)
      ),
      drawer: Drawer(
        child: ListViewMenu('changepass',widget.user,textTheme),
      ),
      body:  Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        width: double.maxFinite,
        child: new Form(
          key: _key,
          autovalidate: _validate,
          child: _formUI(),
        ),
      ),
    );
  }
  Widget _formUI() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Nova Senha'),
            maxLength: 8,
            validator: _validarSenha,
            onChanged: (String val){
              senha = val;
            },
            onSaved: (String val) {
              senha = val;
            },
            obscureText: _obscureText,
          ),
            new IconButton(
                onPressed: _toggle,
                icon: Icon(Icons.remove_red_eye_sharp),
                color: HexColor(Constants.red),),
            new TextFormField(
              decoration: new InputDecoration(hintText: 'Confirme a senha'),
              maxLength: 8,
              validator: _validarConfSenha,
              onSaved: (String val) {
                confsenha = val;
              },
              obscureText: _obscureText,
            ),
        new SizedBox(height: 15.0),
        new RaisedButton(
          onPressed: _sendForm,
          child: new Text('Enviar',style:TextStyle(color: HexColor(Constants.red), fontWeight: FontWeight.w700, fontSize: 14.0)),
        )
      ],
    );
  }

  String _validarSenha(String value) {
    if (value.length == 0) {
      return "Informe a senha";
    } else if(value.length != 8){
      return "A senha deve ter 8 caracteres";
    }
    return null;
  }

  String _validarConfSenha(String value) {
    if (value!=senha) {
      return "A senha e a confirmação devem ser iguais";
    }
    return null;
  }

  _sendForm() {
    if (_key.currentState.validate()) {
      // Sem erros na validação
      _key.currentState.save();
      print("Senha $senha");
      print("Confsenha $confsenha");
      changePass(widget.user['id'].toString(), senha);
    } else {
      print("Diz q. não está correto...");
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
  }

  Future<String> changePass(String iduser,String newpass) {
    return ChangePassApi.changePass(iduser, newpass).then((resp) {
      print('LoginAPI. ${resp.ok}');
      if(!resp.ok){
        Fluttertoast.showToast(
            msg: "Não foi possível alterar sua senha!",
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
            msg: "Senha Alterada com sucesso!",
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