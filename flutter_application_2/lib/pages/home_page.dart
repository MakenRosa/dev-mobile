import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/second_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController first_name = TextEditingController();
TextEditingController last_name = TextEditingController();
String full_name = '';

class _HomePageState extends State<HomePage> {
  double opacityLevel = 0.0;
  bool _showFullName = false;
  final _formKey = GlobalKey<FormState>();
  List<String> names = [];

  var request = {
    "nome": "Maken",
    "idade": 21,
    "profissao": "dev front-end",
    "salario": 3000
  };

  void _deleteName(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $name?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  names.remove(name);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: first_name,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: "e.g. John",
                        labelText: "Enter your first name",
                        prefixIcon: Icon(Icons.person)),
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: last_name,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: "e.g. Doe",
                        labelText: "Enter your last name",
                        prefixIcon: Icon(Icons.person_outline)),
                    onFieldSubmitted: (_) => _submitForm(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            SecondPage(request: request),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          final tween = Tween(begin: begin, end: end);
                          final curvedAnimation =
                              CurvedAnimation(parent: animation, curve: curve);

                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Go to Second Page'),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(names[index]),
                        onDismissed: (direction) {
                          setState(() {
                            names.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Name removed.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                        ),
                        child: ListTile(
                          title: Text(names[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _deleteName(names[index]);
                                },
                                child: Icon(Icons.delete),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      GlobalKey<FormState> _editFormKey =
                                          GlobalKey<FormState>();
                                      TextEditingController editController =
                                          TextEditingController(
                                              text: names[index]);

                                      return AlertDialog(
                                        title: Text('Edit Name'),
                                        content: Form(
                                          key: _editFormKey,
                                          child: TextFormField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                hintText: "e.g. John Doe",
                                                labelText: "Enter the new name",
                                                prefixIcon: Icon(Icons.person)),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a name';
                                              }
                                              if (names.contains(value) &&
                                                  value != names[index]) {
                                                return 'This name already exists';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Save'),
                                            onPressed: () {
                                              if (_editFormKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  names[index] =
                                                      editController.text;
                                                });
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String newFullName = first_name.text + ' ' + last_name.text;

      if (names.contains(newFullName)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('This name already exists.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          names.add(newFullName);
          first_name.clear();
          last_name.clear();
        });
      }
    }
  }
}

void main() {
  runApp(HomePage());
}
