import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/house_details.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../rumah/models/house.dart';
import 'CreateAppointmentPage.dart';
import 'UpdateAppointmentPage.dart';

class CekRumahBuyer extends StatefulWidget {
  const CekRumahBuyer({super.key});

  @override
  State<CekRumahBuyer> createState() => _CekRumahBuyerState();
}

class _CekRumahBuyerState extends State<CekRumahBuyer> {
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/cekrumah/api/appointments/buyer/');
      if (mounted) {
        setState(() {
          if (response['success']) {
            appointments = response['appointments'];
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch appointments')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Appointments',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        foregroundColor: Color.fromRGBO(74, 98, 138, 1),
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
              ? Center(
                  child: Column(children: [
                  const Text("You don't have any appointments"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAppointmentPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A628A),
                    ),
                    child: const Text(
                      'Request New Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Appointments',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                        // Added horizontal scroll
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xFF4A628A),
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: const [
                            DataColumn(label: Text('House')),
                            DataColumn(label: Text('Seller')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Start Time')),
                            DataColumn(label: Text('End Time')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Notes')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: appointments.asMap().entries.map((entry) {
                            final index = entry.key;
                            final appointment = entry.value;
                            final house = appointment['house']['judul'];
                            final seller = appointment['seller']['username'];
                            final date = appointment['date'];
                            final startTime = appointment['start_time'];
                            final endTime = appointment['end_time'];
                            final status = appointment['status'];
                            final notes = appointment['notes_to_seller'] ?? '';
                            final appointmentId = appointment['id'].toString();

                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                (states) => index % 2 == 0
                                    ? Colors.grey.shade200
                                    : Colors.white,
                              ),
                              cells: [
                                DataCell(TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HouseDetailsPage(
                                          house: House.fromJson(
                                              appointment['house']),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(house),
                                )),
                                DataCell(Text(seller)),
                                DataCell(Text(date)),
                                DataCell(Text(startTime)),
                                DataCell(Text(endTime)),
                                DataCell(
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: status == 'Approved'
                                          ? Colors.green
                                          : status == 'Canceled'
                                              ? Colors.red
                                              : Colors.orange,
                                    ),
                                  ),
                                ),
                                DataCell(Text(notes)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateAppointmentPage(
                                                appointmentId: appointmentId,
                                                appointmentData: appointment,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          final request =
                                              context.read<CookieRequest>();
                                          final response =
                                              await request.postJson(
                                            'https://tristan-agra-househunt.pbp.cs.ui.ac.id/cekrumah/api/delete_appointment/${appointment['id']}/',
                                            jsonEncode({'key': 'value'}),
                                          );
                                          if (response['success']) {
                                            setState(() {
                                              appointments.remove(appointment);
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      response['message'])),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAppointmentPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A628A),
                        ),
                        child: const Text(
                          'Request New Appointment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class HouseDetailPage extends StatelessWidget {
  final int houseId;

  const HouseDetailPage({super.key, required this.houseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('House Detail'),
        backgroundColor: const Color(0xFF4A628A),
      ),
      body: Center(
        child: Text('Details for House ID: $houseId'),
      ),
    );
  }
}
