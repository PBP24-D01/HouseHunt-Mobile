import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:househunt_mobile/module/wishlist/models/wishlist.dart';

class WishlistCard extends StatelessWidget {
  final Wishlist wishlist;
  final CookieRequest request;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const WishlistCard({
    Key? key,
    required this.wishlist,
    required this.request,
    required this.onDelete,
    required this.onEdit,
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
                'http://127.0.0.1:8000${wishlist.gambar}',
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
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    wishlist.lokasi,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Price
            Text(
              "Rp${wishlist.harga}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              wishlist.deskripsi,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 8),

            // Bedrooms, Bathrooms, and Seller
            Row(
              children: [
                // Align Bedrooms and Bathrooms to the left
                Expanded(
                  child: Row(
                    children: [
                      _buildIconText(Icons.bed, "${wishlist.kamarTidur}"),
                      const SizedBox(width: 8),
                      _buildIconText(Icons.bathtub, "${wishlist.kamarMandi}"),
                    ],
                  ),
                ),
                // Align Seller to the right
                _buildIconText(Icons.person, wishlist.penjual),
              ],
            ),

            const SizedBox(height: 8),

            // Priority & Notes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: _getPriorityColor(wishlist.prioritas),
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(wishlist.prioritas.capitalize()),
                  ],
                ),
                Expanded(
                  child: Text(
                    wishlist.catatan != null && wishlist.catatan!.isNotEmpty
                      ? wishlist.catatan!
                      : 'No notes',
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit Button
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.black),
                ),
                // Delete Button
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // Confirm delete
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text('Are you sure you want to delete this item from your wishlist?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onDelete(); 
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to display an icon + text in a row
  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Helper to determine priority color
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

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
