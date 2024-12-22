import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/cekrumah/cekrumah_buyer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  String? selectedHouseId;
  String? selectedAvailabilityId;
  String? notes;
  List<dynamic> houses = [];
  List<dynamic> availabilities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHouses();
  }

  Future<void> fetchHouses() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/cekrumah/api/buyer_houses/');
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
      final response = await request.get('http://127.0.0.1:8000/cekrumah/api/availabilities/$houseId/');
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

  void submitAppointment() async {
    if (selectedAvailabilityId == null || selectedHouseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a house and availability')),
      );
      return;
    }

    final request = context.read<CookieRequest>();
    try {
      final response = await request.postJson(
        'http://127.0.0.1:8000/cekrumah/api/create_appointment/',
        jsonEncode({
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
        const SnackBar(content: Text('Failed to create appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Appointment', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF4A628A), // Consistent color
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              items: houses.map<DropdownMenuItem<String>>((house) {
                return DropdownMenuItem<String>(
                  value: house['id'].toString(),
                  child: Text(house['judul']),
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
              items: availabilities.isEmpty
                  ? [const DropdownMenuItem(value: null, child: Text('No availability slots'))]
                  : availabilities.map<DropdownMenuItem<String>>((availability) {
                return DropdownMenuItem<String>(
                  value: availability['id'].toString(),
                  child: Text('${availability['date']} - ${availability['start_time']} - ${availability['end_time']}'),
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
              onChanged: (value) {
                notes = value;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: submitAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A628A), // Consistent color
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: const Text(
                'Submit Appointment',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
