import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';

class HouseDetailsPage extends StatelessWidget {
  final House house;

  const HouseDetailsPage({Key? key, required this.house}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(house.title),
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
                image: house.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(house.imageUrl!),
                        fit: BoxFit
                            .contain, // Scale the image to fit within the container
                      )
                    : null,
              ),
              child: house.imageUrl == null
                  ? const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              house.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              house.location,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${house.price}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              house.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.bed),
                const SizedBox(width: 5),
                Text('${house.bedrooms} Bedrooms'),
                const SizedBox(width: 20),
                const Icon(Icons.bathtub),
                const SizedBox(width: 5),
                Text('${house.bathrooms} Bathrooms'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              house.isAvailable ? 'Available' : 'Not Available',
              style: TextStyle(
                fontSize: 16,
                color: house.isAvailable ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
