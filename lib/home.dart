import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:security_app/model/DashboardModel.dart';
import 'package:security_app/utils/FirebaseMessagingHandle.dart';
import 'package:security_app/utils/HexColor.dart';
import 'package:security_app/utils/ListViewMenu.dart';
import 'package:security_app/utils/OptionsSearch.dart';

import 'constants.dart';
import 'model/Idbean.dart';
import 'model/NoticiaModel.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new Home());

class Home extends StatelessWidget {

  static const routeName = '/dashboard';
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
            home: new MyHomePage(title: 'MaxProtection E-Seg', user: snapshot.data),
          ) : CircularProgressIndicator());
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.user}) : super(key: key);

  final String title;
  final Map<String, dynamic> user;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NoticiaData> listModel = [];
  DashboardData dashboard;
  var loading=false;
  int totalSiem = 0;
  int totalAberto = 10;
  int totalFechado = 20;
  Idbean selected = OptionsSearch.defaultOpt;
  var firebaseFCM;

  Future<Null> getDashboardData() async{
    setState(() {
      loading = true;
    });

    String urlApi = Constants.urlEndpoint+"dashboard/"+widget.user['company_id'].toString()+"/"+widget.user['id'].toString()+"/"+selected.number.toString();
    print("****URL API: ");
    print(urlApi);
    print("**********");

    final responseData = await http.get(Uri.parse(urlApi));    if(responseData.statusCode == 200){
      String source = Utf8Decoder().convert(responseData.bodyBytes);
      final data = jsonDecode(source);
      setState(() {
        dashboard = DashboardData.fromJson(data);
        for(Map i in data['infoNewsList']){
          listModel.add(NoticiaData.fromJson(i));
        }
        loading = false;
      });
    }
  }

  void initState() {
    getDashboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    firebaseFCM = new FCMHandle(widget.user,"home",context);
    Widget optionsToShow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton<Idbean>(
            value: selected,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: HexColor(Constants.red)),
            underline: Container(
              height: 2,
              color: HexColor(Constants.blue),
            ),
            onChanged: (Idbean newValue) {
              setState(() {
                selected = newValue;
                listModel = [];
                getDashboardData();
              });
            },
            items: OptionsSearch.lstOptions.map((Idbean bean) {
              return  DropdownMenuItem<Idbean>(
                  value: bean,
                  child: Text(bean.text));}).toList(),
          )
        ],
      );
    }

    return new Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(
              color: HexColor(Constants.blue), //change your color here
            ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          //elevation: 2.0,
          backgroundColor: Colors.white,
          //title: Text("Dashboard", style: TextStyle(color:HexColor(Constants.black), fontWeight: FontWeight.w200, fontSize: 15.0)),
          actions: <Widget>
          [
            Container
              (
              margin: EdgeInsets.only(right: 6.0),
              child: Row
                (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  //Text('maxprotection.com.br', style: TextStyle(color: HexColor(Constants.red), fontWeight: FontWeight.w700, fontSize: 14.0)),
                  optionsToShow()
                ],
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListViewMenu('home',widget.user,textTheme),
        ),
        body: loading ? Center (child: CircularProgressIndicator()) : getMain()

    );
  }

  Widget getMain(){
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        _buildTile(
          Padding
            (
            padding: const EdgeInsets.all(24.0),
            child: Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Column
                    (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text('Alertas Zabbix', style: TextStyle(color: HexColor(Constants.blue))),
                      Text(dashboard.zabbix.toString(), style: TextStyle(color: HexColor(Constants.black), fontWeight: FontWeight.w700, fontSize: 30.0)),
                      Text(selected.text,style:TextStyle(color:HexColor(Constants.red), fontSize: 14))
                    ],
                  ),
                  Material
                    (
                      color: HexColor(Constants.blue),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center
                        (
                          child: Padding
                            (
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.warning, color: Colors.white, size: 24.0),
                          )
                      )
                  )
                ]
            ),
          ),
        ),
        _buildTile(
          Padding
            (
            padding: const EdgeInsets.all(24.0),
            child: Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>
                [
                  Column
                    (
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Text('Alertas SIEM', style: TextStyle(color: HexColor(Constants.blue))),
                      Text(dashboard.siem.toString(), style: TextStyle(color: HexColor(Constants.black), fontWeight: FontWeight.w700, fontSize: 30.0)),
                      Text(selected.text,style:TextStyle(color:HexColor(Constants.red), fontSize: 14))
                    ],
                  ),
                  Material
                    (
                      color: HexColor(Constants.blue),
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center
                        (
                          child: Padding
                            (
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.timeline, color: Colors.white, size: 24.0),
                          )
                      )
                  )
                ]
            ),
          ),
        ),
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                  Material(
                      color: HexColor(Constants.red),
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(Icons.live_help, color: Colors.white, size: 24.0),
                      )
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Text(dashboard.waiting.toString(), style: TextStyle(color: HexColor(Constants.black), fontWeight: FontWeight.w700, fontSize: 20.0)),
                  Text('Chamados aguardando resposta', style: TextStyle(color: HexColor(Constants.blue))),
                ]
            ),
          ),
        ),
        _buildTile(
          Padding
            (
            padding: const EdgeInsets.all(24.0),
            child: Column
              (
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                  Material
                    (
                      color: HexColor(Constants.red),
                      shape: CircleBorder(),
                      child: Padding
                        (
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.support, color: Colors.white, size: 24.0),
                      )
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Text(dashboard.open.toString(), style: TextStyle(color: HexColor(Constants.black), fontWeight: FontWeight.w700, fontSize: 20.0)),
                  Text('Chamados em atendimento', style: TextStyle(color: HexColor(Constants.blue))),
                ]
            ),
          ),
        ),
        buildTileNoticia(),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 120.0),
        StaggeredTile.extent(2, 120.0),
        StaggeredTile.extent(1, 200.0),
        StaggeredTile.extent(1, 200.0),
        StaggeredTile.extent(2, 350.0)
      ],
    );
  }
  Widget getNoticia(String title, String date, String text, String url){
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
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
            Expanded(child:ListTile(
              title: Text(text),
            )),
            ListTile(
                title: Text("Leia Mais",style: TextStyle(fontSize: 12.0)),
                onTap: (){
                  _launchURL(url);
                }
            )
          ],
        )
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }

  Widget buildTileNoticia(){
   return Container(
       alignment: Alignment.topCenter,
       width: double.maxFinite,
       child: loading ? Center (child: CircularProgressIndicator()) : (listModel.length>0? getSwiper():Center(
    child: Text(
    "Nenhuma notícia atual",
      style: TextStyle(color: HexColor(Constants.red), fontWeight: FontWeight.w700, fontSize: 24.0),
    textAlign: TextAlign.center,
    ))));
  }
  Widget getSwiper(){
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return getNoticia(listModel[index].titulo, listModel[index].data, listModel[index].texto,listModel[index].url);
      },
      itemCount: listModel.length,
      itemWidth: 300.0,
      itemHeight: 450.0,
      layout: SwiperLayout.DEFAULT,
      control: new SwiperControl(),
    );
  }
  void _launchURL(_url) async =>
      await canLaunch(Uri.encodeFull(_url)) ? await launch(Uri.encodeFull(_url)) : throw 'Could not launch $_url';

}
