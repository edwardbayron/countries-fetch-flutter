import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vool_test_project/models/CountryDataModel.dart';

import 'CountryDatabaseModel.dart';

class DB {
  static final DB instance = DB._internal();

  static Database? _database;

  DB._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/countries_database.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE countries(id INTEGER, capital TEXT, pngFlag TEXT, countryName TEXT, carSigns TEXT ARRAY, carDrivingSide TEXT, languages TEXT, nativeNames TEXT)
      ''');
  }

  Future<CountryModel> create(CountryModel country) async {
    final db = await instance.database;
    final capital = await db.insert('countries', country.toJson());
    return country.copy(capital: capital.toString());
  }

  Future<int> update(CountryModel country) async {
    final db = await instance.database;
    return db.update(
      'countries',
      country.toJson(),
      where: '${country.capital} = ?',
      whereArgs: [country.capital],
    );
  }

  Future<List<CountryDatabaseModel>> readAll() async {
    final db = await instance.database;
    final result = await db.query('countries');
    return result.map((json) => CountryDatabaseModel.fromJsonDb(json)).toList();
  }

  Future<int> delete(String capital) async {
    final db = await instance.database;
    return await db.delete(
      'countries',
      where: 'capital = ?',
      whereArgs: [capital],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}