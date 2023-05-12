import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:veple/models/user_model.dart';

abstract class IUserRepository {
  Future<void> login(UserModel user);
  Future<void> logout();
  Future<Database> initDB();
  Future<List<UserModel>>? getMe();
}

class UserRepository implements IUserRepository {
  const UserRepository._();
  static UserRepository instance = const UserRepository._();

  @override
  Future<Database> initDB() async {
    var database = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'user_database.db'),

      onCreate: (db, version) {
        // 데이터베이스에 CREATE TABLE 수행
        return db.execute(
          'CREATE TABLE user(id TEXT PRIMARY KEY ,email TEXT, password TEXT)',
        );
      },
      version: 1,
    );

    var db = await database;
    return db;
  }

  @override
  Future<void> login(UserModel user) async {
    var db = await initDB();

    await db.insert('user', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> logout() async {
    var db = await initDB();
    await db.delete('user');
  }

  @override
  Future<List<UserModel>>? getMe() async {
    var db = await initDB();
    List<Map<String, dynamic>> maps = await db.query('user');

    return maps.map((e) => UserModel.fromJson(e)).toList();
  }
}
