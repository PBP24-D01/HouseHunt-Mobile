import 'package:flutter/material.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:househunt_mobile/module/rumah/house_details.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<House> houses = [];
  List<int> wishlistIds = [];
  List<String> locations = [];
  List<String> priceRanges = [];
  List<String> bedroomOptions = [];
  List<String> bathroomOptions = [];
  String? selectedLocation;
  String? selectedPriceRange;
  String? selectedBedrooms;
  String? selectedBathrooms;

  @override
  void initState() {
    super.initState();
    fetchFilterOptions();
    fetchHouses();
    fetchWishlist();
  }

  Future<void> fetchFilterOptions() async {
    final response =
        // change before deployment
        await http.get(Uri.parse(
            'https://tristan-agra-househunt.pbp.cs.ui.ac.id/api/filter-options/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        locations = List<String>.from(data['locations']);
        priceRanges = List<String>.from(data['price_ranges']);
        bedroomOptions = List<String>.from(data['bedrooms']);
        bathroomOptions = List<String>.from(data['bathrooms']);
      });
    } else {
      throw Exception('Failed to load filter options');
    }
  }

  Future<void> fetchHouses() async {
    final queryParameters = {
      if (selectedLocation != null && selectedLocation!.isNotEmpty)
        'lokasi': selectedLocation,
      if (selectedPriceRange != null && selectedPriceRange!.isNotEmpty)
        'price_range': selectedPriceRange,
      if (selectedBedrooms != null && selectedBedrooms!.isNotEmpty)
        'kamar_tidur': selectedBedrooms,
      if (selectedBathrooms != null && selectedBathrooms!.isNotEmpty)
        'kamar_mandi': selectedBathrooms,
      'is_available': 'on',
    };
    // change before deployment
    final uri = Uri.https('tristan-agra-househunt.pbp.cs.ui.ac.id',
        '/api/houses/', queryParameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        houses = jsonData.map((data) => House.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load houses');
    }
  }

  bool isLoading = false;

  Future<void> toggleWishlist(int houseId) async {
    final request = context.read<CookieRequest>();
    if (!request.loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to manage your wishlist.')),
      );
      return;
    }

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url =
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/wishlist/add-flutter/$houseId/';

      final response = await request.post(url, {});

      if (response['status'] == 'success') {
        // Update wishlist based on current state
        setState(() {
          if (wishlistIds.contains(houseId)) {
            wishlistIds.remove(houseId);
          } else {
            wishlistIds.add(houseId);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      } else if (response['status'] == 'unauthorized') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Only buyers can access this feature.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? 'Failed to update wishlist')),
        );
        // Refresh wishlist to ensure UI is in sync with server
        await fetchWishlist();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating wishlist: $e')),
      );
      // Refresh wishlist to ensure UI is in sync with server
      await fetchWishlist();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchWishlist() async {
    final request = context.read<CookieRequest>();
    if (!request.loggedIn) {
      setState(() {
        wishlistIds = [];
      });
      return;
    }

    try {
      final response = await request
          .get('https://tristan-agra-househunt.pbp.cs.ui.ac.id/wishlist/json/');
      // The response here is a Map<dynamic, dynamic>

      // 1. Verify the JSON keys you’re expecting
      if (response.containsKey('wishlists')) {
        final wishlistData = response['wishlists'] as List;
        setState(() {
          wishlistIds =
              wishlistData.map<int>((item) => item['rumah_id'] as int).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching wishlist: $e')),
      );
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(100, 50),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedLocation = null;
                          selectedPriceRange = null;
                          selectedBedrooms = null;
                          selectedBathrooms = null;
                        });
                        fetchHouses();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Lokasi',
                    border: OutlineInputBorder(),
                  ),
                  items: locations.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: selectedLocation,
                  onChanged: (newValue) {
                    setState(() {
                      selectedLocation = newValue;
                    });
                  },
                ),

                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                  ),
                  items: priceRanges.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: selectedPriceRange,
                  onChanged: (newValue) {
                    setState(() {
                      selectedPriceRange = newValue;
                    });
                  },
                ),

                const SizedBox(height: 8),
                // Row 2: Bedrooms and Bathrooms

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kamar',
                    border: OutlineInputBorder(),
                  ),
                  items: bedroomOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: selectedBedrooms,
                  onChanged: (newValue) {
                    setState(() {
                      selectedBedrooms = newValue;
                    });
                  },
                ),

                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kamar mandi',
                    border: OutlineInputBorder(),
                  ),
                  items: bathroomOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: selectedBathrooms,
                  onChanged: (newValue) {
                    setState(() {
                      selectedBathrooms = newValue;
                    });
                  },
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    fetchHouses();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cari Rumah',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    bool isAuthenticated = request.loggedIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HouseHunt',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        foregroundColor: Color.fromRGBO(74, 98, 138, 1),
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: isAuthenticated ? 2 : 1,
      ),
      body: Column(
        children: [
          // **Filter Section**
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  child: const Text('Filter Rumah'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: houses.length,
              itemBuilder: (context, index) {
                final House house = houses[index];
                final bool isWishlisted = wishlistIds.contains(house.id);

                return HouseCard(
                  house: house,
                  isWishlisted: isWishlisted,
                  onToggleWishlist: toggleWishlist,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  final House house;
  final bool isWishlisted;
  final Function(int houseId) onToggleWishlist;

  const HouseCard({
    Key? key,
    required this.house,
    required this.isWishlisted,
    required this.onToggleWishlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the house image
          house.imageUrl != null
              ? Image.network(
                  house.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                )
              : Image.network(
                  'https://via.placeholder.com/150',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Heart Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      house.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Inside HouseCard build method
                    IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.red : Colors.black,
                      ),
                      onPressed: () => onToggleWishlist(house.id),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Location
                Text(
                  house.location,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),

                // Price
                Text(
                  'Rp ${house.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),

                // Bedrooms and Bathrooms
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bed),
                        const SizedBox(width: 5),
                        Text('${house.bedrooms} Bedrooms'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.bathtub),
                        const SizedBox(width: 5),
                        Text('${house.bathrooms} Bathrooms'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // View Details Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailsPage(house: house),
                        ),
                      );
                    },
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
}
