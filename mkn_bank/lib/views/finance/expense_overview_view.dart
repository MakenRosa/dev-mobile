// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkn_bank/models/financial_record.dart';
import 'package:mkn_bank/models/account_profile.dart';
import 'package:mkn_bank/services/financial_activity_service.dart';

class ExpenseOverviewView extends StatefulWidget {
  final AccountProfile userProfile;
  const ExpenseOverviewView({super.key, required this.userProfile});

  @override
  _ExpenseOverviewViewState createState() => _ExpenseOverviewViewState();
}

class _ExpenseOverviewViewState extends State<ExpenseOverviewView> {
  final FinancialActivityService financialActivityService =
      FinancialActivityService();
  String _selectedFilterOption = 'Todas';
  String _selectedFilterCategory = 'Todas';
  String _selectedFilterPaymentMethod = 'Todos';
  double _finalBalance = 0.0;
  final bool _showRecentTransactions = true;
  final List<String> _categories = ['Todas'];

   @override
  void initState() {
    super.initState();
    financialActivityService.fetchCategories(widget.userProfile.accountId).then((categories) {
      setState(() {
        _categories.addAll(categories.map((c) => c.name));
      });
    });
  }


  double _calculateTotal(List<FinancialRecord> records) {
    return records.fold(0, (sum, item) => sum + item.transactionAmount);
  }

Stream<List<FinancialRecord>> getFinancialRecordsStream() {
  return financialActivityService
      .getFinancialRecordsStream(widget.userProfile.accountId)
      .map((records) {
    var filteredRecords = records.where((record) {
      bool dateFilter = _selectedFilterOption == 'Últimas 30 dias'
          ? record.recordDate
              .isAfter(DateTime.now().subtract(Duration(days: 30)))
          : true;
      bool categoryFilter = _selectedFilterCategory != 'Todas'
          ? record.expenseCategory == _selectedFilterCategory
          : true;
      bool paymentMethodFilter = _selectedFilterPaymentMethod != 'Todos'
          ? record.paymentMethod == _selectedFilterPaymentMethod
          : true;

      return dateFilter && categoryFilter && paymentMethodFilter;
    }).toList();



    _updateBalance(_calculateTotal(filteredRecords));

    return filteredRecords;
  });
}



  void _onFilterOptionChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedFilterOption = value;
      });
    }
  }

  void _onFilterCategoryChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedFilterCategory = value;
      });
    }
  }

  void _onFilterPaymentMethodChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedFilterPaymentMethod = value;
      });
    }
  }

  Widget _dropdownButtons() => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _dropdownButton('Filtrar por:', ['Todas', 'Últimas 30 dias'],
                  _selectedFilterOption, _onFilterOptionChanged),
            ],
          ),
          Row(
            children: <Widget>[
              _dropdownButton(
                  'Filtrar por Categoria:',
                  _categories,
                  _selectedFilterCategory,
                  _onFilterCategoryChanged),
              const Spacer(),
              _dropdownButton(
                  'Filtrar por Método de Pagamento:',
                  ['Todos', 'Cartão de Crédito', 'Cartão de Débito', 'Dinheiro', 'Pix'],
                  _selectedFilterPaymentMethod,
                  _onFilterPaymentMethodChanged),
            ],
          ),
        ],
      );

  Widget _dropdownButton(String label, List<String> options,
      String selectedOption, ValueChanged<String?> onSelected) {
    return DropdownButton<String>(
      value: selectedOption,
      onChanged: onSelected,
      items: options
          .map((option) => DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visão Geral de Despesas'),
      ),
      body: Column(
        children: <Widget>[
          _balanceCard(),
          _dropdownButtons(), 
          _expensesList(),
        ],
      ),
    );
  }

  Widget _balanceCard() => Container(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text('Saldo', style: TextStyle(fontSize: 20.0)),
                const SizedBox(height: 10.0),
                Text(
                  NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                      .format(_finalBalance),
                  style: TextStyle(
                    color: _finalBalance < 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _filterButton(String label, bool selected, VoidCallback onTap) =>
      TextButton(
        onPressed: onTap,
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.blue : Colors.grey, fontSize: 18)),
      );

  Widget _expensesList() => Expanded(
        child: StreamBuilder<List<FinancialRecord>>(
          stream: getFinancialRecordsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Ocorreu um erro'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              _updateBalance(0.0);
              return const Center(child: Text('Nenhuma despesa encontrada'));
            }

            List<FinancialRecord> records = snapshot.data!;
            records.sort((a, b) => b.recordDate.compareTo(a.recordDate));
            _updateBalance(_calculateTotal(records));

            return ListView.builder(
              itemCount: _showRecentTransactions
                  ? records.length.clamp(0, 15)
                  : records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return _expenseTile(record);
              },
            );
          },
        ),
      );

  void _updateBalance(double newBalance) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _finalBalance != newBalance) {
        setState(() => _finalBalance = newBalance);
      }
    });
  }

  Widget _expenseTile(FinancialRecord record) {
    String formattedDate = DateFormat('dd MMM, yyyy').format(record.recordDate);
    return ListTile(
      title: Text(record.recordTitle),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categoria: ${record.expenseCategory}',
              style: const TextStyle(fontSize: 15)),
          Text('Método de pagamento: ${record.paymentMethod}',
              style: const TextStyle(fontSize: 15)),
          Text('Descrição: ${record.description}',
              style: const TextStyle(fontSize: 15)),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                .format(record.transactionAmount),
            style: TextStyle(
              color: record.transactionAmount < 0 ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(formattedDate,
              style: const TextStyle(fontSize: 15, color: Colors.black54)),
        ],
      ),
    );
  }
}
