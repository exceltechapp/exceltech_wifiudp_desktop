class SetConfigModel {
  String? device_name;

  dynamic? model;
  dynamic? model_name;
  dynamic? rtc;
  dynamic? SSID;
  dynamic? PASSWORD;

  int? index;

  SetConfigModel(this.device_name, this.model, this.model_name,this.rtc,this.index,this.SSID,this.PASSWORD);

  Map<String, dynamic> toJsonDevice() {
    return {
      "DeviceName": device_name,
      "Model": model,
      "Model_Name": model_name,
      "RTC": rtc,
      "Index":index,
      "SSID":SSID,
      "PASS":PASSWORD
    };
  }
}
