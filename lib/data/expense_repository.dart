import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class ExpenseRepository {
  Future<Database>? _database;
  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async => openDatabase(
    p.join(await getDatabasesPath(), 'expenses.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE expenses ('
        'id INTEGER PRIMARY KEY, name TEXT NOT NULL, amount REAL NOT NULL, '
        'category TEXT NOT NULL, date TEXT NOT NULL)',
      );
      // Dữ liệu mẫu chỉ được thêm khi tạo database lần đầu.
      final samples = [
        Expense(
          id: 1,
          name: 'Ăn uống',
          amount: 150000,
          category: 'Sinh hoạt',
          date: DateTime(2026, 10, 29),
        ),
        Expense(
          id: 2,
          name: 'Di chuyển',
          amount: 50000,
          category: 'Đi lại',
          date: DateTime(2026, 10, 28),
        ),
        Expense(
          id: 3,
          name: 'Mua sách',
          amount: 200000,
          category: 'Học tập',
          date: DateTime(2026, 10, 27),
        ),
        Expense(
          id: 4,
          name: 'Mua sắm',
          amount: 1500000,
          category: 'Sinh hoạt',
          date: DateTime(2026, 10, 25),
        ),
        Expense(
          id: 5,
          name: 'Khám bệnh',
          amount: 3550000,
          category: 'Sức khỏe',
          date: DateTime(2026, 10, 22),
        ),
      ];
      for (final expense in samples) {
        await db.insert('expenses', expense.toMap());
      }
    },
  );

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final rows = await db.query('expenses', orderBy: 'date DESC, id DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
}
