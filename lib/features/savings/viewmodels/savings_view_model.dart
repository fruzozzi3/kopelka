import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../data/models/saving_entry.dart';
import '../data/repository/savings_repository.dart';

class SavingsViewModel extends ChangeNotifier {
  final SavingsRepository _repo;
  SavingsViewModel(this._repo);

  int _goal = 0;
  int _current = 0;
  List<SavingEntry> _entries = [];

  int get goal => _goal;
  int get current => _current;
  List<SavingEntry> get entries => _entries;
  double get progress => _goal <= 0 ? 0.0 : (_current / _goal).clamp(0.0, 1.0);
  int get remaining => (_goal - _current).clamp(0, 1 << 31);

  String get formattedCurrent => _formatMoney(_current);
  String get formattedGoal => _formatMoney(_goal);
  String get formattedRemaining => _formatMoney(remaining);

  String _formatMoney(int amount) {
    final f = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);
    return f.format(amount);
  }

  Future<void> init() async {
    _goal = await _repo.getGoal();
    _current = await _repo.getCurrentSum();
    _entries = await _repo.getEntries();
    notifyListeners();
  }

  Future<void> setGoal(int amount) async {
    _goal = amount;
    await _repo.setGoal(amount);
    notifyListeners();
  }

  Future<void> add(int amount) async {
    await _repo.addEntry(amount);
    _current += amount;
    _entries = await _repo.getEntries();
    notifyListeners();
  }

  Future<void> addCustom(int amount) async {
    await add(amount);
  }
}
