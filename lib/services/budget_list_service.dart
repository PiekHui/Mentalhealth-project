import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetListService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Save expense to Firebase
  Future<void> saveExpense(Map<String, dynamic> expense) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('expenses')
        .add({...expense, 'createdAt': FieldValue.serverTimestamp()});
  }

  // Save income to Firebase
  Future<void> saveIncome(Map<String, dynamic> income) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(_userId).collection('incomes').add(
      {...income, 'createdAt': FieldValue.serverTimestamp()},
    );
  }

  // Load expenses for current period
  Future<List<Map<String, dynamic>>> loadExpenses(bool isMonthly) async {
    if (_userId == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final startDate =
        isMonthly
            ? DateTime(now.year, now.month, 1)
            : now.subtract(Duration(days: now.weekday - 1));

    final snapshot =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('expenses')
            .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  // Load expenses for a specific month
  Future<List<Map<String, dynamic>>> loadExpensesForMonth(
    DateTime month,
  ) async {
    if (_userId == null) throw Exception('User not authenticated');

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final snapshot =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('expenses')
            .where(
              'date',
              isGreaterThanOrEqualTo: startOfMonth.toIso8601String(),
            )
            .where('date', isLessThanOrEqualTo: endOfMonth.toIso8601String())
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  // Load incomes for a specific month
  Future<List<Map<String, dynamic>>> loadIncomesForMonth(DateTime month) async {
    if (_userId == null) throw Exception('User not authenticated');

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final snapshot =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('incomes')
            .where(
              'date',
              isGreaterThanOrEqualTo: startOfMonth.toIso8601String(),
            )
            .where('date', isLessThanOrEqualTo: endOfMonth.toIso8601String())
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  // Delete expense
  Future<void> deleteExpense(String expenseId) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }

  // Delete income
  Future<void> deleteIncome(String incomeId) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('incomes')
        .doc(incomeId)
        .delete();
  }

  // Archive old expenses and reset for new period
  Future<void> archiveOldExpenses(DateTime beforeDate) async {
    if (_userId == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();
    final oldExpenses =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('expenses')
            .where('date', isLessThan: beforeDate.toIso8601String())
            .get();

    for (var doc in oldExpenses.docs) {
      // Move to archive
      batch.set(
        _firestore
            .collection('users')
            .doc(_userId)
            .collection('expenses_archive')
            .doc(doc.id),
        doc.data(),
      );
      // Delete from active expenses
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // Archive old incomes and reset for new period
  Future<void> archiveOldIncomes(DateTime beforeDate) async {
    if (_userId == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();
    final oldIncomes =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('incomes')
            .where('date', isLessThan: beforeDate.toIso8601String())
            .get();

    for (var doc in oldIncomes.docs) {
      batch.set(
        _firestore
            .collection('users')
            .doc(_userId)
            .collection('incomes_archive')
            .doc(doc.id),
        doc.data(),
      );
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // Save monthly budget to Firebase
  Future<void> saveBudget(double amount) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(_userId).set({
      'monthlyBudget': amount,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Load monthly budget from Firebase
  Future<double> loadBudget() async {
    if (_userId == null) throw Exception('User not authenticated');

    final doc = await _firestore.collection('users').doc(_userId).get();

    return doc.data()?['monthlyBudget']?.toDouble() ?? 0.0;
  }

  // Load monthly budget for specific month
  Future<double> loadBudgetForMonth(DateTime month) async {
    if (_userId == null) throw Exception('User not authenticated');

    final doc =
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('monthly_budgets')
            .doc('${month.year}-${month.month.toString().padLeft(2, '0')}')
            .get();

    if (doc.exists) {
      return doc.data()?['amount']?.toDouble() ?? 0.0;
    }

    // Fallback to current budget if no historical budget found
    final currentBudget = await loadBudget();
    return currentBudget;
  }
}
