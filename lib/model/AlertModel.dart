import 'package:intl/intl.dart';

class AlertData {
  String title;
  String data;
  String text;
  String categoria;

  AlertData.data([this.title,this.data,this.text,this.categoria]) {
    // Set these rather than using the default value because Firebase returns
    // null if the value is not specified.
    this.title ??= 'Título';
    this.data ??= 'dd/MM/yyyy';
    this.text ??='text';
    this.categoria ??= 'Categoria do Evento';
  }

  AlertData.fromJson(Map<String, dynamic> json) {
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    title = json['title'];
    data = df.format(DateTime.parse(json['date']));
    text = json['texto'];
    categoria = json['category'];
  }
}