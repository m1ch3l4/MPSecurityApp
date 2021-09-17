class DashboardData{
  int siem;
  int zabbix;
  int open;
  int close;
  int waiting;

  DashboardData.data([this.siem,this.zabbix,this.open,this.close,this.waiting]) {
    this.siem ??= 0;
    this.zabbix ??=0;
    this.open ??= 0;
    this.close ??= 0;
    this.waiting ??=0;
  }

  DashboardData.fromJson(Map<String, dynamic> json){
    siem = json['siem'];
    zabbix = json['zabbix'];
    open = json['open'];
    close = json['close'];
    waiting = json['waiting'];
  }
}