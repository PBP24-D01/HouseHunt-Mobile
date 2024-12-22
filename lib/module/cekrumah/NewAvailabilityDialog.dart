import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/cekrumah/models/availability.dart';
import 'package:provider/provider.dart'; // Untuk API requests
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Untuk cookie session API

class NewAvailabilityDialog extends StatefulWidget {
  final Map<String, dynamic>? existingAvailability;

  const NewAvailabilityDialog({Key? key, this.existingAvailability}) : super(key: key);

  @override
  _NewAvailabilityDialogState createState() => _NewAvailabilityDialogState();
}

class _NewAvailabilityDialogState extends State<NewAvailabilityDialog> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _houses = []; // Daftar rumah sebagai Map
  int? _selectedHouseId;
  DateTime? _availableDate;
  String? _startTime;
  String? _endTime;
  bool _isLoading = true;
  TextEditingController _availableDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // print(widget.existingAvailability);
    if (widget.existingAvailability != null) {
      // print("DO I ENTER THIS?");
      _selectedHouseId = widget.existingAvailability!['house']['id'];
      _availableDate = DateTime.parse(widget.existingAvailability!['available_date']);
      _startTime = widget.existingAvailability!['start_time'];
      _endTime = widget.existingAvailability!['end_time'];
      // print("Available Date Controller : $_availableDate");

      // Manually set the initial text for controllers
      _availableDateController.text = _availableDate != null
          ? _availableDate!.toIso8601String().substring(0, 10) // Format 'yyyy-MM-dd'
          : '';
      _startTimeController.text = _startTime ?? '';
      _endTimeController.text = _endTime ?? '';
      // print("Available Date Controller Text: ${_availableDateController.text}");
      // print("Start Time Controller Text: ${_startTimeController.text}");
      // print("End Time Controller Text: ${_endTimeController.text}");
    }

    _fetchHouses();
    // print("Available Date Controller Text: ${_availableDateController.text}");
    // print("Start Time Controller Text: ${_startTimeController.text}");
    // print("End Time Controller Text: ${_endTimeController.text}");

  }

  Future<void> _fetchHouses() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/cekrumah/api/seller_houses/');

    if (response != null && response['houses'] != null) {
      setState(() {
        _houses = List<Map<String, dynamic>>.from(response['houses']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _houses = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingAvailability != null ? 'Edit Availability' : 'New Availability'),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown untuk memilih rumah
            DropdownButtonFormField<int>(
              value: _selectedHouseId,
              items: _houses.map((house) {
                return DropdownMenuItem<int>(
                  value: house['id'],
                  child: Text("${house['id']}. "+house['judul']),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedHouseId = value),
              decoration: InputDecoration(labelText: 'House'),
              validator: (value) =>
              value == null ? 'Please select a house' : null,
            ),


            TextFormField(
              decoration: InputDecoration(labelText: 'Available Date'),
              readOnly: true, // Prevent manual text input
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _availableDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _availableDate) {
                  setState(() {
                    _availableDate = pickedDate;
                    _availableDateController.text = _availableDate!.toIso8601String().substring(0, 10);
                  });
                }
              },
              controller: _availableDateController,
            ),


            TextFormField(
              decoration: InputDecoration(labelText: 'Start Time'),
              readOnly: true, // Prevent manual text input
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _startTime != null
                      ? TimeOfDay(hour: int.parse(_startTime!.split(':')[0]), minute: int.parse(_startTime!.split(':')[1]))
                      : TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _startTime = pickedTime.format(context);
                    _startTimeController.text = _startTime!;// Format the time as HH:mm
                  });
                }
              },
              controller: _startTimeController,
            ),



            TextFormField(
              decoration: InputDecoration(labelText: 'Start Time'),
              readOnly: true, // Prevent manual text input
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _endTime != null
                      ? TimeOfDay(hour: int.parse(_endTime!.split(':')[0]), minute: int.parse(_endTime!.split(':')[1]))
                      : TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _endTime = pickedTime.format(context);
                    _endTimeController.text = _endTime!;// Format the time as HH:mm
                  });
                }
              },
              controller: _endTimeController,
            ),



          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState!.save();
              final newAvailability = Availability(id: 0,
                  sellerId: 0,
                  houseId: _selectedHouseId!,
                  availableDate: _availableDate!,
                  startTime: _startTime!,
                  endTime: _endTime!);
              Navigator.of(context).pop(newAvailability);
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
