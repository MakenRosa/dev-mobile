import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mkn_bank/models/account_profile.dart';
import 'package:mkn_bank/services/account_service.dart';
import 'package:mkn_bank/views/authentication/signup_view.dart';
import 'package:mkn_bank/views/home/home_view.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AccountService userService = AccountService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!_validateInput(email, password)) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final AccountProfile user = await AccountService().signIn(email, password);
      _navigateToHome(user);
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? 'Ocorreu um erro de autenticação.');
    } catch (_) {
      _showErrorSnackBar('Ocorreu um erro desconhecido.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool _validateInput(String email, String password) {
    if (email.isEmpty || !email.contains('@')) {
      _showErrorSnackBar('Por favor, insira um e-mail válido.');
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      _showErrorSnackBar('A senha deve ter pelo menos 6 caracteres.');
      return false;
    }
    return true;
  }

  void _navigateToHome(AccountProfile user) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage(user: user)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Image.asset('assets/MKN_Bank_logo.png', height: 260.0),
              ),
              const SizedBox(height: 48.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignupView()));
                },
                child: const Text('Não tem uma conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
