class ExpenseCategory {
  String id;
  String name;
  String? accountId;

  ExpenseCategory({required this.id, required this.name, this.accountId});

  factory ExpenseCategory.fromFirestore(Map<String, dynamic> firestore) {
    return ExpenseCategory(
      id: firestore['id'] as String,
      name: firestore['name'] as String,
      accountId: firestore['accountId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'accountId': accountId, 
    };
  }

    @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    return other is ExpenseCategory && other.id == id && other.name == name;
  }

    @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
