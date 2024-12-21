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
        'http://127.0.0.1:8000/wishlist/edit-flutter/${widget.wishlist.rumahId}/';
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
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
