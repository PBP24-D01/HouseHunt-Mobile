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

    // If response is null or not a Map, return empty
    if (response == null || response is! Map) {
      return [];
    }

    var data = response['wishlists'];
    if (data == null || data.isEmpty) {
      return [];
    }

    List<Wishlist> wishlist = [];
    for (var d in data) {
      if (d != null) {
        wishlist.add(Wishlist.fromJson(d));
      }
    }
    return wishlist;
  }

  /// This method is called by the card's onDelete callback.
  /// It sends the delete request to your Django backend,
  /// shows a SnackBar with the response, and calls setState
  /// to refresh the FutureBuilder.
  void _handleDeleteWishlist(Wishlist item) async {
    final request = context.read<CookieRequest>();

  //   if (!request.loggedIn) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('You must log in first!')),
  //   );
  //   return;
  // }

    final url = 'http://127.0.0.1:8000/wishlist/delete-flutter/${item.rumahId}/';

    try {
      // Because we're using pbp_django_auth, the session cookie and CSRF
      // token are automatically included if the user is logged in.
      final response = await request.post(url, {'action': 'delete'});

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        // Rebuild the widget to refresh the wishlist
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// You can implement edit functionality here
  void _handleEditWishlist(Wishlist wishlist) {
    // For example, navigate to an "Edit Wishlist" screen or show a dialog
    print('Editing wishlist: ${wishlist.id}');
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
              // If the user has no wishlists
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
                        'Rumah yang nyaman adalah rumah yang dapat memberi ketenangan. '
                        'Rencanakan rumah terbaikmu bersama HouseHunt.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to your house listing page or somewhere else
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text('Cari Rumah'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // We have wishlist data to display
              final wishlistItems = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = wishlistItems[index];
                  return WishlistCard(
                    wishlist: item,  // Pass the item data
                    request: request,  // Pass the request
                    onDelete: () => _handleDeleteWishlist(item),
                    onEdit: () => _handleEditWishlist(item),
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
