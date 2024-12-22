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
  }

  Future<void> fetchFilterOptions() async {
    final response =
        // change before deployment
        await http.get(Uri.parse('http://127.0.0.1:8000/api/filter-options/'));

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
    final uri = Uri.http('127.0.0.1:8000', '/api/houses/', queryParameters);

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

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    bool isAuthenticated = request.loggedIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HouseHunt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: isAuthenticated ? 2 : 1,),
      body: Column(
        children: [
          // **Filter Section**
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // **Location Filter**
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Location',
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
                const SizedBox(height: 10),
                // **Price Range Filter**
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Price Range',
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
                const SizedBox(height: 10),
                // **Bedrooms Filter**
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Bedrooms',
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
                const SizedBox(height: 10),
                // **Bathrooms Filter**
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Bathrooms',
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    fetchHouses();
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Available Houses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: houses.length,
              itemBuilder: (context, index) {
                return HouseCard(house: houses[index]);
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

  const HouseCard({required this.house});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://via.placeholder.com/150',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  house.location,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rp ${house.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
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
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailsPage(house: house),
                        ),
                      );
                    },
                    child: const Text('View Details'),
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
