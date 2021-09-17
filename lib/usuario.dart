class Usuario{
  String id;
  String name;
  String login;
  String senha;
  String message;
  String idempresa;
  String empresa;
  bool pmElastic;
  bool pmZabbix;
  bool pmTickets;

  Usuario({this.id,this.name,this.login,this.senha,this.message,this.idempresa,this.empresa,this.pmElastic,this.pmZabbix,this.pmTickets});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    login = json['login'];
    senha = json['password'];
    message = json['message'];
    idempresa = json['company_id'];
    //idempresa = json['enterprise']['id'];
    //empresa = json['enterprise']['name'];
    empresa = json['company_name'];
    pmElastic = json['pmElastic'];
    pmZabbix = json['pmZabbix'];
    pmTickets = json['pmMoviedesk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['login'] = this.login;
    data['password'] = this.senha;
    data['message'] = this.message;
    data['company_id'] = this.idempresa;
    data['company_name'] = this.empresa;
    data['pm_elastic'] = this.pmElastic;
    data['pm_zabbix'] = this.pmZabbix;
    data['pm_tickets'] = this.pmTickets;
    return data;
  }

  String toString(){
    return this.id.toString()+"|"+this.name+"|"+this.login;
  }
}