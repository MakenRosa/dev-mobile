// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mkn_bank/views/authentication/login_view.dart';
import 'package:intl/intl.dart';
import 'package:mkn_bank/models/financial_record.dart';
import 'package:mkn_bank/models/account_profile.dart';
import 'package:mkn_bank/services/financial_activity_service.dart';

class HomePage extends StatefulWidget {
  final AccountProfile user;
  const HomePage({super.key, required this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FinancialActivityService financialActivityService =
      FinancialActivityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Adicionar movimentação'),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Ver meus gastos'),
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<FinancialRecord>>(
              stream: financialActivityService
                  .getFinancialRecordsStream(widget.user.accountId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Ocorreu um erro'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma despesa encontrada'));
                }

                List<FinancialRecord> expenses = snapshot.data!;

                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    String formattedDate = DateFormat('dd MMM, yyyy')
                        .format(expense.recordDate);

                    return ListTile(
                      title: Text(expense.description,
                          style: const TextStyle(fontSize: 18)),
                      subtitle: Text(expense.expenseCategory,
                          style: const TextStyle(fontSize: 15)),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'pt_BR',
                              symbol: 'R\$',
                            ).format(expense.transactionAmount),
                            style: TextStyle(
                              color: expense.transactionAmount < 0
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}