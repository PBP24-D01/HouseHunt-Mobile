import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/wishlist/models/wishlist.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:househunt_mobile/module/wishlist/wishlist_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Fetch wishlist from the API
  Future<List<Wishlist>> fetchWishlist(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/wishlist/json/');

    // Ensure the response is valid
    if (response == null || response is! Map) {
      return []; // Return an empty list if the response is invalid
    }

    var data = response['wishlists']; 

    if (data == null || data.isEmpty) {
      return [];
    }

    // Process the data into a list of Wishlist objects
    List<Wishlist> wishlist = [];
    for (var d in data) {
      if (d != null) {
        wishlist.add(Wishlist.fromJson(d));
      }
    }
    return wishlist;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.blue,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Wishlist>>(
          future: fetchWishlist(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Kamu belum punya wishlist rumah!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rumah yang nyaman adalah rumah yang dapat memberi ketenangan. Rencanakan rumah terbaikmu bersama HouseHunt.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Add navigation or action logic here
                        },
                        child: const Text('Cari Rumah'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Display the wishlist items using WishlistCard
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return WishlistCard(
                    wishlist: item, // Pass the item data
                    onDelete: () {
                      // Handle item deletion
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
