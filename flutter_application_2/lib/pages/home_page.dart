import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
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
                                child: Icon(Icons.delete),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController editController =
                                          TextEditingController(
                                              text: names[index]);
                                      return AlertDialog(
                                        title: Text('Edit Name'),
                                        content: TextFormField(
                                          controller: editController,
                                          decoration: InputDecoration(
                                              alignLabelWithHint: true,
                                              hintText: "e.g. John Doe",
                                              labelText: "Enter the new name",
                                              prefixIcon: Icon(Icons.person)),
                                          onFieldSubmitted: (_) {
                                            if (editController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                names[index] =
                                                    editController.text;
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a name';
                                            }
                                            return null;
                                          },
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
                                              if (_formKey.currentState!
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
          full_name = newFullName;
          opacityLevel = 1.0;
          _showFullName = true;
          names.add(full_name);
        });
      }
    }
  }
}
