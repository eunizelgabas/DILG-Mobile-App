import 'dart:convert';
import 'package:DILGDOCS/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sidebar.dart';
// import 'auth_service.dart'; // Import AuthService to retrieve the token
// import 'auth_services.dart';

class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  // Controllers for text fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _userName = '';

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      var token = await AuthServices.getToken();
      var url = 'http://127.0.0.1:8000/api/user'; // Replace with your backend URL
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          _userName = userData['name'];
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(
        currentIndex: 1,
        onItemSelected: (index) {
          _navigateToSelectedPage(context, index);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16),
              Text('Logged-in User: $_userName'), // Display logged-in user's name
              SizedBox(height: 16),
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[900],
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 110,
                ),
              ),
              SizedBox(height: 16),
              _buildTextField('Name', Icons.person, _nameController),
              SizedBox(height: 16),
              _buildTextField('Email', Icons.email, _emailController),
              SizedBox(height: 16),
              _buildTextField('Password', Icons.lock, _passwordController,
                  isPassword: true),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _updateProfile();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900],
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  void _navigateToSelectedPage(BuildContext context, int index) {
    // Handle navigation if needed
  }

  Future<void> _updateProfile() async {
  var url = 'http://192.168.0.115/api/user/update';
  var token = await AuthServices.getToken(); // Retrieve authentication token
  print(token);
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', // Include the token in the request headers
  };

  var newName = _nameController.text;
  var newEmail = _emailController.text;

  var userData = {
    'name': newName,
    'email': newEmail,
    // Add other fields as needed
  };

  try {
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(userData), // Encode userData to JSON string
    );

    if (response.statusCode == 200) {
      // User profile updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile Updated'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Failed to update user profile
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (error) {
    // Handle network errors
    print('Error updating profile: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating profile'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

}
