import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CekRumahSeller extends StatefulWidget {
  const CekRumahSeller({super.key});

  @override
  _CekRumahSellerState createState() => _CekRumahSellerState();
}

class _CekRumahSellerState extends State<CekRumahSeller> {
  List<dynamic> availabilities = [];
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final request = context.read<CookieRequest>();

    // Fetch availabilities
    final availabilitiesResponse =
    await request.get('http://127.0.0.1:8000/cekrumah/api/availabilities/');
    // Fetch appointments
    final appointmentsResponse =
    await request.get('http://127.0.0.1:8000/cekrumah/api/appointments/');

    if (availabilitiesResponse['success'] || appointmentsResponse['success']) {
      setState(() {
        availabilities = availabilitiesResponse['availabilities'];
        appointments = appointmentsResponse['appointments'];
        isLoading = false;
      });
    } else {
      if (mounted){
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch data. Please try again later.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cek Rumah Seller')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Availability List
              availabilities.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Available Slots',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('House')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Start Time')),
                      DataColumn(label: Text('End Time')),
                      DataColumn(label: Text('Available')),
                      DataColumn(label: Text('Edit')),
                      DataColumn(label: Text('Delete')),
                    ],
                    rows: availabilities.map((availability) {
                      return DataRow(cells: [
                        DataCell(Text(
                            availability['house']['name'] ?? '')),
                        DataCell(Text(
                            availability['available_date'] ?? '')),
                        DataCell(Text(
                            availability['start_time'] ?? '')),
                        DataCell(Text(availability['end_time'] ??
                            '')),
                        DataCell(Text(
                            availability['is_available'] ? 'Yes' : 'No')),
                        DataCell(IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to edit page
                          },
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Delete logic here
                          },
                        )),
                      ]);
                    }).toList(),
                  ),
                ],
              )
                  : Text('You haven\'t created any dates.',
                  textAlign: TextAlign.center),

              SizedBox(height: 20),

              // Appointments List
              appointments.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Appointments',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  DataTable(
                    columns: [
                      DataColumn(label: Text('Buyer')),
                      DataColumn(label: Text('House')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Start Time')),
                      DataColumn(label: Text('End Time')),
                      DataColumn(label: Text('Notes')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: appointments.map((appointment) {
                      final status = appointment['status'];
                      Color statusColor = status == 'Approved'
                          ? Colors.green
                          : status == 'Canceled'
                          ? Colors.red
                          : Colors.orange;

                      return DataRow(cells: [
                        DataCell(Text(
                            appointment['buyer']['username'] ??
                                '')),
                        DataCell(Text(
                            appointment['house']['name'] ??
                                '')),
                        DataCell(Text(
                            appointment['date'] ??
                                '')),
                        DataCell(Text(
                            appointment['start_time'] ??
                                '')),
                        DataCell(Text(
                            appointment['end_time'] ??
                                '')),
                        DataCell(Text(
                            appointment['notes_to_seller'] ?? '')),
                        DataCell(Text(
                          appointment['status'],
                          style: TextStyle(color: statusColor),
                        )),
                        DataCell(ElevatedButton(
                          onPressed: () {
                            // Update status logic here
                          },
                          child: Text('Update Status'),
                        )),
                      ]);
                    }).toList(),
                  ),
                ],
              )
                  : Text('No appointments found.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
