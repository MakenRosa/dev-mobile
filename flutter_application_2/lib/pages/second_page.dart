import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home_page.dart';

class SecondPage extends StatefulWidget {
  final Map<String, dynamic> request;

  const SecondPage({Key? key, required this.request}) : super(key: key);


  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda página'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nome: ${widget.request['nome']}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Idade: ${widget.request['idade']}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Profissão: ${widget.request['profissao']}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Salário: ${widget.request['salario']}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const beginPage = Offset(0.0, -1.0);
                const endPage = Offset.zero;
                const curve = Curves.ease;

                var tweenPage = Tween(begin: beginPage, end: endPage)
                    .chain(CurveTween(curve: curve));

                var animationPage = animation.drive(tweenPage);

                return SlideTransition(
                  position: animationPage,
                  child: child,
                );
              },
            ),
          );
        },
        child: const Text(
          'Go back to home page',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.purple,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
