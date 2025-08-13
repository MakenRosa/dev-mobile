import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Certifique-se de que o caminho para o arquivo está correto
import 'modules/authentication/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialize o Firebase aqui
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MknOfferApp());
}

class MknOfferApp extends StatelessWidget {
  const MknOfferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mkn_offer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
