import 'package:intl/intl.dart';
class TechSupportData{
  String title;
  String data;
  String status;
  String id;
  String justify;

  TechSupportData.data([this.title,this.data,this.status,this.id,this.justify]) {
    // Set these rather than using the default value because Firebase returns
    // null if the value is not specified.
    this.title ??= 'Título';
    this.data ??= 'dd/MM/yyyy';
    this.status ??='status';
    this.id ??= 'id';
    this.justify ??='';
  }

  TechSupportData.fromJson(Map<String, dynamic> json) {
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    title = json['titulo'];
    data = df.format(DateTime.parse(json['dtUpdate']));
    status = json['status'];
    id = json['internalId'].toString();
    justify = json['justifyStatus'];
  }
}