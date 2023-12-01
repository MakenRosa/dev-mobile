// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mkn_bank/models/account_profile.dart';
import 'package:mkn_bank/views/authentication/login_view.dart';
import 'package:mkn_bank/views/finance/expense_overview_view.dart';
import 'package:mkn_bank/views/finance/expense_creation_view.dart';
import 'package:mkn_bank/views/finance/finance_summary_view.dart';

class DashboardView extends StatefulWidget {
  final AccountProfile userProfile;

  const DashboardView({required this.userProfile, Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  List<Widget> get _pageOptions => [
        ExpenseOverviewView(userProfile: widget.userProfile),
        ExpenseCreationView(userProfile: widget.userProfile),
        FinanceSummaryView(userProfile: widget.userProfile),
      ];

  void _onItemTapped(int index) {
    if (index == _pageOptions.length) {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 196, 123, 209), 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Visão Geral', backgroundColor: Color.fromARGB(255, 239, 170, 252)),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.description), label: 'Resumo'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Sair'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 163, 0, 192), 
        unselectedItemColor: Colors.purple[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
