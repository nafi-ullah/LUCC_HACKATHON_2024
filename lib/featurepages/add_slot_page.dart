import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddSlotPage extends StatefulWidget {
  @override
  _AddSlotPageState createState() => _AddSlotPageState();
}

class _AddSlotPageState extends State<AddSlotPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;

  Future<void> pickDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> submitSlot() async {
    if (startTime == null ||
        endTime == null ||
        startDate == null ||
        endDate == null ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      return;
    }

    final DateTime startDateTime = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final DateTime endDateTime = DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

     print("${startDateTime.toIso8601String()}");
     print("${endDateTime.toIso8601String()}");

    final response = await http.post(
      Uri.parse('https://d4df-163-47-36-250.ngrok-free.app/slot/create'),
      headers: {'Content-Type': 'application/json'},
      body: '''
      {
        "title": "${titleController.text}",
        "description": "${descriptionController.text}",
        "startTime": "${startDateTime.toIso8601String()}",
        "endTime": "${endDateTime.toIso8601String()}",
        "startDate": "${startDateTime.toIso8601String()}",
        "endDate": "${endDateTime.toIso8601String()}",
        "userId": 1
      }
      ''',
    );

    print("data added------------------");
    print(response);

    if (response.statusCode == 201 || response.statusCode == 200) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/added.gif',
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 16),
                Text(
                  "Slot is added",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ],
            ),
          );


        },
      );
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF928BAD),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Slot", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => pickTime(context, true),
                  child: Text(startTime == null
                      ? "Pick Start Time"
                      : startTime!.format(context)),
                ),
                ElevatedButton(
                  onPressed: () => pickTime(context, false),
                  child: Text(endTime == null
                      ? "Pick End Time"
                      : endTime!.format(context)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => pickDate(context, true),
                  child: Text(startDate == null
                      ? "Pick Start Date"
                      : DateFormat('yyyy-MM-dd').format(startDate!)),
                ),
                ElevatedButton(
                  onPressed: () => pickDate(context, false),
                  child: Text(endDate == null
                      ? "Pick End Date"
                      : DateFormat('yyyy-MM-dd').format(endDate!)),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitSlot,
              child: Text("Submit Slot"),
            ),
          ],
        ),
      ),
    );
  }
}
