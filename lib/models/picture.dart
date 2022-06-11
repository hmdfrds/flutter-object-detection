import 'package:hive/hive.dart';
part 'picture.g.dart';

@HiveType(typeId: 0)
class Picture extends HiveObject{
  @HiveField(0)
  late String path;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late double confidence;
}
