import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DatTimeServices {

  String convertTime(String inputTime) {
    // Parse the input string into a DateTime object
    DateTime parsedTime = DateTime.parse(inputTime);

    // Add 1 day to the parsed date
    DateTime updatedTime = DateTime(
      parsedTime.year,
      parsedTime.month,
      parsedTime.day + 1,
    );

    // Format the updated date to "yyyy-MM-dd"
    String formattedDate = DateFormat("yyyy-MM-dd").format(updatedTime);

    return formattedDate;
  }
}

  Future<List<Map<int, List<String>>>> fetchAndFormatTasks(String date) async {
    final String apiUrl = "https://d4df-163-47-36-250.ngrok-free.app/slot/date/2024-12-09/user/1";

    try {
      // Hit the API
      final response = await http.get(Uri.parse(apiUrl));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        print("data-----------");
        print(data);
        // Extract `groupedSlots` from the response
        Map<String, dynamic> groupedSlots = data["groupedSlots"];

        // Initialize the tasks list
        List<Map<int, List<String>>> tasks = [];

        // Process the groupedSlots data
        for (var dateSlots in groupedSlots.values) {
          Map<int, List<String>> dayTasks = {};

          for (var i = 0; i < dateSlots.length; i++) {
            var slot = dateSlots[i];
            String title = slot["title"] ?? ""; // Fallback to an empty string if `title` is null
            dayTasks[i] = [title];
          }

          tasks.add(dayTasks);
        }

        return tasks;
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }




