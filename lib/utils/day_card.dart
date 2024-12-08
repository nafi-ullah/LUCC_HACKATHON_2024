import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucchack/services/date_time_service.dart';
import 'package:lucchack/utils/time_cards.dart';
import 'package:intl/intl.dart';
class DayCard extends StatefulWidget {
  int index;
  DateTime selectedDate;
  Color cardColor;
  Color dividerColor;
  DayCard({
    Key? key,
    required this.index,
    required this.selectedDate,
    required this.cardColor,
    required this.dividerColor,
  }) : super(key: key);

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  var tasks = new Map();

  var taskDescription = new Map();

  List<String> tasksList6am = [];
  List<String> timeList = ["5 am" , "6 am" , "7 am" , "8 am", "9 am", "10 am" , "11 am", "12 pm", "1 pm", "2pm","3pm" ,"4pm" ,"5pm" , "6 pm" , "7 pm" , "8 pm", "9 pm" , "10 pm" , "11 pm" , " 12 am" , "1 am" , "2 am" , "3 am" , "4 am"];
  List<String> days = ["MONDAY" , "TUESDAY" , "WEDNESDAY" , "THURSDAY" , "FRIDAY" , "SATURDAY", "SUNDAY"];
  List<String> months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
  @override
  void initState() {
    super.initState();
    _initializeTasks();
  }

  String convertTime(DateTime inputDate) {
    // Add 1 day to the provided date
    DateTime updatedDate = DateTime(
      inputDate.year,
      inputDate.month,
      inputDate.day + 1,
    );

    // Format the updated date to "yyyy-MM-dd"
    String formattedDate = DateFormat("yyyy-MM-dd").format(updatedDate);
    return formattedDate;
  }

  void _initializeTasks() async {
    String result = convertTime(widget.selectedDate); // Convert to desired date format
    try {
      List<Map<int, List<String>>> fetchedTasks = await fetchAndFormatTasks(result);
      print("indes x value task-----------------");
      print(widget.index);
      setState(() {
        tasks = fetchedTasks[widget.index];

      });
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
    }
    debugPrint("Selected Date: ${widget.selectedDate}");
  }
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 220,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // rgb()
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(22)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(days[widget.selectedDate.weekday-1],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    spacing: -20,
                    children:[ Text(widget.selectedDate.day.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 50,
                      fontWeight: FontWeight.w500
                    ),
                    ),
                    Text(months[widget.selectedDate.month-1],
                  style: GoogleFonts.poppins(
                    fontSize: 50,
                    fontWeight: FontWeight.w500
                  ),
                  ),
                ]),
                  
                ],
              ),
              const SizedBox(width: 5,),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 235,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: timeList.length,
                  itemBuilder: (context , index){
                    return TimeCard(tasks: tasks, taskDescription: taskDescription, tasksList6am: tasksList6am,  time_for_card: timeList[index], index: index, dividerColor: widget.dividerColor, );
                  }
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
  
 
}