import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/cekrumah/models/availability.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'NewAvailabilityDialog.dart';

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
      if (mounted) {
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
      appBar: AppBar(
        title: Text('Cek Rumah Seller', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF4A628A), // Primary color applied
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final availability = await showDialog<Availability>(
                    context: context,
                    builder: (context) => NewAvailabilityDialog(),
                  );

                  if (availability != null) {
                    await createAvailability(availability);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A628A), // Primary color applied
                ),
                child: Text('Add Availability', style: TextStyle(color: Colors.white),),
              ),

              // Availability List
              availabilities.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Available Slots',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
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
                          DataCell(Text(availability['end_time'] ?? '')),
                          DataCell(Text(availability['is_available']
                              ? 'Yes'
                              : 'No')),
                          DataCell(IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final updatedAvailability =
                              await showDialog<Availability>(
                                context: context,
                                builder: (context) =>
                                    NewAvailabilityDialog(
                                      existingAvailability: availability,
                                    ),
                              );

                              if (updatedAvailability != null) {
                                await updateAvailability(
                                    availability['id'],
                                    updatedAvailability);
                              }
                            },
                          )),
                          DataCell(IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteAvailability(availability['id']);
                            },
                          )),
                        ]);
                      }).toList(),
                    ),
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
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
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
                              appointment['buyer']['username'] ?? '')),
                          DataCell(Text(
                              appointment['house']['name'] ?? '')),
                          DataCell(Text(appointment['date'] ?? '')),
                          DataCell(Text(appointment['start_time'] ?? '')),
                          DataCell(Text(appointment['end_time'] ?? '')),
                          DataCell(Text(appointment['notes_to_seller'] ?? '')),
                          DataCell(Text(
                            appointment['status'],
                            style: TextStyle(color: statusColor),
                          )),
                          DataCell(ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Update Status'),
                                  content: DropdownButton<String>(
                                    value: appointment['status'],
                                    items: ['Pending', 'Approved', 'Canceled']
                                        .map((status) =>
                                        DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ))
                                        .toList(),
                                    onChanged: (newStatus) async {
                                      if (newStatus != null) {
                                        await updateAppointmentStatus(
                                            appointment['id'], newStatus);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Text('Update Status', style: TextStyle(color: Colors.black),),
                          )),
                        ]);
                      }).toList(),
                    ),
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

  // The backend methods below are untouched

  Future<void> deleteAvailability(int availabilityId) async {
    final request = context.read<CookieRequest>();
    final Map<String, dynamic> data = {
      'id': availabilityId,
    };

    final response = await request.post(
      'http://127.0.0.1:8000/cekrumah/api/availability/delete/',
      jsonEncode(data),
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Availability deleted successfully')),
      );
      await fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete availability')),
      );
    }
  }

  Future<void> updateAvailability(int availabilityId, Availability updatedAvailability) async {
    final request = context.read<CookieRequest>();

    final Map<String, dynamic> data = updatedAvailability.toJson();
    data['id'] = availabilityId;

    final response = await request.post(
      'http://127.0.0.1:8000/cekrumah/api/availability/update/',
      jsonEncode(data),
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Availability updated successfully')),
      );
      await fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update availability')),
      );
    }
  }

  Future<void> createAvailability(Availability availability) async {
    final request = context.read<CookieRequest>();
    final response = await request.post(
      'http://127.0.0.1:8000/cekrumah/api/create_availability/',
      jsonEncode(availability.toJson()),
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Availability added successfully')),
      );
      await fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add availability')),
      );
    }
  }

  Future<void> updateAppointmentStatus(int appointmentId, String newStatus) async {
    final request = context.read<CookieRequest>();
    final Map<String, dynamic> data = {
      'id': appointmentId,
      'status': newStatus,
    };

    final response = await request.post(
      'http://127.0.0.1:8000/cekrumah/api/update_appointment_status/',
      jsonEncode(data),
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated successfully')),
      );
      await fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: ${response["message"]}')),
      );
    }
  }
}
