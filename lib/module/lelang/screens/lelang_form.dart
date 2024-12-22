import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:househunt_mobile/module/lelang/main.dart';
import 'package:househunt_mobile/module/lelang/models/available_auction.dart';

class AuctionFormPage extends StatefulWidget {
  final List<AvailableAuction> house;
  final bool isEdit;
  final String? id;
  final String? title;
  final AvailableAuction? editHouse;
  final DateTimeRange? dateTimeRange;
  final int? startingPrice;

  const AuctionFormPage({
    super.key,
    required this.house,
    this.id,
    this.isEdit = false,
    this.title,
    this.editHouse,
    this.dateTimeRange,
    this.startingPrice,
  });

  @override
  State<AuctionFormPage> createState() => _AuctionFormPageState();
}

class _AuctionFormPageState extends State<AuctionFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _houseId = "";
  DateTimeRange? _selectedDateTimeRange;
  int _startingPrice = 0;

  Future<void> _selectDateTimeRange(BuildContext context) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      initialDateRange: widget.dateTimeRange ?? _selectedDateTimeRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      final TimeOfDay? startTimePicked = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTimeRange?.start ?? pickedDateRange.start,
        ),
      );

      if (startTimePicked != null) {
        final TimeOfDay? endTimePicked = await showTimePicker(
          // ignore: use_build_context_synchronously
          context: context,
          initialTime: TimeOfDay.fromDateTime(
            _selectedDateTimeRange?.end ?? pickedDateRange.end,
          ),
        );

        if (endTimePicked != null) {
          final startDateTime = DateTime(
            pickedDateRange.start.year,
            pickedDateRange.start.month,
            pickedDateRange.start.day,
            startTimePicked.hour,
            startTimePicked.minute,
          );

          final endDateTime = DateTime(
            pickedDateRange.end.year,
            pickedDateRange.end.month,
            pickedDateRange.end.day,
            endTimePicked.hour,
            endTimePicked.minute,
          );

          setState(() {
            _selectedDateTimeRange = DateTimeRange(
              start: startDateTime,
              end: endDateTime,
            );
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Lelang' : 'Tambah Lelang',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromRGBO(74, 98, 138, 1),
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title Input
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Enter auction title",
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        initialValue: widget.title ?? "",
                        onChanged: (value) => setState(() => _title = value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // House Selection
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Rumah",
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: (widget.house +
                                (widget.editHouse != null
                                    ? [widget.editHouse!]
                                    : []))
                            .map((house) {
                          return DropdownMenuItem<String>(
                            value: house.id,
                            child: Text(house.title),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _houseId = value!),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Rumah tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date Range Selection
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Rentang Waktu Lelang",
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: _selectedDateTimeRange == null
                              ? ''
                              : '${DateFormat('HH:mm dd-MM-yyyy').format(_selectedDateTimeRange!.start)} to '
                                  '${DateFormat('HH:mm dd-MM-yyyy').format(_selectedDateTimeRange!.end)}',
                        ),
                        onTap: () => _selectDateTimeRange(context),
                        validator: (value) {
                          if (_selectedDateTimeRange == null) {
                            return 'Pilih rentang waktu lelang';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Starting Price
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Harga Awal Lelang",
                          prefixIcon: const Icon(Icons.monetization_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: widget.startingPrice?.toString() ?? "",
                        onChanged: (value) => setState(
                            () => _startingPrice = int.tryParse(value) ?? 0),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Harga Awal Lelang tidak boleh kosong!";
                          }
                          if (int.tryParse(value) == null) {
                            return "Harga Awal Lelang harus berupa angka!";
                          }
                          if (int.tryParse(value)! < 0) {
                            return "Harga Awal Lelang tidak boleh kurang dari 0!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await request.postJson(
                              widget.isEdit
                                  ? "https://tristan-agra-househunt.pbp.cs.ui.ac.id/auction/edit/api/${widget.id}/"
                                  : "https://tristan-agra-househunt.pbp.cs.ui.ac.id/auction/create/api/",
                              jsonEncode({
                                "title": _title,
                                "house": _houseId,
                                "start_date": _selectedDateTimeRange!.start
                                    .toIso8601String(),
                                "end_date": _selectedDateTimeRange!.end
                                    .toIso8601String(),
                                "starting_price": _startingPrice.toString(),
                              }),
                            );

                            if (context.mounted) {
                              if (response['status'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Lelang berhasil disimpan!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuctionPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response['message'] ??
                                        "Terdapat kesalahan, silakan coba lagi."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
