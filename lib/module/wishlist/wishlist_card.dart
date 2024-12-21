import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/wishlist/models/wishlist.dart';

class WishlistCard extends StatelessWidget {
  final Wishlist wishlist;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const WishlistCard({
    Key? key,
    required this.wishlist,
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
                    Text(
                      wishlist.prioritas.isNotEmpty
                          ? wishlist.prioritas
                          : 'Unknown',
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    wishlist.catatan.isNotEmpty ? wishlist.catatan : 'No notes',
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
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text("Edit"),
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

  // Helper to build icon + text rows
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
