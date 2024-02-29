import 'package:flutter/material.dart';
import 'edit_user.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_screen.dart';
import 'developers_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userName;

  const SettingsScreen({required this.userName});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              color: Colors.white, // Set the color of the back button
            ),
            SizedBox(
              width: 8.0,
            ), // Adjust the spacing between the back button and title
            Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            // Profile Section
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/bruce.png'),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.0),
                    Text(
                      'Welcome',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // User Profile Button
            InkWell(
              onTap: () {
                // Navigate to the user profile page (EditUser)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditUser()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'User Profile',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: 10.0),
            // Change Password Button
              InkWell(
              onTap: () {
                // Navigate to the ChangePasswordScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: 10.0),
            // FAQs Button
            InkWell(
              onTap: () {
                _launchURL();
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.question_answer,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'FAQs',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: 10.0),
            // About Button
            InkWell(
              onTap: () {
                // Handle About button tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: 10.0),
            // Developers Button
            InkWell(
              onTap: () {
                // Handle Developers button tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Developers()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Developers',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: 10.0),
            // Logout Button
            InkWell(
              onTap: () {
                // Handle Logout button tap
                _showLogoutDialog(context);
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue[900],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
            // Additional Divider Below Logout
            Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              // onPressed: () {
              //   Navigator.pop(context); // Close the dialog
              //   _logout(); // Call the updated logout function
              // },
               onPressed: () async {
                try {
                  await logout(context); // Call the logout function
                } catch (error) {
                  print('Error during logout: $error');
                  // Handle any errors that occur during logout
                }
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

 

  // void _logout() async {
  //   // Clear user authentication state
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isAuthenticated', false);

  //   setState(() {
  //     isAuthenticated = false;
  //   });
    
  //   Navigator.pushReplacementNamed(context, '/login');
  // }
  Future<void> logout(BuildContext context) async {
  // Clear authentication token from storage
  await clearAuthToken();

  // Navigate to the login screen and remove all previous routes
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}

Future<void> clearAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken');
}


  // void _showChangePasswordModal(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: Container(
  //           width: MediaQuery.of(context).size.width *
  //               0.99, // Adjust the width as needed
  //           child: ChangePasswordModal(),
  //         ),
  //       );
  //     },
  //   );
  // }
   void _launchURL() async {
    const url = 'https://dilgbohol.com/faqs'; // Replace this URL with your desired destination URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}