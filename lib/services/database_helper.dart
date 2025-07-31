import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:safeeats/models/scan_result.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'safeeats.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productName TEXT NOT NULL,
        brand TEXT,
        imageUrl TEXT,
        barcode TEXT,
        ingredients TEXT NOT NULL,
        allergens TEXT NOT NULL,
        allergiesDetected TEXT NOT NULL,
        scanType TEXT NOT NULL,
        scannedAt INTEGER NOT NULL
      )
    ''');
  }

  // Insert a new scan result
  Future<int> insertScanResult(ScanResult scanResult) async {
    final db = await database;
    return await db.insert(
      'scan_results',
      scanResult.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all scan results, ordered by most recent first
  Future<List<ScanResult>> getAllScanResults() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      orderBy: 'scannedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return ScanResult.fromMap(maps[i]);
    });
  }

  // Get scan results by scan type
  Future<List<ScanResult>> getScanResultsByType(String scanType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      where: 'scanType = ?',
      whereArgs: [scanType],
      orderBy: 'scannedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return ScanResult.fromMap(maps[i]);
    });
  }

  // Delete a scan result
  Future<void> deleteScanResult(int id) async {
    final db = await database;
    await db.delete(
      'scan_results',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all scan results
  Future<void> clearAllScanResults() async {
    final db = await database;
    await db.delete('scan_results');
  }

  // Get scan result by ID
  Future<ScanResult?> getScanResultById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ScanResult.fromMap(maps.first);
    }
    return null;
  }

  // Get scan results by date range
  Future<List<ScanResult>> getScanResultsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      where: 'scannedAt BETWEEN ? AND ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'scannedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return ScanResult.fromMap(maps[i]);
    });
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
