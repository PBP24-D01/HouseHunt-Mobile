import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/wishlist/models/wishlist.dart';

class WishlistCard extends StatelessWidget {
  final Wishlist wishlist;
  final VoidCallback onDelete;

  const WishlistCard({
    Key? key,
    required this.wishlist,
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
                wishlist.gambar,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 150,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              wishlist.judul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Location
            Text(
              wishlist.lokasi,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            // Price
            Text(
              "\$${wishlist.harga}",
              style: const TextStyle(
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
                      color: _getPriorityColor(wishlist.prioritas),
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(wishlist.prioritas),
                  ],
                ),

                // Delete Button
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
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