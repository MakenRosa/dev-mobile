import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mkn_bank/models/financial_record.dart';

class FinancialActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFinancialRecord(FinancialRecord record) async {
    await _firestore.collection('financialRecords').add(record.toJson());
  }

  Future<void> deleteFinancialRecord(String recordId) async {
    await _firestore.collection('financialRecords').doc(recordId).delete();
  }

  Stream<List<FinancialRecord>> getFinancialRecordsStream(String userId) {
    return _firestore
        .collection('financialRecords')
        .where('userIdentifier', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FinancialRecord.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<List<FinancialRecord>> getFinancialRecords(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('financialRecords')
        .where('userIdentifier', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      return FinancialRecord.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> updateFinancialRecord(String recordId, FinancialRecord record) async {
    await _firestore.collection('financialRecords').doc(recordId).update(record.toJson());
  }
}
