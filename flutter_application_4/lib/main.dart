import 'package:flutter/material.dart';
import 'package:flutter_application_4/component/Contact/contact.dart';
import 'component/get_api.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactsPage(),
    );
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Future<List<Contact>>? _contactsFuture;
  TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _contactsFuture = fetchContacts();
  }

  Future<List<Contact>> fetchContacts() async {
    final response = await GetApi.getApiContact();
    final Map<String, dynamic> parsedResponse = json.decode(response);
    return (parsedResponse["contacts"] as List)
        .map((contactJson) => Contact.fromJson(contactJson))
        .toList();
  }

  void _showContactDetails(Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contact.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    contact.photo,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 8),
                    Text('Age: ${contact.age}', style: const TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline),
                    const SizedBox(width: 8),
                    Text('Gender: ${contact.gender}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.business),
                    const SizedBox(width: 8),
                    Text('Company: ${contact.company}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email_outlined),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        contact.email,
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _filterContacts(String query) {
    setState(() {
      _contactsFuture!.then((contacts) {
        _filteredContacts = contacts.where((contact) {
          final nameLower = contact.name.toLowerCase();
          final emailLower = contact.email.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower) || emailLower.contains(queryLower);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _filterContacts(value);
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts found.'));
          } else {
            final contacts = _filteredContacts.isNotEmpty ? _filteredContacts : snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onHover: (PointerEvent details) {
                    setState(() {
                      contacts[index].isHovered = true;
                    });
                  },
                  onExit: (PointerEvent details) {
                    setState(() {
                      contacts[index].isHovered = false;
                    });
                  },
                  child: ListTile(
                    title: Text(contact.name),
                    subtitle: Text(contact.email),
                    tileColor: contact.isHovered ? Colors.grey[300] : null,
                    onTap: () => _showContactDetails(contact),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}