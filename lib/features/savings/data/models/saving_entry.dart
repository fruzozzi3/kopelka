class SavingEntry {
  final int? id;
  final int amount; // в копейках/центах? здесь храним в рублях как int
  final DateTime createdAt;

  SavingEntry({this.id, required this.amount, required this.createdAt});

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory SavingEntry.fromMap(Map<String, dynamic> map) => SavingEntry(
        id: map['id'] as int?,
        amount: map['amount'] as int,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );
}
