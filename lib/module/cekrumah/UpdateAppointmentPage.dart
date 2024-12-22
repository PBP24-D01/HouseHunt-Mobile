import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/cekrumah/cekrumah_buyer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class UpdateAppointmentPage extends StatefulWidget {
  final String appointmentId;
  final Map<String, dynamic> appointmentData;

  const UpdateAppointmentPage(
      {super.key, required this.appointmentId, required this.appointmentData});

  @override
  State<UpdateAppointmentPage> createState() => _UpdateAppointmentPageState();
}

class _UpdateAppointmentPageState extends State<UpdateAppointmentPage> {
  String? selectedHouseId;
  String? selectedAvailabilityId;
  String? notes;
  List<dynamic> houses = [];
  List<dynamic> availabilities = [];
  bool isLoading = true;
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedHouseId = widget.appointmentData['house']['id'].toString();
    notes = widget.appointmentData['notes_to_seller'];
    notesController.text = notes ?? '';
    fetchHouses();
    fetchAvailabilities(selectedHouseId!);
  }

  Future<void> fetchHouses() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/cekrumah/api/buyer_houses/');
      if (mounted) {
        setState(() {
          houses = response['houses'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch houses')),
      );
    }
  }

  Future<void> fetchAvailabilities(String houseId) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/cekrumah/api/availabilities/$houseId/');
      if (mounted) {
        setState(() {
          availabilities = response['availabilities'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch availabilities')),
      );
    }
  }

  void updateAppointment() async {
    if (selectedAvailabilityId == null || selectedHouseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a house and availability')),
      );
      return;
    }

    final request = context.read<CookieRequest>();
    try {
      final response = await request.postJson(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/cekrumah/api/update_appointment/${widget.appointmentId}/',
        jsonEncode({
          'appointment_id': widget.appointmentId,
          'availability_id': selectedAvailabilityId,
          'house_id': selectedHouseId,
          'notes': notes ?? '',
        }),
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        Navigator.pop(context); // Navigate back on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CekRumahBuyer()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A628A);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Appointment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        foregroundColor: Color.fromRGBO(74, 98, 138, 1),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select House',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedHouseId,
                    hint: const Text('Choose a house'),
                    isExpanded: true,
                    style: const TextStyle(color: primaryColor),
                    items: houses.map<DropdownMenuItem<String>>((house) {
                      return DropdownMenuItem<String>(
                        value: house['id'].toString(),
                        child: Text("${house['id']}. ${house['judul']} "),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHouseId = value;
                        selectedAvailabilityId = null;
                        availabilities = [];
                      });
                      if (value != null) {
                        fetchAvailabilities(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Select Availability',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedAvailabilityId,
                    hint: const Text('Choose availability'),
                    isExpanded: true,
                    style: const TextStyle(color: primaryColor),
                    items: availabilities.isEmpty
                        ? [
                            const DropdownMenuItem(
                                value: null,
                                child: Text('No availability slots'))
                          ]
                        : availabilities
                            .map<DropdownMenuItem<String>>((availability) {
                            return DropdownMenuItem<String>(
                              value: availability['id'].toString(),
                              child: Text(
                                  '${availability['date']} - ${availability['start_time']} - ${availability['end_time']}'),
                            );
                          }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAvailabilityId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Notes to Seller (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter any notes...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    controller: notesController,
                    onChanged: (value) {
                      notes = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: updateAppointment,
                    child: const Text(
                      'Update Appointment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
