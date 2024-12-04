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
  String? selectedLocation;
  String? selectedPriceRange;
  String? selectedBedrooms;
  String? selectedBathrooms;

  @override
  void initState() {
    super.initState();
    fetchHouses();
  }

  Future<void> fetchHouses() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/houses/?lokasi=$selectedLocation&price_range=$selectedPriceRange&kamar_tidur=$selectedBedrooms&kamar_mandi=$selectedBathrooms&is_available=on'));

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          // filters
          // note this probably wont work until i have the API running
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
                  items: <String>['', 'Bekasi', 'Cikarang', 'Cibubur']
                      .map((String value) {
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
                  items: <String>[
                    '',
                    '0-500000000',
                    '500000000-1000000000',
                    '1000000000-2000000000',
                    '2000000000-999999999999'
                  ].map((String value) {
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
                  items: <String>['', '1', '2', '3', '4+'].map((String value) {
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
                  items: <String>['', '1', '2', '3+'].map((String value) {
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
          // Display filtered houses
          Expanded(
            child: ListView.builder(
              itemCount: houses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(houses[index]['judul']),
                    subtitle: Text(houses[index]['deskripsi']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
