import 'package:hive_flutter/adapters.dart';
import 'package:object_detection/models/picture.dart';

class Boxes {
  static Box<Picture> getPictures() => Hive.box<Picture>('pictures');
}
