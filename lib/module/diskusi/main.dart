import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:househunt_mobile/module/diskusi/models/show_seller.dart'; // Import the show_seller.dart file
import 'package:househunt_mobile/widgets/drawer.dart'; // Import the LeftDrawer

class DiscussionPage extends StatefulWidget {
  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  List<ShowSeller> sellers = []; // To hold the fetched seller data
  bool isLoading = true; // To indicate loading state

  @override
  void initState() {
    super.initState();
    fetchSellerData(); // Fetch data when the page initializes
  }

  Future<void> fetchSellerData() async {
    final url = Uri.parse('http://127.0.0.1:8000/diskusi/show_sellers');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          sellers = showSellerFromJson(response.body); // Decode JSON response
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussion Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(), // Add the drawer here
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader if data is loading
          : ListView.builder(
              itemCount: sellers.length,
              itemBuilder: (context, index) {
                final seller = sellers[index];
                return SellerCard(
                  name: seller.fields.companyName,
                  rating: seller.fields.stars.toString(),
                );
              },
            ),
    );
  }
}

class SellerCard extends StatelessWidget {
  final String name;
  final String rating;

  const SellerCard({
    Key? key,
    required this.name,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      rating,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.star, color: Colors.yellow[600], size: 16),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Add functionality for review button if needed
              },
              child: Text(
                'review',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}