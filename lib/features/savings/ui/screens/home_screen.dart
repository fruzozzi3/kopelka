import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../theme/color.dart';
import '../../viewmodels/savings_view_model.dart';
import '../widgets/progress_card.dart';
import '../widgets/quick_add_row.dart';
import '../widgets/add_funds_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showSetGoalDialog(BuildContext context) {
    final vm = context.read<SavingsViewModel>();
    final controller = TextEditingController(text: vm.goal.toString());
    showDialog(
      context: context,
      builder: (context) {
        String? error;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Установить цель'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Сумма цели (₽)',
                  errorText: error,
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                FilledButton(
                  onPressed: () {
                    final value = int.tryParse(controller.text.trim());
                    if (value == null || value < 0) {
                      setState(() => error = 'Введите корректное число');
                      return;
                    }
                    vm.setGoal(value);
                    Navigator.pop(context);
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddFundsDialog());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SavingsViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя Копилка'),
        actions: [
          IconButton(
            tooltip: 'Установить цель',
            onPressed: () => _showSetGoalDialog(context),
            icon: const Icon(Icons.flag_rounded),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const ProgressCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              'Быстрое пополнение',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: QuickAddRow(),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              'История операций',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _HistoryList(),
          const SizedBox(height: 24),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: const Text('Пополнить'),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final DateFormat _df = DateFormat('dd.MM.yyyy HH:mm');
  _HistoryList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SavingsViewModel>();
    if (vm.entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text('Пока нет пополнений. Начни с быстрой кнопки или нажми "Пополнить".', style: TextStyle(color: kTextSecondary)),
      );
    }
    return ListView.builder(
      itemCount: vm.entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final e = vm.entries[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.savings_rounded)),
          title: Text('+${e.amount} ₽', style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(_df.format(e.createdAt)),
        );
      },
    );
  }
}
