// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:mkn_bank/models/financial_record.dart';
import 'package:mkn_bank/models/account_profile.dart';
import 'package:mkn_bank/services/financial_activity_service.dart';

class FinanceSummaryView extends StatefulWidget {
  final AccountProfile userProfile;

  FinanceSummaryView({super.key, required this.userProfile});

  @override
  _FinanceSummaryViewState createState() => _FinanceSummaryViewState();
}

class _FinanceSummaryViewState extends State<FinanceSummaryView> {
  final FinancialActivityService financialActivityService = FinancialActivityService();
  Map<String, double> expenseDataMap = {};
  Map<String, double> incomeDataMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise Financeira'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<FinancialRecord>>(
              stream: financialActivityService.getFinancialRecordsStream(widget.userProfile.accountId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma movimentação encontrada'));
                }

                List<FinancialRecord> records = snapshot.data!;
                _processFinancialData(records);

                return Column(
                  children: [
                    _createPieChart('Despesas', expenseDataMap),
                    const SizedBox(height: 20),
                    _createPieChart('Receitas', incomeDataMap),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createPieChart(String title, Map<String, double> dataMap) {
    if (dataMap.isEmpty) {
      return const Text('Nenhuma movimentação para esta categoria');
    }
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width / 2.5,
          chartType: ChartType.disc,
          legendOptions: const LegendOptions(
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValues: true,
            showChartValuesInPercentage: true,
          ),
        ),
      ],
    );
  }

  void _processFinancialData(List<FinancialRecord> records) {
    expenseDataMap = _createCategoryDataMap(records, isExpense: true);
    incomeDataMap = _createCategoryDataMap(records, isExpense: false);
  }

  Map<String, double> _createCategoryDataMap(List<FinancialRecord> records, {required bool isExpense}) {
    final Map<String, double> categoryAmounts = {};
    for (var record in records) {
      if ((isExpense && record.transactionAmount < 0) || (!isExpense && record.transactionAmount > 0)) {
        String category = record.expenseCategory;
        double amount = record.transactionAmount.abs();
        categoryAmounts.update(category, (value) => value + amount, ifAbsent: () => amount);
      }
    }

    final total = categoryAmounts.values.fold(0.0, (sum, amount) => sum + amount);
    return categoryAmounts.map((key, value) => MapEntry(key, (value / total) * 100));
  }
}
