import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:DILGDOCS/screens/home_screen.dart';
import '../Services/auth_services.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  String emailError = '';
  String passwordError = '';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoggedIn(); // Check if user is already logged in when screen initializes
  }

  // checkLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? authToken = prefs.getString('authToken');

  //   if (authToken != null) {
  //     // If authToken exists, check if it's valid
  //     try {
  //       bool isValid = await AuthServices.validateToken(authToken);
  //       if (isValid) {
  //         // Token is valid, navigate to HomeScreen
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const HomeScreen()),
  //         );
  //       }
  //     } catch (error) {
  //       print('Error validating token: $error');
  //       // Handle token validation error
  //     }
  //   }
  // }
//   checkLoggedIn() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? authToken = prefs.getString('authToken');

//   if (authToken != null) {
//     // If authToken exists, navigate to HomeScreen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const HomeScreen()),
//     );
//   }
// }

// Future<void> clearToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove('authToken');
// }

// checkLoggedIn() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? authToken = prefs.getString('authToken');

//   if (authToken != null) {
//     // If authToken exists, check if it's valid
//     try {
//       bool isValid = await AuthServices.validateToken(authToken);
//       if (isValid) {
//         // Token is valid, navigate to HomeScreen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       }
//     } catch (error) {
//       // Error occurred while validating token, handle it
//       print('Error validating token: $error');
//       await clearToken(); // Clear token in case of error
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }
// }

Future<void> saveAuthToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', token);
}

// Function to retrieve authentication token
Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

// Function to clear authentication token
Future<void> clearAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('authToken');
}

// Check if user is logged in on app startup
void checkLoggedIn() async {
  String? authToken = await getAuthToken();
  if (authToken != null) {
    // Token exists, validate it (e.g., with server)
    // If token is valid, navigate to home screen
    // If token is invalid or expired, clear it and navigate to login screen
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
  } else {
    // No token found, navigate to login screen
  }
}

  loginPressed() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      try {
        http.Response response = await AuthServices.login(
          _emailController.text,
          _passwordController.text,
        );

        Map responseMap = jsonDecode(response.body);

        print("Server Response: $responseMap");

        if (response.statusCode == 200) {
          final token = responseMap['token'];

          // Store token locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('authToken', token);

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          setState(() {
            emailError = '';
            passwordError = responseMap['message'] ?? 'Login failed';
          });
        }
      } catch (error, stackTrace) {
        print("Error during login: $error");
        print("Stack trace: $stackTrace");
        setState(() {
          emailError = '';
          passwordError = 'An error occurred during login';
        });
      }
    } else {
      setState(() {
        emailError = 'Enter your email';
        passwordError = 'Enter your password';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 34,
                backgroundImage: AssetImage('assets/dilg-main.png'),
              ),
              SizedBox(height: 15),
              Text(
                'Department of the Interior and Local Government - Bohol Province',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 0, 0, 255)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Sign in to your Account',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (_emailController) {
                        if (_emailController == null || _emailController.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Add more complex email validation if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText:
                            passwordError.isNotEmpty ? passwordError : null,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text('Remember Me'),
                        Spacer(),
                        ElevatedButton(
                          onPressed: loginPressed,
                          child: Text('Log in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Text(
                '© DILG-Bohol Province 2024',
                style: TextStyle(
                  fontSize: 10,
                  color: const Color.fromARGB(255, 6, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
