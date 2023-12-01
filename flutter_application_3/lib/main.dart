import 'package:flutter/material.dart';
import 'package:flutter_application_3/home_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple), 
      ),
      home: const HomePage(),
    );
  }
}
