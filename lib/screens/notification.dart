import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:DILGDOCS/Services/auth_services.dart';
import 'package:DILGDOCS/Services/globals.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> newIssuances = [];
  List<dynamic> yesterdayIssuances = [];
  List<dynamic> last7DaysIssuances = [];

  @override
  void initState() {
    super.initState();
    fetchRecentIssuances();
  }

  Future<void> fetchRecentIssuances() async {
    try {
      String? token = await AuthServices.getToken();
      final response = await http.get(
        Uri.parse('$baseURL/recent-issuances'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> recentData = json.decode(response.body)['recentIssuances'];
        
        setState(() {
          newIssuances = recentData['today'];
          yesterdayIssuances = recentData['yesterday'];
          last7DaysIssuances = recentData['last7Days'];
        });
      } else {
        throw Exception('Failed to load recent issuances');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        children: [
          if (newIssuances.isNotEmpty) ...[
            ListTile(
              title: Text('New Issuances', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (var issuance in newIssuances)
              ListTile(
                title: Text(issuance['title'] ?? ''),
                subtitle: Text(issuance['type'] ?? ''),
              ),
          ],
          if (yesterdayIssuances.isNotEmpty) ...[
            ListTile(
              title: Text('Yesterday Issuances', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (var issuance in yesterdayIssuances)
              ListTile(
                title: Text(issuance['title'] ?? ''),
                subtitle: Text(issuance['type'] ?? ''),
              ),
          ],
          if (last7DaysIssuances.isNotEmpty) ...[
            ListTile(
              title: Text('Last 7 Days Issuances', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            for (var issuance in last7DaysIssuances)
              ListTile(
                title: Text(issuance['title'] ?? ''),
                subtitle: Text(issuance['type'] ?? ''),
              ),
          ],
        ],
      ),
    );
  }
}
