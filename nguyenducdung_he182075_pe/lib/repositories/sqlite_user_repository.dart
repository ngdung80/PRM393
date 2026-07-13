import '../models/user.dart';
import 'database_helper.dart';
import 'user_repository.dart';

class SqliteUserRepository implements UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<UserModel>> getUsers() async {
    final db = await _dbHelper.database;
    final maps = await db.query('users', orderBy: 'id ASC');
    return maps.map((map) => UserModel.fromMap(map)).toList();
  }

  @override
  Future<void> addUser(UserModel user) async {
    final db = await _dbHelper.database;
    // Insert with the id already computed by the ViewModel (max+1 strategy)
    await db.insert('users', user.toMap());
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> deleteUser(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
