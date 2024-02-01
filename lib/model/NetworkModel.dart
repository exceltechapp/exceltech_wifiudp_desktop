class NetworkModel{
  String? Name;
  String? IwIP;
  NetworkModel(this.IwIP,this.Name);
  Map<String, dynamic> mapModel() {
    return {'IwIP': IwIP, 'name': Name};
  }
}