import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  final Map<String, dynamic> invoiceDetails;

  InvoicePage({required this.invoiceDetails});

  @override
  Widget build(BuildContext context) {
    final house = invoiceDetails['house'];
    final buyer = invoiceDetails['buyer'];
    final totalPrice = invoiceDetails['total_price'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Page'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Invoice for ${house['judul']}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Harga: Rp ${house['harga'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'House Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Divider(thickness: 2),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.blue),
                    title: Text('Lokasi'),
                    subtitle: Text(house['lokasi']),
                  ),
                  ListTile(
                    leading: Icon(Icons.description, color: Colors.blue),
                    title: Text('Deskripsi'),
                    subtitle: Text(house['deskripsi']),
                  ),
                  ListTile(
                    leading: Icon(Icons.bed, color: Colors.blue),
                    title: Text('Kamar Tidur'),
                    subtitle: Text('${house['kamar_tidur']}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.bathroom, color: Colors.blue),
                    title: Text('Kamar Mandi'),
                    subtitle: Text('${house['kamar_mandi']}'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Seller Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Divider(thickness: 2),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text('Penjual'),
                    subtitle: Text(house['seller']['username']),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.blue),
                    title: Text('Kontak Penjual'),
                    subtitle: Text(house['seller']['email']),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Buyer Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Divider(thickness: 2),
                  ListTile(
                    leading: Icon(Icons.person_outline, color: Colors.blue),
                    title: Text('Nama'),
                    subtitle: Text(buyer['username']),
                  ),
                  ListTile(
                    leading: Icon(Icons.email_outlined, color: Colors.blue),
                    title: Text('Email'),
                    subtitle: Text(buyer['email']),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[900],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          // no clue what this does
                          'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
