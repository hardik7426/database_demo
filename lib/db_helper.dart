import 'dart:async';

import 'package:database_demo/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Database? _db;

  Future<Database> getDb() async {
    if(_db != null) {
      return _db!;
    }

    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'database_demo.db');

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: onCreate,
    );
    return _db!;
  }

  Future<void> onCreate(Database db, int version) async {
      await db.execute('''
      CREATE TABLE contact_master (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        mobile TEXT
      )'''
      );

      // if you want to create new table
      // await db.execute('''
      // CREATE TABLE user_master (
      //
      // )
      // ''');
  }

  Future<int> insertRecord(String name, String mobile) async {
    final dbClient = await getDb();

    final val = {
      'name': name, // 'column_name':value
      'mobile': mobile,
    };

    return dbClient.insert('contact_master', val);
  }

  Future<List<ContactModel>> getRecords() async {
    final dbClient = await getDb();

    final cursor = await dbClient.rawQuery('SELECT * FROM contact_master');

    List<ContactModel> contactList = [];
    for(int i=0; i<cursor.length; i++) {
      int id = cursor[i]['id'] as int;
      String name = cursor[i]['name'].toString();
      String mobile = cursor[i]['mobile'].toString();

      ContactModel model = ContactModel(id, name, mobile);
      contactList.add(model);
    }

    return contactList;
  }

  Future<int> deleteRecord(int id) async {
    final dbClient = await getDb();

    return await dbClient.delete(
      'contact_master',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

}