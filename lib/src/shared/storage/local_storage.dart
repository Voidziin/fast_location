import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String boxName = 'fast_location_history';

  Future<Box<dynamic>> get box async {
    if (Hive.isBoxOpen(boxName)) return Hive.box(boxName);
    return Hive.openBox(boxName);
  }

  Future<void> write(String key, dynamic value) async =>
      (await box).put(key, value);
  Future<dynamic> read(String key) async => (await box).get(key);
}
