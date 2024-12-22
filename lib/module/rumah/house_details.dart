import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';
import 'package:househunt_mobile/module/rumah/edit_house.dart';
import 'package:househunt_mobile/module/auth/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:househunt_mobile/module/rumah/order_page.dart';
import 'package:househunt_mobile/module/auth/models/buyer.dart';
import 'package:http/http.dart' as http;

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
  Buyer? buyer;

  @override
  void initState() {
    super.initState();
    checkUserType();
  }

  void checkUserType() {
    final request = Provider.of<CookieRequest>(context, listen: false);

    setState(() {
      isAuthenticated = request.loggedIn;
      isBuyer = request.jsonData['is_buyer'] ?? false;
      isSeller = !isBuyer;

      if (isBuyer) {
        buyer = Buyer(
          id: request.jsonData['id'],
          username: request.jsonData['username'],
          email: request.jsonData['email'],
          phoneNumber: request.jsonData['phone_number'],
          isBuyer: request.jsonData['is_buyer'],
          preferredPaymentMethod: request.jsonData['preferred_payment_method'],
        );
      }
    });
  }

  Future<void> markHouseAsUnavailable() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final response = await request.post('http://10.0.2.2:8000/api/house_delete/${widget.house.id}/', {} );

    if (response['status'] == 'success') {
      setState(() {
        widget.house.isAvailable = false;
      });
      Navigator.pop(context);
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark house as unavailable')),
      );
    }
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
            // house img
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: widget.house.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(widget.house.imageUrl!),
                        fit: BoxFit.contain,
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
        child: isAuthenticated
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditHousePage(house: widget.house),
                          ),
                        );
                      },
                      child: const Text('Edit House'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: markHouseAsUnavailable,
                      child: const Text('Mark as Unavailable'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text('Order House'),
              ),
      ),
    );
  }
}
