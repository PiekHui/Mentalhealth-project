import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:helloworld/services/budget_list_service.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetItem {
  final String? id; // Add id field
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome;

  BudgetItem({
    this.id, // Add id parameter
    required this.category,
    required this.amount,
    required this.date,
    this.isIncome = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, // Include id in toJson
    'category': category,
    'amount': amount,
    'date': date.toIso8601String(),
    'isIncome': isIncome,
  };

  // Update fromJson to include id
  factory BudgetItem.fromJson(Map<String, dynamic> json) => BudgetItem(
    id: json['id'],
    category: json['category'],
    amount: json['amount'].toDouble(),
    date: DateTime.parse(json['date']),
    isIncome: json['isIncome'] == true,
  );
}

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  final BudgetListService _budgetService = BudgetListService();
  final List<BudgetItem> _expenses = [];
  final List<BudgetItem> _incomes = [];
  double _monthlyBudget = 0;

  // Add new state variables
  DateTime _selectedMonth = DateTime.now();
  bool _isCurrentMonth = true;
  int _selectedIndex = 0;

  final List<String> _categories = [
    'Food',
    'Drinks',
    'Transport',
    'Clothing',
    'Medical',
    'Entertainment',
    'Education',
  ];

  final List<String> _incomeCategories = ['Salary', 'Part-time', 'Investment'];

  @override
  void initState() {
    super.initState();
    _loadBudget();
    _loadExpenses();
    _loadIncomes();
  }

  // Add month selection method
  void _selectMonth() async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = picked;
        _isCurrentMonth =
            _selectedMonth.month == DateTime.now().month &&
            _selectedMonth.year == DateTime.now().year;
      });
      _loadBudget();
      _loadExpenses();
      _loadIncomes();
    }
  }

  Future<void> _loadBudget() async {
    try {
      final budget = await _budgetService.loadBudgetForMonth(_selectedMonth);
      setState(() {
        _monthlyBudget = budget;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load budget: $e')));
    }
  }

  Future<void> _setBudget() async {
    final TextEditingController budgetController = TextEditingController();
    budgetController.text = _monthlyBudget.toString(); // Show current budget

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Set Monthly Budget', style: GoogleFonts.fredoka()),
            content: TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (RM)',
                labelStyle: GoogleFonts.fredoka(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.fredoka()),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final budget = double.tryParse(budgetController.text) ?? 0;
                    await _budgetService.saveBudget(budget);
                    setState(() => _monthlyBudget = budget);
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save budget: $e')),
                    );
                  }
                },
                child: Text('Save', style: GoogleFonts.fredoka()),
              ),
            ],
          ),
    );
  }

  // Removed old _addExpense - unified into _addTransaction

  Future<void> _saveExpense(BudgetItem expense) async {
    try {
      await _budgetService.saveExpense(expense.toJson());
      await _loadExpenses(); // Reload to get the id from Firebase
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save expense: $e')));
    }
  }

  Future<void> _loadExpenses() async {
    try {
      final expenseData = await _budgetService.loadExpensesForMonth(
        _selectedMonth,
      );
      setState(() {
        _expenses.clear();
        _expenses.addAll(
          expenseData.map((data) => BudgetItem.fromJson(data)).toList(),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load expenses: $e')));
    }
  }

  // Removed old _addIncome - unified into _addTransaction

  Future<void> _saveIncome(BudgetItem income) async {
    try {
      await _budgetService.saveIncome(income.toJson());
      await _loadIncomes();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save income: $e')));
    }
  }

  Future<void> _loadIncomes() async {
    try {
      final incomeData = await _budgetService.loadIncomesForMonth(
        _selectedMonth,
      );
      setState(() {
        _incomes.clear();
        _incomes.addAll(
          incomeData.map((data) {
            final item = BudgetItem.fromJson(data);
            return BudgetItem(
              id: item.id,
              category: item.category,
              amount: item.amount,
              date: item.date,
              isIncome: true,
            );
          }).toList(),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load incomes: $e')));
    }
  }

  // Removed unused _checkAndResetBudget

  double get _totalExpenses =>
      _expenses.fold(0, (sum, expense) => sum + expense.amount);

  double get _totalIncomes =>
      _incomes.fold(0, (sum, income) => sum + income.amount);

  List<List<BudgetItem>> _groupTransactionsByDay() {
    final List<BudgetItem> all = [..._expenses, ..._incomes];
    final Map<String, List<BudgetItem>> groups = {};
    for (var tx in all) {
      final key = DateFormat('yyyy-MM-dd').format(tx.date);
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(tx);
    }
    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedKeys.map((k) => groups[k]!).toList();
  }

  // Update the icon selection in the ListView.builder
  Widget _getCategoryIcon(String category) {
    IconData icon;
    Color iconColor;
    Color backgroundColor;

    switch (category) {
      case 'Salary':
        icon = Icons.payments;
        iconColor = Colors.teal;
        backgroundColor = Colors.teal.shade50;
        break;
      case 'Part-time':
        icon = Icons.work_history;
        iconColor = Colors.cyan;
        backgroundColor = Colors.cyan.shade50;
        break;
      case 'Investment':
        icon = Icons.trending_up;
        iconColor = Colors.lightGreen;
        backgroundColor = Colors.lightGreen.shade50;
        break;
      case 'Food':
        icon = Icons.fastfood;
        iconColor = Colors.orange;
        backgroundColor = Colors.orange.shade50;
        break;
      case 'Drinks':
        icon = Icons.local_drink;
        iconColor = Colors.blue;
        backgroundColor = Colors.blue.shade50;
        break;
      case 'Transport':
        icon = Icons.directions_bus;
        iconColor = Colors.green;
        backgroundColor = Colors.green.shade50;
        break;
      case 'Clothing':
        icon = Icons.shopping_bag;
        iconColor = Colors.purple;
        backgroundColor = Colors.purple.shade50;
        break;
      case 'Medical':
        icon = Icons.local_hospital;
        iconColor = Colors.red;
        backgroundColor = Colors.red.shade50;
        break;
      case 'Entertainment':
        icon = Icons.movie;
        iconColor = Colors.pink;
        backgroundColor = Colors.pink.shade50;
        break;
      case 'Education':
        icon = Icons.school;
        iconColor = Colors.indigo;
        backgroundColor = Colors.indigo.shade50;
        break;
      default:
        icon = Icons.category;
        iconColor = Colors.grey;
        backgroundColor = Colors.grey.shade50;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  // Removed unused _groupExpensesByDay (replaced by _groupTransactionsByDay)

  // Update the chart section in _buildChartView method
  Widget _buildChartView() {
    return Column(
      children: [
        // Add month selector at the top
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: TextButton(
            onPressed: _selectMonth,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM yyyy').format(_selectedMonth),
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Expenses by Category',
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200, // Reduced from 300
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PieChart(
              PieChartData(
                sections:
                    _expenses
                        .fold<Map<String, double>>({}, (map, expense) {
                          map[expense.category] =
                              (map[expense.category] ?? 0) + expense.amount;
                          return map;
                        })
                        .entries
                        .map((entry) {
                          final color = _getCategoryColor(entry.key);
                          return PieChartSectionData(
                            value: entry.value,
                            title:
                                '${((entry.value / _totalExpenses) * 100).toStringAsFixed(0)}%',
                            radius: 80, // Reduced from 100
                            titleStyle: GoogleFonts.fredoka(
                              fontSize: 12, // Reduced from 14
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors
                                      .black87, // Changed to dark color for better contrast
                            ),
                            color: color,
                          );
                        })
                        .toList(),
                sectionsSpace: 2, // Add small space between sections
                centerSpaceRadius: 30, // Add center space
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final amount = _expenses
                  .where((e) => e.category == category)
                  .fold(0.0, (sum, e) => sum + e.amount);
              final percentage =
                  _totalExpenses == 0 ? 0 : (amount / _totalExpenses * 100);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: _getCategoryIcon(category),
                  title: Text(
                    category,
                    style: GoogleFonts.fredoka(fontWeight: FontWeight.w500),
                  ),
                  trailing: Text(
                    'RM${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(0)}%)',
                    style: GoogleFonts.fredoka(
                      color: _getCategoryColor(category).withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Add this helper method for chart colors
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Salary':
        return Colors.teal.shade300;
      case 'Part-time':
        return Colors.cyan.shade300;
      case 'Investment':
        return Colors.lightGreen.shade300;
      case 'Food':
        return Colors.orange.shade300;
      case 'Drinks':
        return Colors.blue.shade300;
      case 'Transport':
        return Colors.green.shade300;
      case 'Clothing':
        return Colors.purple.shade300;
      case 'Medical':
        return Colors.red.shade300;
      case 'Entertainment':
        return Colors.pink.shade300;
      case 'Education':
        return Colors.indigo.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget Tracker',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
      ),
      body:
          _selectedIndex == 0
              ? Column(
                children: [
                  // Add calendar button container
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                    ), // Reduced from 6
                    // color: const Color.fromARGB(255, 197, 224, 246),
                    child: TextButton(
                      onPressed: _selectMonth,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMMM yyyy').format(_selectedMonth),
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2, // Reduced from 14
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 216, 216, 248),
                      // gradient: LinearGradient(
                      //   colors: [const Color.fromARGB(255, 187, 195, 251), const Color.fromARGB(255, 228, 227, 253)],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Monthly Budget: RM${_monthlyBudget.toStringAsFixed(2)}',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: _setBudget,
                              padding: const EdgeInsets.only(left: 8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value:
                              _monthlyBudget == 0
                                  ? 0
                                  : _totalExpenses / _monthlyBudget,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(
                            _totalExpenses > _monthlyBudget
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Expense: RM${_totalExpenses.toStringAsFixed(2)}',
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                color:
                                    _totalExpenses > _monthlyBudget
                                        ? Colors.red
                                        : Colors.green,
                              ),
                            ),
                            Text(
                              'Income: RM${_totalIncomes.toStringAsFixed(2)}',
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        _expenses.isEmpty && _incomes.isEmpty
                            ? Center(
                              child: Text(
                                'No records yet.\nTap + to add one.',
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom:
                                    80, // Add bottom padding to avoid FAB overlap
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap:
                                  true, // Add this to make the list take minimum space
                              itemCount: _groupTransactionsByDay().length,
                              itemBuilder: (context, index) {
                                final dayItems =
                                    _groupTransactionsByDay()[index];
                                final date = dayItems.first.date;
                                final dayIncome = dayItems
                                    .where((e) => e.isIncome)
                                    .fold(0.0, (s, e) => s + e.amount);
                                final dayExpense = dayItems
                                    .where((e) => !e.isIncome)
                                    .fold(0.0, (s, e) => s + e.amount);

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16, // Increased from 8
                                    vertical: 12, // Increased from 4
                                  ),
                                  elevation:
                                      4, // Added elevation for better separation
                                  shape: RoundedRectangleBorder(
                                    // Added rounded corners
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    237,
                                    247,
                                    255,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            200,
                                            229,
                                            253,
                                          ),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(4),
                                              ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat(
                                                'EEE, M/d',
                                              ).format(date),
                                              style: GoogleFonts.fredoka(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Income: RM${dayIncome.toStringAsFixed(2)}  •  Expense: RM${dayExpense.toStringAsFixed(2)}',
                                              style: GoogleFonts.fredoka(
                                                fontSize: 12,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...dayItems.map(
                                        (item) => ListTile(
                                          leading: _getCategoryIcon(
                                            item.category,
                                          ),
                                          title: Text(
                                            item.category,
                                            style: GoogleFonts.fredoka(),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${item.isIncome ? '+' : '-'}RM${item.amount.toStringAsFixed(2)}',
                                                style: GoogleFonts.fredoka(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      item.isIncome
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                              ),
                                              // const SizedBox(width: 2),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  size: 20,
                                                ),
                                                color: Colors.grey.shade700,
                                                onPressed:
                                                    () => _deleteTransaction(
                                                      item,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              )
              : _buildChartView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Chart'),
        ],
      ),
      floatingActionButton:
          _isCurrentMonth && _selectedIndex == 0
              ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FloatingActionButton(
                  onPressed: _addTransaction,
                  child: const Icon(Icons.add),
                ),
              )
              : null,
    );
  }
}

extension _AddTransaction on _BudgetListScreenState {
  Future<void> _addTransaction() async {
    bool addingIncome = false;
    String selectedCategory =
        addingIncome ? _incomeCategories.first : _categories.first;
    final amountController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setLocalState) => AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addingIncome ? 'Add Income' : 'Add Expense',
                        style: GoogleFonts.fredoka(),
                      ),
                      Switch(
                        value: addingIncome,
                        onChanged: (v) {
                          setLocalState(() {
                            addingIncome = v;
                            selectedCategory =
                                addingIncome
                                    ? _incomeCategories.first
                                    : _categories.first;
                          });
                        },
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount (RM)',
                          labelStyle: GoogleFonts.fredoka(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items:
                            (addingIncome ? _incomeCategories : _categories)
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c,
                                      style: GoogleFonts.fredoka(),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setLocalState(() => selectedCategory = value!),
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: GoogleFonts.fredoka(),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: GoogleFonts.fredoka()),
                    ),
                    TextButton(
                      onPressed: () async {
                        final amount =
                            double.tryParse(amountController.text) ?? 0;
                        if (addingIncome) {
                          final item = BudgetItem(
                            category: selectedCategory,
                            amount: amount,
                            date: DateTime.now(),
                            isIncome: true,
                          );
                          await _saveIncome(item);
                        } else {
                          final item = BudgetItem(
                            category: selectedCategory,
                            amount: amount,
                            date: DateTime.now(),
                            isIncome: false,
                          );
                          await _saveExpense(item);
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Text('Save', style: GoogleFonts.fredoka()),
                    ),
                  ],
                ),
          ),
    );
  }

  Future<void> _deleteTransaction(BudgetItem item) async {
    try {
      if (item.isIncome) {
        // find by matching fields; for robust deletes store and use doc ids
        final matches =
            _incomes
                .where(
                  (e) =>
                      e.date == item.date &&
                      e.amount == item.amount &&
                      e.category == item.category,
                )
                .toList();
        if (matches.isNotEmpty && matches.first.id != null) {
          await _budgetService.deleteIncome(matches.first.id!);
        } else {
          // fallback: reload incomes to capture ids and try matching again
          await _loadIncomes();
          final refreshed =
              _incomes
                  .where(
                    (e) =>
                        e.date == item.date &&
                        e.amount == item.amount &&
                        e.category == item.category,
                  )
                  .toList();
          if (refreshed.isNotEmpty && refreshed.first.id != null) {
            await _budgetService.deleteIncome(refreshed.first.id!);
          }
        }
        await _loadIncomes();
      } else {
        final matches =
            _expenses
                .where(
                  (e) =>
                      e.date == item.date &&
                      e.amount == item.amount &&
                      e.category == item.category,
                )
                .toList();
        if (matches.isNotEmpty && matches.first.id != null) {
          await _budgetService.deleteExpense(matches.first.id!);
        } else {
          await _loadExpenses();
          final refreshed =
              _expenses
                  .where(
                    (e) =>
                        e.date == item.date &&
                        e.amount == item.amount &&
                        e.category == item.category,
                  )
                  .toList();
          if (refreshed.isNotEmpty && refreshed.first.id != null) {
            await _budgetService.deleteExpense(refreshed.first.id!);
          }
        }
        await _loadExpenses();
      }
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Deleted successfully')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }
}
