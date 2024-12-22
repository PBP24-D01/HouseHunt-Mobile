import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditHousePage extends StatefulWidget {
  final House house;

  const EditHousePage({Key? key, required this.house}) : super(key: key);

  @override
  _EditHousePageState createState() => _EditHousePageState();
}

class _EditHousePageState extends State<EditHousePage> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  int? price;
  String? location;
  File? imageFile;
  int? bedrooms;
  int? bathrooms;
  bool isAvailable = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    title = widget.house.title;
    description = widget.house.description;
    price = widget.house.price;
    location = widget.house.location;
    bedrooms = widget.house.bedrooms;
    bathrooms = widget.house.bathrooms;
    isAvailable = widget.house.isAvailable;
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> updateHouse() async {
    final url = Uri.parse(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/api/houses/${widget.house.id}/edit/');

    var request = http.MultipartRequest('POST', url);

    var fields = {
      'judul': title!,
      'deskripsi': description!,
      'harga': price.toString(),
      'lokasi': location!,
      'kamar_tidur': bedrooms.toString(),
      'kamar_mandi': bathrooms.toString(),
      'is_available': isAvailable.toString(),
    };

    request.fields.addAll(fields);

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('gambar', imageFile!.path),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('House updated successfully!')),
        );
      } else {
        throw Exception('Failed to update house: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit House'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'House Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: title,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            title = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: description,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            description = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: price.toString(),
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            price = int.tryParse(value!);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: location,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            location = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: pickImage,
                          child: Text('Pick Image'),
                        ),
                        if (imageFile != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.file(imageFile!),
                          ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: bedrooms.toString(),
                          decoration: InputDecoration(
                            labelText: 'Bedrooms',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            bedrooms = int.tryParse(value!);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of bedrooms';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: bathrooms.toString(),
                          decoration: InputDecoration(
                            labelText: 'Bathrooms',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            bathrooms = int.tryParse(value!);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of bathrooms';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          title: Text('Is Available'),
                          value: isAvailable,
                          onChanged: (bool value) {
                            setState(() {
                              isAvailable = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        updateHouse();
                      }
                    },
                    child: Text('Update House'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
