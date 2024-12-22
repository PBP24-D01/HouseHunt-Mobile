import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:househunt_mobile/module/diskusi/comment.dart';
import 'package:househunt_mobile/module/diskusi/models/show_seller.dart'; // Import the show_seller.dart file
import 'package:househunt_mobile/widgets/drawer.dart'; // Import the LeftDrawer

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});
  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
    late Future<List<ShowSeller>> _sellersFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _sellersFuture = fetchSellers(request);
  }

  void _refreshSellers() {
    setState(() {
      final request = context.read<CookieRequest>();
      _sellersFuture = fetchSellers(request);
    });
  }

  Future<List<ShowSeller>> fetchSellers(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/diskusi/show_sellers');
      
      if (response is List) {
        // If response is already a List, convert each item to ShowSeller
        return response.map((item) => ShowSeller.fromJson(item)).toList();
      } else {
        throw Exception('Response is not a List');
      }
    } catch (e) {
      throw Exception('Failed to load sellers: $e');
    }
  }

Future<Map<String, dynamic>?> getSellerById(CookieRequest request, String companyName) async {
  try {
    final sellers = await fetchSellers(request);
    // Find seller with matching company name
    final matchingSeller = sellers.firstWhere(
      (seller) => seller.fields.companyName == companyName,
    );

    if (matchingSeller.pk != 0) {
      return {
        'pk': matchingSeller.pk,
        'id': matchingSeller.pk,
        'company_name': matchingSeller.fields.companyName,
      };
    }
    ('No matching seller found for: $companyName');
    return null;
  } catch (e) {
    ('Error in getSellerById: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussion',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<ShowSeller>>(
        future: _sellersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sellers available'));
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final seller = snapshot.data![index];
                return SellerCard(
                  name: seller.fields.companyName,
                  rating: seller.fields.stars.toString(),
                  sellerId: seller.pk,
                );
              },
            ),
            );
          }
        },
      ),
      floatingActionButton: (!request.jsonData['is_buyer'] && request.loggedIn) 
      ? FloatingActionButton(
          onPressed: () async {
            final seller = await getSellerById(request, request.jsonData['company_name']);
            (seller);
            if (seller != null) {
            (seller['pk']);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentPage(
                    id: seller['id'],
                    companyName: request.jsonData['company_name'],
                  ),
                ),
              ).then((_) => _refreshSellers());
            }
          },
          child: const Icon(Icons.rate_review),
          backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
        )
      : null,
    );
  }
}

class SellerCard extends StatelessWidget {
  final String name;
  final String rating;
  final int sellerId;

  const SellerCard({
    super.key,
    required this.name,
    required this.rating,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFDCF2F1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      rating,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star, color: Colors.yellow[600], size: 16),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentPage(id: sellerId,companyName: name),
                  )
                ).then((_) {
                  final state = context.findAncestorStateOfType<_DiscussionPageState>();
                  state?._refreshSellers();
                });
              },
              child: const Text(
                'review',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
