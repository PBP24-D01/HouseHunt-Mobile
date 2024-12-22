import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/invoice_page.dart';
import 'package:househunt_mobile/module/auth/models/buyer.dart'; // Import Buyer model
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class OrderPage extends StatelessWidget {
  final int houseId;
  final Buyer buyer; // Add Buyer object

  OrderPage({required this.houseId, required this.buyer}); // Update constructor

  Future<Map<String, dynamic>> fetchOrderDetails(BuildContext context) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final url =
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/api/order/$houseId/';
    final response = await request.get(url);

    if (response.containsKey('house')) {
      return response;
    } else {
      throw Exception('Failed to load order details: ${response['error']}');
    }
  }

  Future<void> generateInvoice(BuildContext context) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final invoiceUrl =
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/api/invoice/$houseId/';
    final invoiceResponse = await request.post(invoiceUrl, {});

    if (invoiceResponse.containsKey('house')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoicePage(invoiceDetails: invoiceResponse),
        ),
      );
    } else {
      throw Exception(
          'Failed to generate invoice: ${invoiceResponse['error']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderDetails(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orderDetails = snapshot.data!;
            final house = orderDetails['house'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${house['judul']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Harga: Rp ${house['harga'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lokasi: ${house['lokasi']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Deskripsi: ${house['deskripsi']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kamar Tidur: ${house['kamar_tidur']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kamar Mandi: ${house['kamar_mandi']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Penjual: ${house['penjual']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kontak Penjual: ${house['kontak_penjual']}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        generateInvoice(context);
                      },
                      child: Text('Beli Sekarang'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
