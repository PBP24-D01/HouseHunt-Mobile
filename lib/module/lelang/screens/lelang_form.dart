// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:househunt_mobile/module/lelang/main.dart';
import 'package:intl/intl.dart';
import 'package:househunt_mobile/module/lelang/models/available_auction.dart';

class AuctionFormPage extends StatefulWidget {
  final List<AvailableAuction> house;
  final bool isEdit;
  final String? id;
  final String? title;
  final AvailableAuction? editHouse;
  final DateTimeRange? dateTimeRange;
  final int? startingPrice;
  const AuctionFormPage(
      {super.key,
      required this.house,
      this.id,
      this.isEdit = false,
      this.title,
      this.editHouse,
      this.dateTimeRange,
      this.startingPrice});

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
        return Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: child,
            )
          ],
        );
      },
    );

    if (pickedDateRange != null) {
      final TimeOfDay? startTimePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTimeRange?.start ?? pickedDateRange.start,
        ),
      );

      if (startTimePicked != null) {
        final TimeOfDay? endTimePicked = await showTimePicker(
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
            'Tambah Lelang',
            style: TextStyle(
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
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Title",
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    initialValue: widget.title ?? "",
                    onChanged: (String? value) {
                      setState(() {
                        _title = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Title tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: widget.editHouse != null
                          ? widget.editHouse!.title
                          : "Pilih Rumah",
                      labelText: "Rumah",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
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
                    onChanged: (String? newValue) {
                      setState(() {
                        _houseId = newValue!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Rumah tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),

                // Date and Time Range Picker
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Pilih Rentang Waktu Lelang",
                      labelText: "Rentang Waktu Lelang",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDateTimeRange(context),
                      ),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDateTimeRange == null
                          ? ''
                          : '${DateFormat('HH:mm dd-MM-yyyy').format(_selectedDateTimeRange!.start)} '
                              'to ${DateFormat('HH:mm dd-MM-yyyy').format(_selectedDateTimeRange!.end)}',
                    ),
                    validator: (value) {
                      if (_selectedDateTimeRange == null) {
                        return 'Pilih rentang waktu lelang';
                      }
                      if (_selectedDateTimeRange!.end
                          .isBefore(_selectedDateTimeRange!.start)) {
                        return 'Waktu akhir harus setelah waktu mulai';
                      }
                      return null;
                    },
                    onTap: () => _selectDateTimeRange(context),
                  ),
                ),

                // Starting Price Input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Harga Awal Lelang",
                      labelText: "Harga Awal Lelang",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _startingPrice = int.tryParse(value!) ?? 0;
                      });
                    },
                    initialValue: widget.startingPrice?.toString() ?? "",
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Harga Awal Lelang tidak boleh kosong!";
                      } else if (int.tryParse(value) == null) {
                        return "Harga Awal Lelang harus berupa angka!";
                      } else if (int.tryParse(value)! < 0) {
                        return "Harga Awal Lelang tidak boleh kurang dari 0!";
                      }
                      return null;
                    },
                  ),
                ),

                // Submit Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final response = await request.postJson(
                            widget.isEdit ? "http://127.0.0.1:8000/auction/edit/api/${widget.id}/" : "http://127.0.0.1:8000/auction/create/api/",
                            jsonEncode(
                              <String, String>{
                                "title": _title,
                                "house": _houseId,
                                "start_date": _selectedDateTimeRange!.start
                                    .toIso8601String(),
                                "end_date": _selectedDateTimeRange!.end
                                    .toIso8601String(),
                                "starting_price": _startingPrice.toString(),
                              },
                            ),
                          );
                          if (context.mounted) {
                            if (response['status'] == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Lelang baru berhasil disimpan!"),
                              ));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuctionPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(response['message'] ??
                                    "Terdapat kesalahan, silakan coba lagi."),
                              ));
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
