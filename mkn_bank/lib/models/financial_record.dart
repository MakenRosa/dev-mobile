import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialRecord {
  String recordTitle;
  DateTime recordDate;
  double transactionAmount;
  String expenseCategory;
  String userIdentifier;
  String description; 

  FinancialRecord({
    required this.recordTitle,
    required this.recordDate,
    required this.transactionAmount,
    required this.expenseCategory,
    required this.userIdentifier,
    this.description = '',
  });

  factory FinancialRecord.fromJson(Map<String, dynamic> json) {
    return FinancialRecord(
      recordTitle: json['recordTitle'],
      recordDate: (json['recordDate'] as Timestamp).toDate(), 
      transactionAmount: (json['transactionAmount'] as num).toDouble(), 
      expenseCategory: json['expenseCategory'],
      userIdentifier: json['userIdentifier'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recordTitle': recordTitle,
      'recordDate': Timestamp.fromDate(recordDate), 
      'transactionAmount': transactionAmount,
      'expenseCategory': expenseCategory,
      'userIdentifier': userIdentifier,
      'description': description,
    };
  }
}
