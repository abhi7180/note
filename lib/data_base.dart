import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class data_base
{
  Future<Database>createDatabase()
  async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT , subtitle TEXT)');
        });
    return database;

  }
}