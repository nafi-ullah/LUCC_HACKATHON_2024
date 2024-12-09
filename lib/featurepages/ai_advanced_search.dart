import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchSlotPage extends StatefulWidget {
  @override
  _SearchSlotPageState createState() => _SearchSlotPageState();
}

class _SearchSlotPageState extends State<SearchSlotPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _slotDetails = [];

  Future<void> _searchSlots() async {
    setState(() {
      _isLoading = true;
    });

    final String inputText = _textController.text;
    final String aiUrl = "https://efd9-163-47-36-250.ngrok-free.app/ai/guest";
    final String slotDetailsUrl =
        "https://efd9-163-47-36-250.ngrok-free.app/slot/single/";

    try {
      // AI Request
      print("ai request--------------");
      print(inputText);
      final aiResponse = await http.post(
        Uri.parse(aiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userId": 1,
          "text": inputText.replaceAll('"', '\\"'), // Escape quotes
        }),
      );

      print(aiResponse.body);


      if (aiResponse.statusCode == 200) {
        final List<dynamic> aiData = json.decode(aiResponse.body);
        final List<int> slotIds = aiData.map<int>((slot) => slot["slotId"] as int).toList();

        // Fetch slot details
        List<dynamic> slotsDetails = [];
        for (var slotId in slotIds) {
          final slotResponse =
          await http.get(Uri.parse('$slotDetailsUrl$slotId'));
          if (slotResponse.statusCode == 200) {
            slotsDetails.add(json.decode(slotResponse.body));
          }
        }

        setState(() {
          _slotDetails = slotsDetails;
        });

        print(slotsDetails);
      } else {
        print("Error: ${aiResponse.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showBookingModal(BuildContext context, dynamic slot) {
    final TextEditingController _descriptionController =
    TextEditingController();
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
          heightFactor: 0.9,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? "${selectedDate?.toLocal()}".split(' ')[0]
                        : "Select Date",
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
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
                    },
                    child: Text("Pick Date"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedDate != null) {
                    final String bookingUrl =
                        "https://efd9-163-47-36-250.ngrok-free.app/meet/create";
                    await http.post(
                      Uri.parse(bookingUrl),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        "description": _descriptionController.text,
                        "date": selectedDate!.toIso8601String(),
                        "slotId": slot["id"],
                        "hostId": slot["user"]["id"],
                        "guestIds": [2, 3],
                      }),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text("Book Slot"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Slot by AI"),
        backgroundColor: Color(0xFF928BAD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter your request...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchSlots,
              child: _isLoading
                  ? SpinKitCircle(color: Colors.white)
                  : Text("Search Slot by AI"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF928BAD),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _slotDetails.length,
                itemBuilder: (context, index) {
                  final slot = _slotDetails[index];
                  final user = slot["user"]; // Extract user details

                  return Card(
                    child: ListTile(
                      title: Text(slot["title"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(slot["description"]),
                          SizedBox(height: 5), // Add spacing between lines
                          Text("Name: ${user["name"]}"),
                          Text("Email: ${user["email"]}"),
                          Text("Profession: ${user["profession"]}"),
                        ],
                      ),
                      trailing: Text(
                        "${DateTime.parse(slot["startDate"]).toLocal()}".split(' ')[0],
                      ),
                      onTap: () => _showBookingModal(context, slot),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
