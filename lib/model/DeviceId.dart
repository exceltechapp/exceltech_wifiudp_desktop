class DeviceId {
  var DeviceName;
  var DeviceMac;
  var Size;

  DeviceId(this.DeviceName, this.DeviceMac,this.Size);

  Map<String, dynamic> mapModel() {
    return {'DeviceMac': DeviceMac, 'DeviceName': DeviceName,'Size':Size};
  }
}
