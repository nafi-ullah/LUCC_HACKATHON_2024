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
  List<int> guestIds = [1];
  String? description;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://efd9-163-47-36-250.ngrok-free.app/auth/users'),
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

  void selectGuest(String email) {
    final user = users.firstWhere((user) => user['email'] == email, orElse: () => null);
    if (user != null && !guestIds.contains(user['id'])) {
      setState(() {
        guestIds.add(user['id']);
      });
    }
  }

  Future<void> createMeeting(int slotId, int hostId, selectedDate) async {

    final requestBody = {
      "description": description,
      "date": selectedDate,
      "slotId": slotId,
      "hostId": hostId,
      "guestIds": guestIds,
    };

    print("Request body------------------");
    print(requestBody);

    final response = await http.post(
      Uri.parse('https://efd9-163-47-36-250.ngrok-free.app/meet/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meeting created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create meeting')),
      );
    }
  }


  void showRequestMeetingModal(BuildContext context, Map<String, dynamic> slot, int userId) {
    DateTime? selectedDate;

    Future<void> pickDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request for Meeting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0]
                        : 'No Date Selected',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => pickDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) => description = value,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TypeAheadField<String>(
                suggestionsCallback: (query) => getEmailSuggestions(query),
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSelected: (email) {
                  selectGuest(email); // Add the selected guest email to the guestIds list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$email added to guest list')),
                  );
                },
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Add guest email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),


              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  createMeeting(slot['id'], userId, selectedDate);
                },
                child: Text('Send Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildSlots(List slots, int userId) {
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
              onTap: () => showRequestMeetingModal(context, slot, userId),
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
                Expanded(child: buildSlots(selectedUser!['slots'], selectedUser!['id'])),
            ],
          ],
        ),
      ),
    );
  }
}
