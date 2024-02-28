import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Services/globals.dart';

class AuthServices {
  
  static final _storage = FlutterSecureStorage();
  static final String _logoutUrl = '$baseURL/logout';


  static Future<http.Response> login(String email, String password) async {
  try {
    Map data = {
      'email': email,
      'password': password,
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseURL/auth/login');

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var token = responseData['token']; // Retrieve token from response
      var user = responseData['user']; // Retrieve user object from response
      var userId = user['id']; // Retrieve user ID from user object
      await storeTokenAndUserId(token, userId); // Store token and user ID locally
      print('Login successful');
      return response;
    } else {
      print('Login failed with status code: ${response.statusCode}');
      return response;
    }
  } catch (error) {
    print('Error during login: $error');
    throw error;
  }
}

static Future<void> storeTokenAndUserId(String token, int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setInt('userId', userId);
}

 static Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

static Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}


  static Future<void> logout() async {
    // Clear the authentication token from secure storage
    await _storage.delete(key: 'authToken');
  }


// static Future<String?> getUserId() async {
//     // Retrieve user information after successful login
//     var userData = await _getUserData();
//     if (userData != null && userData.containsKey('id')) {
//       // Return the user ID
//       return userData['id'];
//     } else {
//       // Return null if user ID is not found
//       return null;
//     }
//   }

  static Future<Map<String, dynamic>?> _getUserData() async {
    var token = await getToken();
    if (token == null) {
      // Token not available, return null
      return null;
    }
    var url = "$baseURL/user"; // Assuming this endpoint returns user information
    var response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Parse and return user data
      return jsonDecode(response.body);
    } else {
      // Failed to fetch user data, return null
      return null;
    }
  }


//   static Future<void> logout(BuildContext context) async {
//   try {
//     // Make a request to the logout endpoint
//     final response = await http.post(Uri.parse(_logoutUrl));

//     // Check if the request was successful
//     if (response.statusCode == 200) {
//       // Perform any necessary actions, such as clearing local tokens or navigating to the login screen
//       // For example:
//       // clearToken();
//       Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//     } else {
//       // Handle error response
//       print('Error during logout: ${response.statusCode}');
//     }
//   } catch (error) {
//     // Handle network or other errors
//     print('Error during logout: $error');
//   }
// }

  
 

 static Future<bool> validateToken(String authToken) async {
  final response = await http.get(
    Uri.parse('https://issuances.dilgbohol.com/auth/validate-token'),
    headers: {'Authorization': 'Bearer $authToken'},
  );

  return response.statusCode == 200;
}
}
