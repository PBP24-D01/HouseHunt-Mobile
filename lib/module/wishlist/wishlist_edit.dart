import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/wishlist/models/wishlist.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditWishlistPage extends StatefulWidget {
  final Wishlist wishlist;
  const EditWishlistPage({Key? key, required this.wishlist}) : super(key: key);

  @override
  _EditWishlistPageState createState() => _EditWishlistPageState();
}

class _EditWishlistPageState extends State<EditWishlistPage> {
  final _formKey = GlobalKey<FormState>();
  late String priority;
  late String notes;

  @override
  void initState() {
    super.initState();
    priority = widget.wishlist.prioritas;
    notes = widget.wishlist.catatan ?? '';
  }

  Future<void> _saveWishlist(CookieRequest request) async {
    final url =
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/wishlist/edit-flutter/${widget.wishlist.rumahId}/';
    final response = await request.post(url, {
      'priority': priority,
      'notes': notes,
    });

    if (response['status'] == 'success') {
      try {
        setState(() {
          widget.wishlist.prioritas = priority;
          widget.wishlist.catatan = notes;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wishlist updated successfully.')),
        );

        Navigator.pop(context, true); // Signal success to the previous page
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating wishlist: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Wishlist'),
        backgroundColor: const Color(0xFF4A628A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the wishlist page
          },
        ),
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Displaying all the information from the WishlistCard
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'http://127.0.0.1:8000${widget.wishlist.gambar}',
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
                widget.wishlist.judul,
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
                      widget.wishlist.lokasi,
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
                "Rp${widget.wishlist.harga}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                widget.wishlist.deskripsi,
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
                        _buildIconText(
                            Icons.bed, "${widget.wishlist.kamarTidur}"),
                        const SizedBox(width: 8),
                        _buildIconText(
                            Icons.bathtub, "${widget.wishlist.kamarMandi}"),
                      ],
                    ),
                  ),
                  // Align Seller to the right
                  _buildIconText(Icons.person, widget.wishlist.penjual),
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
                        color: _getPriorityColor(widget.wishlist.prioritas),
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(widget.wishlist.prioritas.capitalize()),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      widget.wishlist.catatan != null &&
                              widget.wishlist.catatan!.isNotEmpty
                          ? widget.wishlist.catatan!
                          : 'No notes',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black45),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Dropdown for Priority
              DropdownButtonFormField<String>(
                value: priority,
                onChanged: (newValue) {
                  setState(() {
                    priority = newValue!;
                  });
                },
                items: ['high', 'medium', 'low'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalize()),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Notes TextField
              TextFormField(
                initialValue: notes,
                onChanged: (value) {
                  notes = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),

              const SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveWishlist(request);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A628A),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
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
