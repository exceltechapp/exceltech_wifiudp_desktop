import 'package:hive/hive.dart';

part 'LogModel.g.dart';

@HiveType(typeId: 0)
class LogEntry extends HiveObject {
  @HiveField(0)
  String time;

  @HiveField(1)
  String data;

  LogEntry(this.time, this.data);
}