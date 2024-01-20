class deviceConfigModel {
  String? name;
  int? model;
  int? index;

  deviceConfigModel(this.name, this.model,this.index);

  Map<String, dynamic> toJsonDevice() {
    return {"name": name, "model": model,"ID":index};
  }
}
