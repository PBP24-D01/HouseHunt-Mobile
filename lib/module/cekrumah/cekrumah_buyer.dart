import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
    final request = context.read<CookieRequest>(); // Access context immediately
    try {
      final response = await request.get('http://127.0.0.1:8000/cekrumah/api/appointments/');
      if (mounted) { // Check if the widget is still mounted before updating state
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
          SnackBar(content: Text('Failed to fetch appointments')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Appointments'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? const Center(
        child: Text("You don't have any appointments"),
      )
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
            DataTable(
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
              rows: appointments.map((appointment) {
                final house = appointment['availability']['house'];
                final seller = appointment['seller']['username'];
                final date =
                appointment['availability']['available_date'];
                final startTime =
                appointment['availability']['start_time'];
                final endTime =
                appointment['availability']['end_time'];
                final status = appointment['status'];
                final notes = appointment['notes_to_seller'] ?? '';

                return DataRow(
                  cells: [
                    DataCell(TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseDetailPage(
                              houseId: house['id'],
                            ),
                          ),
                        );
                      },
                      child: Text(house['name']),
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
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateAppointmentPage(
                                        appointmentId: appointment['id'],
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final response = await request.postJson(
                                'http://127.0.0.1:8000/cekrumah/delete_appointment/${appointment['id']}', "delete"
                              );
                              if (response['success']) {
                                fetchAppointments(); // Refresh data
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAppointmentPage(),
                  ),
                );
              },
              child: const Text('Request New Appointment'),
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
    // Implement house detail page logic
    return Scaffold(
      appBar: AppBar(
        title: const Text('House Detail'),
      ),
      body: Center(
        child: Text('Details for House ID: $houseId'),
      ),
    );
  }
}

class UpdateAppointmentPage extends StatelessWidget {
  final int appointmentId;

  const UpdateAppointmentPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    // Implement update appointment logic
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Appointment'),
      ),
      body: Center(
        child: Text('Update form for Appointment ID: $appointmentId'),
      ),
    );
  }
}

class CreateAppointmentPage extends StatelessWidget {
  const CreateAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement create appointment logic
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Appointment'),
      ),
      body: const Center(
        child: Text('Create New Appointment Form'),
      ),
    );
  }
}
