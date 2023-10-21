import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase REST API Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.blueAccent,
        buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
      home: FirebaseRestTestPage(),
    );
  }
}

class FirebaseRestTestPage extends StatefulWidget {
  @override
  _FirebaseRestTestPageState createState() => _FirebaseRestTestPageState();
}

class _FirebaseRestTestPageState extends State<FirebaseRestTestPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _howLongController = TextEditingController();
  final TextEditingController _developerController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editHowLongController = TextEditingController();
  final TextEditingController _editDeveloperController = TextEditingController();
  final TextEditingController _editYearController = TextEditingController();

  List<Game> _games = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase REST API Test')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Nome do Jogo', Icons.gamepad),
                    SizedBox(height: 10),
                    _buildTextField(_howLongController, 'How Long to Beat', Icons.timer),
                    SizedBox(height: 10),
                    _buildTextField(_developerController, 'Desenvolvedora', Icons.developer_mode),
                    SizedBox(height: 10),
                    _buildTextField(_yearController, 'Ano de Lançamento', Icons.calendar_today),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text('Adicionar ao Firebase'),
                      onPressed: _sendToFirebase,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ..._games.map((game) => _buildGameCard(game)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildGameCard(Game game) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showEditDialog(game);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteGame(game.id);
              },
            ),
          ],
        ),
        title: Text(game.name),
        subtitle: Text('${game.developer} - ${game.year}, How Long to Beat: ${game.howLongToBeat}'),
      ),
    );
  }

  Future<void> _showEditDialog(Game game) async {
    _editNameController.text = game.name;
    _editHowLongController.text = game.howLongToBeat;
    _editDeveloperController.text = game.developer;
    _editYearController.text = game.year;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Editar Jogo'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Usando os novos controladores no diálogo de edição
              _buildTextField(_editNameController, 'Nome do Jogo', Icons.gamepad),
              SizedBox(height: 10),
              _buildTextField(_editHowLongController, 'How Long to Beat', Icons.timer),
              SizedBox(height: 10),
              _buildTextField(_editDeveloperController, 'Desenvolvedora', Icons.developer_mode),
              SizedBox(height: 10),
              _buildTextField(_editYearController, 'Ano de Lançamento', Icons.calendar_today),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text('Salvar'),
            onPressed: () {
              _editGameInFirebase(game.id);
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendToFirebase() async {
    final name = _nameController.text;
    final howLongToBeat = _howLongController.text;
    final developer = _developerController.text;
    final year = _yearController.text;

    final response = await http.post(
      Uri.parse('https://api-rest-3babb-default-rtdb.firebaseio.com/games.json'),
      body: jsonEncode({
        "name": name,
        "howLongToBeat": howLongToBeat,
        "developer": developer,
        "year": year
      }),
    );

    if (response.statusCode == 200) {
      _retrieveFromFirebase();
      _nameController.clear();
      _howLongController.clear();
      _developerController.clear();
      _yearController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao adicionar jogo.')),
      );
    }
  }

  Future<void> _retrieveFromFirebase() async {
    final response = await http.get(Uri.parse('https://api-rest-3babb-default-rtdb.firebaseio.com/games.json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Game> loadedGames = [];

      if (data != null && data is Map<String, dynamic>) {
        data.forEach((key, value) {
          loadedGames.add(Game(
            id: key,
            name: value['name'] as String,
            howLongToBeat: value['howLongToBeat'] as String,
            developer: value['developer'] as String,
            year: value['year'] as String,
          ));
        });
      }

      setState(() {
        _games = loadedGames;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao recuperar jogos.')),
      );
    }
  }

  Future<void> _editGameInFirebase(String id) async {
    final name = _editNameController.text;
    final howLongToBeat = _editHowLongController.text;
    final developer = _editDeveloperController.text;
    final year = _editYearController.text;

    final response = await http.patch(
      Uri.parse('https://api-rest-3babb-default-rtdb.firebaseio.com/games/$id.json'),
      body: jsonEncode({
        "name": name,
        "howLongToBeat": howLongToBeat,
        "developer": developer,
        "year": year
      }),
    );

    if (response.statusCode == 200) {
      _retrieveFromFirebase();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao editar jogo.')),
      );
    }
  }

  Future<void> _deleteGame(String id) async {
    final response = await http.delete(Uri.parse('https://api-rest-3babb-default-rtdb.firebaseio.com/games/$id.json'));

    if (response.statusCode == 200) {
      _retrieveFromFirebase();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao deletar jogo.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieveFromFirebase();
  }
}

class Game {
  final String id;
  final String name;
  final String howLongToBeat;
  final String developer;
  final String year;

  Game({
    required this.id,
    required this.name,
    required this.howLongToBeat,
    required this.developer,
    required this.year,
  });
}
