import 'package:sqflite/sqflite.dart';
import '../../../../core/db/app_database.dart';
import '../models/saving_entry.dart';

class SavingsRepository {
  Future<int> getGoal() async {
    final db = await AppDatabase().database;
    final res = await db.query('goal', where: 'id = 1');
    if (res.isEmpty) {
      await db.insert('goal', {'id': 1, 'amount': 0});
      return 0;
    }
    return res.first['amount'] as int;
  }

  Future<void> setGoal(int amount) async {
    final db = await AppDatabase().database;
    await db.update('goal', {'amount': amount}, where: 'id = 1');
  }

  Future<int> getCurrentSum() async {
    final db = await AppDatabase().database;
    final res = await db.rawQuery('SELECT SUM(amount) as total FROM entries');
    final value = res.first['total'] as int?;
    return value ?? 0;
    }

  Future<List<SavingEntry>> getEntries() async {
    final db = await AppDatabase().database;
    final res = await db.query('entries', orderBy: 'created_at DESC');
    return res.map((e) => SavingEntry.fromMap(e)).toList();
  }

  Future<void> addEntry(int amount) async {
    final db = await AppDatabase().database;
    await db.insert('entries', {
      'amount': amount,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> clearAll() async {
    final db = await AppDatabase().database;
    await db.delete('entries');
  }
}
