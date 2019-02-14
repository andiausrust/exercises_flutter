import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../model/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db;
  NewsDbProvider(){
    init();
  }

  void init() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final path = join(dbDir.path, "items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, version) {
        newDb.execute("""
          create table Items (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
      }
    );
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final map = await db.query(
      'Items',
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if (map.length > 0) {
      return ItemModel.fromDb(map.first);
    }
    return null;
  }

  @override
  Future<int> addItem(ItemModel item) {
    return db.insert('Items', item.toMap());
  }

  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }
}

final NewsDbProvider newsDbProvider = NewsDbProvider();