import 'package:flutter/material.dart';

class WishlistCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String imageUrl;
  final String priority;
  final VoidCallback onDelete;

  const WishlistCard({
    Key? key,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.priority,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  size: 150,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Location
            Text(
              location,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            // Price
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 8),

            // Priority & Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Priority Indicator
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: _getPriorityColor(priority),
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(priority),
                  ],
                ),

                // Delete Button
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}