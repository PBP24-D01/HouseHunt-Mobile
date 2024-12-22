import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class CreateHousePage extends StatefulWidget {
  const CreateHousePage({Key? key}) : super(key: key);

  @override
  _CreateHousePageState createState() => _CreateHousePageState();
}

class _CreateHousePageState extends State<CreateHousePage> {
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
  List<String> locations = [];
  List<String> priceRanges = [];
  List<String> bedroomOptions = [];
  List<String> bathroomOptions = [];

  @override
  void initState() {
    super.initState();
    fetchFormOptions();
  }

  // fetch form
  Future<void> fetchFormOptions() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    try {
      final response = await request.get(
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/api/form-options/');
      setState(() {
        locations = List<String>.from(response['locations']);
        priceRanges = List<String>.from(response['price_ranges']);
        bedroomOptions = List<String>.from(response['bedrooms']);
        bathroomOptions = List<String>.from(response['bathrooms']);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load form options: $e')),
      );
    }
  }

  // form
  Future<void> createHouse() async {
    final requestCookie = Provider.of<CookieRequest>(context, listen: false);
    final username = requestCookie.getJsonData()['username'];

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/api/houses/create/'),
    );

    request.fields['username'] = username!;
    request.fields['judul'] = title!;
    request.fields['deskripsi'] = description!;
    request.fields['harga'] = price!.toString();
    request.fields['lokasi'] = location!;
    request.fields['kamar_tidur'] = bedrooms!.toString();
    request.fields['kamar_mandi'] = bathrooms!.toString();
    request.fields['is_available'] = isAvailable.toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'gambar',
          imageFile!.path,
          filename: path.basename(imageFile!.path),
        ),
      );
    }

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final responseData = json.decode(responseBody);
        if (responseData['id'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'House created successfully with ID: ${responseData['id']}')),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Failed to create house');
        }
      } else {
        throw Exception('Failed to create house: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create house: $e')),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create House'),
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
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                          items: locations.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              location = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a location';
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
                          Container(
                            height: 200,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(imageFile!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                        createHouse();
                      }
                    },
                    child: Text('Create House'),
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
