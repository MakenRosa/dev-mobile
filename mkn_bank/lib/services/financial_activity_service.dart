import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mkn_bank/models/financial_record.dart';
import 'package:mkn_bank/models/expense_category.dart';

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
        return FinancialRecord.fromJson(doc.data());
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

  Future<void> updateFinancialRecord(
      String recordId, FinancialRecord record) async {
    await _firestore
        .collection('financialRecords')
        .doc(recordId)
        .update(record.toJson());
  }

  Future<List<ExpenseCategory>> fetchCategories(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('categories')
          .where('accountId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              ExpenseCategory.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  Future<void> updateRecordsWithDeletedCategory(
      String userId, String categoryName) async {
    try {
      // Busca todos os registros que utilizam a categoria excluída
      QuerySnapshot querySnapshot = await _firestore
          .collection('financialRecords')
          .where('userIdentifier', isEqualTo: userId)
          .where('expenseCategory', isEqualTo: categoryName)
          .get();

      // Itera pelos registros e atualiza o campo 'expenseCategory'
      for (var doc in querySnapshot.docs) {
        await _firestore
            .collection('financialRecords')
            .doc(doc.id)
            .update({'expenseCategory': 'Sem Categoria'});
      }
    } catch (e) {
      throw Exception('Erro ao atualizar registros: $e');
    }
  }

  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    try {
      String categoryId =
          categoryData['id']; // Assumindo que 'id' está presente no mapa.
      await _firestore
          .collection('categories')
          .doc(categoryId)
          .set(categoryData);
    } catch (e) {
      throw Exception('Erro ao adicionar categoria: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }

  Future<void> updateCategoryNameAndRecords(String userId, String oldCategoryName, String newCategoryName) async {
  try {
    // Atualiza o nome da categoria na coleção de categorias
    QuerySnapshot categorySnapshot = await _firestore
        .collection('categories')
        .where('accountId', isEqualTo: userId)
        .where('name', isEqualTo: oldCategoryName)
        .get();

    if (categorySnapshot.docs.isNotEmpty) {
      await _firestore
          .collection('categories')
          .doc(categorySnapshot.docs.first.id)
          .update({'name': newCategoryName});
    } else {
      throw Exception('Categoria não encontrada');
    }

    // Atualiza o nome da categoria nos registros financeiros
    QuerySnapshot recordSnapshot = await _firestore
        .collection('financialRecords')
        .where('userIdentifier', isEqualTo: userId)
        .where('expenseCategory', isEqualTo: oldCategoryName)
        .get();

    for (var doc in recordSnapshot.docs) {
      await _firestore
          .collection('financialRecords')
          .doc(doc.id)
          .update({'expenseCategory': newCategoryName});
    }
  } catch (e) {
    throw Exception('Erro ao atualizar categoria e registros: $e');
  }
}

}
