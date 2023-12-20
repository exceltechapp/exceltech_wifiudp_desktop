class DeviceJson {
  int? ID;
  int? MODEL;
  int? TH;
  int? IR;
  int? IY;
  int? IB;
  int? VRN;
  int? VYN;
  int? VBN;
  int? VRY;
  int? VYB;
  int? VBR;
  int? IE;
  int? PF;
  int? KW;
  int? KWH;
  int? KVA;
  int? KVAH;
  int? KVAR;
  int? KVARH;
  int? HZ;
  int? STATUS;
  int? OLSV;
  int? ERROR;
  DateTime? RTC;
  String? MAC;
  String? DEN;
  String? IDN;
  int? SIZE;

  DeviceJson({
    this.ID,
    this.MODEL,
    this.TH,
    this.IR,
    this.IY,
    this.IB,
    this.VRN,
    this.VYN,
    this.VBN,
    this.VRY,
    this.VYB,
    this.VBR,
    this.IE,
    this.PF,
    this.KW,
    this.KWH,
    this.KVA,
    this.KVAH,
    this.KVAR,
    this.KVARH,
    this.HZ,
    this.STATUS,
    this.OLSV,
    this.ERROR,
    this.RTC,
    this.MAC,
    this.DEN,
    this.IDN,
    this.SIZE,
  });

  factory DeviceJson.fromJson(Map<String, dynamic> json) {
    return DeviceJson(
      ID: json['ID'],
      MODEL: json['MODEL'],
      TH: json['TH'],
      IR: json['IR'],
      IY: json['IY'],
      IB: json['IB'],
      VRN: json['VRN'],
      VYN: json['VYN'],
      VBN: json['VBN'],
      VRY: json['VRY'],
      VYB: json['VYB'],
      VBR: json['VBR'],
      IE: json['IE'],
      PF: json['PF'],
      KW: json['KW'],
      KWH: json['KWH'],
      KVA: json['KVA'],
      KVAH: json['KVAH'],
      KVAR: json['KVAR'],
      KVARH: json['KVARH'],
      HZ: json['HZ'],
      STATUS: json['STATUS'],
      OLSV: json['OLSV'],
      ERROR: json['ERROR'],
      RTC: json['RTC'] != null ? DateTime.parse(json['RTC']) : null,
      MAC: json['MAC'],
      DEN: json['DEN'],
      IDN: json['IDN'],
      SIZE: json['SIZE'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': ID,
      'MODEL': MODEL,
      'TH': TH,
      'IR': IR,
      'IY': IY,
      'IB': IB,
      'VRN': VRN,
      'VYN': VYN,
      'VBN': VBN,
      'VRY': VRY,
      'VYB': VYB,
      'VBR': VBR,
      'IE': IE,
      'PF': PF,
      'KW': KW,
      'KWH': KWH,
      'KVA': KVA,
      'KVAH': KVAH,
      'KVAR': KVAR,
      'KVARH': KVARH,
      'HZ': HZ,
      'STATUS': STATUS,
      'OLSV': OLSV,
      'ERROR': ERROR,
      'RTC': RTC?.toIso8601String(),
      'MAC': MAC,
      'DEN': DEN,
      'IDN':IDN,
      'SIZE': SIZE,
    };
  }
}
