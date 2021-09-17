import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:security_app/model/NoticiaModel.dart';
import 'package:http/http.dart' as http;
import 'package:security_app/utils/FirebaseMessagingHandle.dart';
import 'package:security_app/utils/HexColor.dart';
import 'package:security_app/utils/ListViewMenu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

void main() => runApp(new Newspapper());

class Newspapper extends StatelessWidget {

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
              home: new NewsPage(title: 'Notícias de E-Seg', user: snapshot.data),
            ) : CircularProgressIndicator());
        },
      ),
    );
  }
}

class NewsPage extends StatefulWidget {
  NewsPage({Key key, this.title,this.user}) : super(key: key);

  final String title;
  final Map<String, dynamic> user;

  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var firebaseFCM;
  List<NoticiaData> listModel = [];
  var loading=false;

  Future<Null> getData() async{
    setState(() {
      loading = true;
    });

    String urlApi = Constants.urlEndpoint+"news/last";
    print("****URL API: ");
    print(urlApi);
    print("**********");

    final responseData = await http.get(Uri.parse(urlApi));    if(responseData.statusCode == 200){
      String source = Utf8Decoder().convert(responseData.bodyBytes);
      final data = jsonDecode(source);
      setState(() {
        for(Map i in data){
          listModel.add(NoticiaData.fromJson(i));
        }
        loading = false;
      });
    }
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    firebaseFCM = new FCMHandle(widget.user,"news", context);

    return new Scaffold(
      appBar: AppBar(title: Text(widget.title),
          backgroundColor: HexColor(Constants.red)
      ),
      drawer: Drawer(
        child: ListViewMenu('news',widget.user,textTheme),
      ),
      body:  Container(
        padding: EdgeInsets.fromLTRB(10,10,10,0),
        width: double.maxFinite,
        child: loading ? Center (child: CircularProgressIndicator()) : ListView(
          children: getChildren()
        ),
      ),
    );
  }
  List<Widget> getChildren(){
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    final DateTime now = DateTime.now();
    final String formatada = df.format(now);
    List<Widget> lista = List<Widget>();
    if(listModel.length>0){
      for (int i = 0; i < listModel.length; i++)
        lista.add(getNoticia(listModel[i].titulo, listModel[i].data, listModel[i].texto,listModel[i].url));
    }else{
      lista.add(getNoticia("Sem Notícias", formatada, "Nenhuma notícia cadastrada",""));
    }

    return lista;
  }
  Widget getNoticia(String title, String date, String text, String url){
    return Card(
        child: Column(
          children: [
            ListTile(
                title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(date),
                leading: Icon(
                    Icons.book_outlined,
                    color: HexColor(Constants.red)
                )),
            Divider(),
            ListTile(
              title: Text(text),
            ),
            ListTile(
              title: Text((url!=""?"Leia Mais":""),style: TextStyle(fontSize: 12.0)),
                onTap: (){
                  _launchURL(url);
                }
            )
          ],
        )
    );
  }
  void _launchURL(_url) async =>
      await canLaunch(Uri.encodeFull(_url)) ? await launch(Uri.encodeFull(_url)) : throw 'Could not launch $_url';

}