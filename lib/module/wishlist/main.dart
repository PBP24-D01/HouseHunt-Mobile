import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/main.dart';
import 'package:househunt_mobile/module/wishlist/models/wishlist.dart';
import 'package:househunt_mobile/module/wishlist/wishlist_edit.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
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
    final response = await request
        .get('https://tristan-agra-househunt.pbp.cs.ui.ac.id/wishlist/json/');

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

  void _handleDeleteWishlist(Wishlist item) async {
    final request = context.read<CookieRequest>();

    final url =
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/wishlist/delete-flutter/${item.rumahId}/';

    try {
      final response = await request.post(url, {'action': 'delete'});

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
        // Rebuild the widget to refresh the wishlist
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// You can implement edit functionality here
  Future<void> _handleEditWishlist(
      Wishlist wishlist, CookieRequest request) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditWishlistPage(wishlist: wishlist),
      ),
    );

    if (updated == true) {
      setState(() {
        // Reload or refresh the wishlist data
        fetchWishlist(request);
      });
    }
  }

  // Filter options
  List<String> priorityOptions = ["All", "High", "Medium", "Low"];
  String selectedPriority = "All";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: Colors.black, // Change the title text color to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        foregroundColor: Color.fromRGBO(74, 98, 138, 1),
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Title
            const Text(
              'Filter by Priority',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Filter Dropdown
            DropdownButtonFormField<String>(
              value: selectedPriority,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPriority = newValue!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintText: 'Select Priority',
              ),
              items: priorityOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Wishlist Items
            Expanded(
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
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
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

                    // Filter the wishlist based on the selected priority
                    final filteredWishlist = wishlistItems.where((item) {
                      if (selectedPriority == "All") {
                        return true;
                      } else {
                        return item.prioritas.toLowerCase() ==
                            selectedPriority.toLowerCase();
                      }
                    }).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredWishlist.length +
                          1, // Adding 1 to include the text at the bottom
                      itemBuilder: (context, index) {
                        if (index == filteredWishlist.length) {
                          // This is the last item (text)
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Rumah yang nyaman adalah rumah yang dapat memberi ketenangan. '
                              'Rencanakan rumah terbaikmu bersama HouseHunt.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]),
                            ),
                          );
                        } else {
                          // Return the wishlist card for each item
                          final item = filteredWishlist[index];
                          return WishlistCard(
                            wishlist: item, // Pass the item data
                            request: request, // Pass the request
                            onDelete: () => _handleDeleteWishlist(item),
                            onEdit: () => _handleEditWishlist(item, request),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
