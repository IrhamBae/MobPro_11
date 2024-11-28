import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'users.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        print("Database and table created");
      },
    );
  }

  static Future<int> addUser(String name) async {
    final db = await DBHelper.db();
    final data = {'name': name};
    return await db.insert('user', data);
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DBHelper.db();
    return db.query('user');
  }

  static Future<void> deleteUser(int id) async {
    final db = await DBHelper.db();
    try {
      await db.delete(
        'user',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  static Future<void> resetTable() async {
    final db = await DBHelper.db();
    try {
      await db.delete('user');
      await db.rawQuery("DELETE FROM sqlite_sequence WHERE name='user'");
    } catch (e) {
      print("Error resetting table: $e");
    }
  }
}
