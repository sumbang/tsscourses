import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
//import 'dart:io' as io;
//import 'package:path/path.dart' as p;

class SqlLiteService {
  String dBName = 'tss_data.db';
  int dBVersion = 1;

  // Singleton pattern
  static final SqlLiteService _databaseService = SqlLiteService._internal();
  factory SqlLiteService() => _databaseService;
  SqlLiteService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    // Remplacer par getDB1 pour windows
    Database db = await _getDB();

    return db;
  }

  Future<Database> _getDB() async{
    final path = await _getPath(); // Get a location using getDatabasesPath

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: dBVersion,
      //onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  /*Future<Database> _getDB1() async {
    // Initialisation pour les applications de bureau
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", dBName);
    var db = await databaseFactory.openDatabase(
      dbPath,
    );

    await _onCreate(db, dBVersion);

    return db;
  } */

  // create tables
  Future<void> _onCreate(Database db, int version) async {
     await db.execute(
            'CREATE TABLE Download(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, titre TEXT, description TEXT, categorie INTEGER, taskid TEXT, lien TEXT, filename TEXT, statut INTEGER, movie INTEGER)', 
          );
  }

  Future<String> _getPath() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dBName);
    return path;
  }

}