import 'package:e_commerce_app/models/cart_item_local.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDatabaseService {
  static final CartDatabaseService _instance = CartDatabaseService._internal();
  factory CartDatabaseService() => _instance;
  CartDatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId TEXT NOT NULL UNIQUE,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            image TEXT,
            quantity INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
  }

  Future<void> addToCart(CartItemLocal item) async {
    final db = await database;

    await db.insert(
      'cart_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
   }

  Future<void> addOrUpdateCartItem(CartItemLocal item) async {
    final db = await database;
    final existing = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [item.productId],
    );
    if (existing.isNotEmpty) {
      final oldQty = (existing.first['quantity'] as int?) ?? 0;
      await db.update(
        'cart_items',
        {'quantity': oldQty + item.quantity},
        where: 'productId = ?',
        whereArgs: [item.productId],
      );
    } else {
      await db.insert('cart_items', item.toMap());
    }
  }

  Future<List<CartItemLocal>> getCartItems() async {
    final db = await database;
    final maps = await db.query('cart_items');
    return maps.map((map) => CartItemLocal.fromMap(map)).toList();
  }

  // تحديث الكمية
  Future<void> updateQuantity(int itemId, int newQuantity) async {
    final db = await database;
    if (newQuantity <= 0) {
      await db.delete('cart_items', where: 'id = ?', whereArgs: [itemId]);
    } else {
      await db.update(
        'cart_items',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [itemId],
      );
    }
  }

  Future<void> removeItem(int itemId) async {
    final db = await database;
    await db.delete('cart_items', where: 'id = ?', whereArgs: [itemId]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }
}