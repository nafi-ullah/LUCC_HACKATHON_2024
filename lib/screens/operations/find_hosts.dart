import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  List users = [];
  Map<String, dynamic>? selectedUser;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://d4df-163-47-36-250.ngrok-free.app/auth/users'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        users = data['users'];
      });
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  List<String> getEmailSuggestions(String query) {
    return users
        .where((user) => user['email'].toLowerCase().contains(query.toLowerCase()))
        .map<String>((user) => user['email'])
        .toList();
  }

  void selectUser(String email) {
    final user = users.firstWhere((user) => user['email'] == email, orElse: () => null);
    if (user != null) {
      setState(() {
        selectedUser = user;
      });
    }
  }

  Widget buildSlots(List slots) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: slots.length,
        itemBuilder: (context, index) {
          final slot = slots[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(slot['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot['description']),
                  Text(
                    'Start: ${slot['startTime']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'End: ${slot['endTime']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Icon(Icons.schedule, color: Color(0xFF928BAD)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search Users', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeAheadField<String>(
              suggestionsCallback: (query) => getEmailSuggestions(query),
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search email...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              itemBuilder: (context, email) {
                return ListTile(
                  title: Text(email),
                );
              },
              onSelected: (email) => selectUser(email),
              decorationBuilder: (context, child) {
                return Material(
                  type: MaterialType.card,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: child,
                );
              },
              offset: Offset(0, 12),
              constraints: BoxConstraints(maxHeight: 300),
            ),
            SizedBox(height: 20),
            if (selectedUser == null)
              Center(child: Text('No host selected', style: TextStyle(color: Colors.grey)))
            else ...[
              Text('Name: ${selectedUser!['name']}', style: TextStyle(fontSize: 18)),
              Text('Email: ${selectedUser!['email']}', style: TextStyle(color: Colors.grey)),
              Text('Profession: ${selectedUser!['profession']}'),
              SizedBox(height: 20),
              if (selectedUser!['slots'].isEmpty)
                Text('No slots available', style: TextStyle(color: Colors.grey))
              else
                Expanded(child: buildSlots(selectedUser!['slots'])),
            ],
          ],
        ),
      ),
    );
  }
}
