import 'package:flutter/material.dart';
import 'package:lucchack/screens/operations/find_hosts.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF928BAD),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/dp.png'),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Unayes Khan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'abc@example.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Drawer buttons
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(
                    icon: Icons.calendar_today,
                    text: 'Appointments',
                    onTap: () {
                      print('Appointments clicked');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.search,
                    text: 'Find Host',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserSearchPage()),
                      );

                      print('Find Host clicked');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.star,
                    text: 'Starred',
                    onTap: () {
                      print('Starred clicked');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.access_time,
                    text: 'Recents',
                    onTap: () {
                      print('Recents clicked');
                    },
                  ),
                ],
              ),
            ),
            // Logout button
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                print('Logout clicked');
              },
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required Function onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Color(0xFF928BAD),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
