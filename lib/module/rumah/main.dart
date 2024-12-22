import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:househunt_mobile/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List houses = [];
  List<String> locations = [];
  List<String> priceRanges = [];
  List<String> bedrooms = [];
  List<String> bathrooms = [];
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
        bedrooms = List<String>.from(data['bedrooms']);
        bathrooms = List<String>.from(data['bathrooms']);
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
      setState(() {
        houses = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load houses');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Houses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  hint: const Text('Select Location'),
                  items: locations.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedLocation = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriceRange,
                  hint: const Text('Select Price Range'),
                  items: priceRanges.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPriceRange = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedBedrooms,
                  hint: const Text('Select Bedrooms'),
                  items: bedrooms.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedBedrooms = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedBathrooms,
                  hint: const Text('Select Bathrooms'),
                  items: bathrooms.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedBathrooms = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: fetchHouses,
                  child: const Text('Cari Rumah'),
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
  final Map house;

  const HouseCard({required this.house});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the house image
          Image.network(
            house['gambar'] ?? 'https://via.placeholder.com/150',
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house['judul'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  house['lokasi'] ?? 'No Location',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rp ${house['harga']?.toString() ?? '0'}',
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
                        Text('${house['kamar_tidur'] ?? '0'} Bedrooms'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.bathtub),
                        const SizedBox(width: 5),
                        Text('${house['kamar_mandi'] ?? '0'} Bathrooms'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
