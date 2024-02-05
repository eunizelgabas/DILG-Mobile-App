import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../screens/sidebar.dart';
import '../screens/details_screen.dart';
import 'package:http/http.dart' as http;

class RepublicActs extends StatefulWidget {
  @override
  _RepublicActsState createState() => _RepublicActsState();
}

class _RepublicActsState extends State<RepublicActs> {
  List<RepublicAct> _republicActs = [];
  List<RepublicAct> get republicActs => _republicActs;
// Default selection

  @override
  void initState() {
    super.initState();
    fetchRepublicActs();
  }

  Future<void> fetchRepublicActs() async {
    final response = await http.get(
      Uri.parse('https://dilg.mdc-devs.com/api/republic_acts'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['republics'];

      setState(() {
        _republicActs = data.map((item) => RepublicAct.fromJson(item)).toList();
      });
    } else {
      // Handle error
      print('Failed to load republic acts');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Republic Acts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.blue[900]),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: _buildBody(),
      drawer: Sidebar(
        currentIndex: 6,
        onItemSelected: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    TextEditingController searchController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Input
          Container(
            margin: EdgeInsets.only(bottom: 8.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Handle search input changes
              },
            ),
          ),

          // Category Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title/Subject: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                
              ],
            ),
          ),

          SizedBox(height: 16.0),

          // Sample Table Section
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                for (int index = 0; index < _republicActs.length; index++)
                  InkWell(
                    onTap: () {
                      _navigateToDetailsPage(context, _republicActs[index]);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.article,
                                color: Colors.blue[900]), // Replace with your desired icon
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                _republicActs[index].issuance.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              DateFormat('MMMM dd, yyyy').format(
                                DateTime.parse(_republicActs[index].issuance.date),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailsPage(BuildContext context, RepublicAct issuance) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailsScreen(
        title: issuance.issuance.title,
        content: 'Ref #${issuance.issuance.referenceNo}\n${DateFormat('MMMM dd, yyyy').format(DateTime.parse(issuance.issuance.date))}',
        pdfUrl: issuance.issuance.urlLink 
      ),
    ),
  );
}
}

//for Latest getters and setters
class RepublicAct{
  final int id;
  final String responsible_office;
  
  final Issuance issuance;

  RepublicAct({
    required this.id,
    required this.responsible_office,

    required this.issuance,
  });

  factory RepublicAct.fromJson(Map<String, dynamic> json) {
    return RepublicAct(
      id: json['id'],
      responsible_office: json['responsible_office'],
      issuance: Issuance.fromJson(json['issuance']),
    );
  }
}

//for Issuance
class Issuance {
  final int id;
  final String date;
  final String title;
  final String referenceNo;
  final String keyword;
  final String urlLink;

  Issuance({
    required this.id,
    required this.date,
    required this.title,
    required this.referenceNo,
    required this.keyword,
    required this.urlLink,
  });

  factory Issuance.fromJson(Map<String, dynamic> json) {
    return Issuance(
      id: json['id'],
      date: json['date'],
      title: json['title'],
      referenceNo: json['reference_no'],
      keyword: json['keyword'],
      urlLink: json['url_link'],
    );
  }
}