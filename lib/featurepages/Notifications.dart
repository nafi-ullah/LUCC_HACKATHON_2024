import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketPage extends StatefulWidget {
  @override
  _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  String message = "";
  String room = "";

  @override
  void initState() {
    super.initState();
    socket = IO.io('https://efd9-163-47-36-250.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to the server');
    });

    socket.on('message-recieve', (data) {
      setState(() {
        message = data['message'];
      });
      print("Received message: $message");
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void joinRoom() {
    room = roomController.text;
    socket.emit('join_room', {'messid': room});
    print("Joined room: $room");
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      socket.emit('message', {
        'message': messageController.text,
        'room': roomController.text
      });
      print("Message sent: ${messageController.text}");
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Chat Room'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: roomController,
              decoration: InputDecoration(
                labelText: 'Enter Room ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: joinRoom,
              child: Text('Join Room'),
              style: ElevatedButton.styleFrom(

              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Enter Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Send Message'),

            ),
            SizedBox(height: 40),
            Text(
              'Received Message: $message',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
