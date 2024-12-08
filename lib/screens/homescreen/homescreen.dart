import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lucchack/constants/theming.dart';
import 'package:lucchack/featurepages/dashboard.dart';
import 'package:lucchack/screens/auth/loginscreen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/admin-home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 2;
  List<Widget> pages = [


   const Dashboard(),
    const Dashboard(),
    const Dashboard(),
    const Dashboard(),
    const Dashboard()



  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 50,
                  alignment: Alignment.topLeft,
                  child: Image.asset("assets/images/img.png")
              ),
              // NotificationWidget()

            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  // Implement your logout logic here
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false, // Set to false to remove all previous pages
                  );

                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: kBackgroundColor,
        color: kPrimaryLightColor,
        index: 2,
        items: <Widget>[
          Icon(Icons.people_outlined, size: 30, color: ksecondaryHeaderColor,),
          Icon(Icons.report_problem_outlined, size: 30, color: ksecondaryHeaderColor,),
          Icon(Icons.home, size: 30, color: ksecondaryHeaderColor,),
          Icon(Icons.place_rounded, size: 30, color: ksecondaryHeaderColor,),
          Icon(Icons.message_outlined, size: 30, color: ksecondaryHeaderColor,),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      resizeToAvoidBottomInset: false,
      body: pages[_page],
    );
  }
}
