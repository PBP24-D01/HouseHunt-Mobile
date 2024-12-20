import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

  Future<void> fetchFormOptions() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/form-options/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        locations = List<String>.from(data['locations']);
        priceRanges = List<String>.from(data['price_ranges']);
        bedroomOptions = List<String>.from(data['bedrooms']);
        bathroomOptions = List<String>.from(data['bathrooms']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load form options.')),
      );
    }
  }

  Future<void> createHouse() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/houses/create/');

    // Create a House instance using the form data
    House newHouse = House(
      id: 0, // Or null if not required
      title: title!,
      description: description!,
      price: price!,
      location: location!,
      bedrooms: bedrooms!,
      bathrooms: bathrooms!,
      isAvailable: isAvailable,
      imageUrl: null, // Handle image separately
    );

    var request = http.MultipartRequest('POST', url);

    // Convert House object to Map<String, String>
    Map<String, String> fields =
        newHouse.toJson().map((key, value) => MapEntry(key, value.toString()));

    // Remove fields not required by the API
    fields.remove('id');
    fields.remove('imageUrl');

    // Add fields to the request
    request.fields.addAll(fields);

    // Add image file if selected
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('gambar', imageFile!.path));
    }

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('House created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create house.')),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.file(imageFile!),
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
