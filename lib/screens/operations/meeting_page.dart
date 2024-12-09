import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MeetingPage extends StatefulWidget {
  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  List<dynamic> meetings = [];
  bool isLoading = true;

  final List<String> dumImagesMan = [

    "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg",
    "https://images.rawpixel.com/image_png_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvMzk3LW1ja2luc2V5LTIxYTMwNzQtamlyLXJtNTExXzEtbDA5Y3ZjODQucG5n.png",
    "https://static.vecteezy.com/system/resources/thumbnails/046/496/611/small_2x/handsome-young-man-pointing-away-png.png",
    "https://static.vecteezy.com/system/resources/thumbnails/024/558/262/small/businessman-isolated-illustration-ai-generative-free-png.png"

  ];
  Future<void> updateMeetingStatus(int meetingId, int approvalStatus) async {
    final url = Uri.parse(
        'https://efd9-163-47-36-250.ngrok-free.app/meet/status/$approvalStatus/id/$meetingId');
    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meeting status updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update meeting status.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }


  void showConfirmationDialog(BuildContext context, int meetingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Action"),
          content: Text("Do you want to approve or disapprove this meeting?"),
          actions: [
            TextButton(
              onPressed: () {
                updateMeetingStatus(meetingId, 0);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Disapprove", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                updateMeetingStatus(meetingId, 2);
                showMeetingIdDialog(context, meetingId); // Show meeting ID
              },
              child: Text("Approve"),
            ),
          ],
        );
      },
    );
  }

  void showMeetingIdDialog(BuildContext context, int meetingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Meeting Approved"),
          content: Text("Meeting ID: $meetingId"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    fetchMeetings();
  }

  Future<void> fetchMeetings() async {
    final url = Uri.parse('https://efd9-163-47-36-250.ngrok-free.app/meet/user/1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          meetings = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pending Requests', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : meetings.isEmpty
          ? Center(
        child: Text(
          "No available meeting request",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          final slot = meeting['slot'];
          final status = meeting['status'];
          final description = meeting['description'] ?? 'No description';
          final date = DateTime.parse(meeting['date']).toLocal();
          final startTime = meeting['start_time'] ?? slot['startTime'];
          final endTime = meeting['end_time'] ?? slot['endTime'];

          return GestureDetector(
            onTap: () => showConfirmationDialog(context, meeting['id']),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: status == 0
                    ? Colors.red[200] // Light red for status 0
                    : status == 2
                    ? Colors.green[100] // Light green for status 2
                    : null, // Default color for status 1
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        dumImagesMan[index % 3]), // Dummy network image
                  ),
                  title: Text(
                    description,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date: ${date.day}/${date.month}/${date.year}",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        "Time: ${formatTime(startTime)} - ${formatTime(endTime)}",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.more_vert, color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  String formatTime(String? time) {
    if (time == null) return 'N/A';
    final parsedTime = DateTime.parse(time).toLocal();
    return "${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')} ${parsedTime.hour >= 12 ? 'PM' : 'AM'}";
  }
}
