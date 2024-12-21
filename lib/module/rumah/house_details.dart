import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';
import 'package:househunt_mobile/module/rumah/edit_house.dart';
import 'package:househunt_mobile/module/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseDetailsPage extends StatefulWidget {
  final House house;

  const HouseDetailsPage({Key? key, required this.house}) : super(key: key);

  @override
  _HouseDetailsPageState createState() => _HouseDetailsPageState();
}

class _HouseDetailsPageState extends State<HouseDetailsPage> {
  bool isSeller = false;
  bool isBuyer = false;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    checkUserType();
  }

  Future<void> checkUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final isBuyer = prefs.getBool('is_buyer') ?? false;
    final isSeller = !isBuyer;
    final isAuthenticated = prefs.getBool('is_authenticated') ?? false;

    setState(() {
      this.isSeller = isSeller;
      this.isBuyer = isBuyer;
      this.isAuthenticated = isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.house.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the house image
            Container(
              width: double.infinity,
              height: 300, // Set a fixed height for the image container
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: widget.house.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(widget.house.imageUrl!),
                        fit: BoxFit
                            .contain, // Scale the image to fit within the container
                      )
                    : null,
              ),
              child: widget.house.imageUrl == null
                  ? const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              widget.house.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.house.location,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${widget.house.price}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.house.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.bed),
                const SizedBox(width: 5),
                Text('${widget.house.bedrooms} Bedrooms'),
                const SizedBox(width: 20),
                const Icon(Icons.bathtub),
                const SizedBox(width: 5),
                Text('${widget.house.bathrooms} Bathrooms'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.house.isAvailable ? 'Available' : 'Not Available',
              style: TextStyle(
                fontSize: 16,
                color: widget.house.isAvailable ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isSeller
            ? ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditHousePage(house: widget.house),
                    ),
                  );
                },
                child: const Text('Edit House'),
              )
            : ElevatedButton(
                onPressed: () {
                  if (isAuthenticated) {
                    // Implement buy functionality
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                },
                child: const Text('Buy House'),
              ),
      ),
    );
  }
}
