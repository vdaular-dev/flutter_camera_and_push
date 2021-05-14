import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

final tableImage = 'image';
final columnId = 'id';
final columnImage = 'image';
final columnTimestamp = 'timestamp';

class ImageRecord {
  int id;
  Uint8List image;
  DateTime timestamp;

  ImageRecord.fromMap(Map<String, Object?> map) :
        id = map[columnId] as int,
        timestamp = DateTime.parse(map[columnTimestamp] as String),
        image = map[columnImage] as Uint8List;
}

class ImageDBProvider extends ChangeNotifier {
  static late Database _db;

  static open() async {
    _db = await openDatabase('image.db', version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableImage ( 
  $columnId integer primary key autoincrement, 
  $columnImage blob not null,
  $columnTimestamp string not null)
''');
        });
  }

  Future<void> insert(Uint8List imageData) async {
    await _db.insert(tableImage, <String, Object?>{
      columnImage: imageData,
      columnTimestamp: DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  Future<ImageRecord?> get(int id) async {
    var maps = await _db.query(tableImage,
        columns: [columnId, columnImage, columnTimestamp],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ImageRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ImageRecord>> getAll() async {
    var maps = await _db.query(tableImage, columns: [columnId, columnImage, columnTimestamp]);
    if (maps.length > 0) {
      return maps.ImageRecord.fromMap(maps.first);
    }
    return [];
  }

  Future<int> count() async {
    var maps = await _db.query(tableImage, columns: ['count($columnId) as count']);
    if (maps.length > 0)
      return maps.first['count'] as int;

    return 0;
  }
}
