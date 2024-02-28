import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:DILGDOCS/Services/auth_services.dart';
import 'sidebar.dart';
import '../Services/globals.dart';
import 'package:image_picker/image_picker.dart';

class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _userName = '';
  File? _userImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

 Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _userImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _fetchUserData() async {
    try {
      var token = await AuthServices.getToken();
      if (token == null) {
        return;
      }
      
      var url = "$baseURL/user";
      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          _userName = userData['name'];
          _nameController.text = userData['name'];
          _emailController.text = userData['email'];
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _updateProfile() async {
  var userId = await AuthServices.getUserId(); // Retrieve user ID
  var token = await AuthServices.getToken(); // Retrieve authentication token

  // Check if token and user ID are not null or empty
  if (token == null || token.isEmpty || userId == null) {
    print('Authentication token or user ID is null or empty. Unable to update profile.');
    return;
  }

  var url = "$baseURL/user/update/$userId"; // Include user ID in the URL

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  var newName = _nameController.text;
  var newEmail = _emailController.text;
  var newPassword = _passwordController.text; // Get the new password

  // Create the user data object with mandatory fields
  var userData = {
    'name': newName,
    'email': newEmail,
  };

  // Include the password field only if a new password is provided
  if (newPassword.isNotEmpty) {
    userData['password'] = newPassword;
  }

  try {
    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(userData),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile Updated'),
          duration: Duration(seconds: 3),
        ),
      );
      // Update UI immediately after profile update
      setState(() {
        _userName = newName;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${response.reasonPhrase}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (error) {
    print('Error updating profile: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating profile'),
        duration: Duration(seconds: 3),
      ),
    );
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
       appBar: AppBar(
        title: Text(
          'View Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back button arrow here
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16),
              Text('Logged-in User: $_userName'),
              GestureDetector(
                onTap: () {
                  // Allow users to pick an image
                  _pickImage(ImageSource.gallery);
                },
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[900],
                    image: _userImage != null
                        ? DecorationImage(
                            image: FileImage(_userImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _userImage == null
                      ? Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 110,
                        )
                      : null,
                ),
              ),

              SizedBox(height: 16),
              _buildTextField('Name', Icons.person, _nameController),
              SizedBox(height: 16),
              _buildTextField('Email', Icons.email, _emailController),
              SizedBox(height: 16),
              // _buildTextField('Password', Icons.lock, _passwordController, isPassword: true),
              // SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _updateProfile();
                },
                style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
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

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToSelectedPage(BuildContext context, int index) {
    // Handle navigation if needed
  }
}
