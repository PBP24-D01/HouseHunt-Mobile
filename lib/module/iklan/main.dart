import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/iklan/models/iklan.dart';
import 'package:househunt_mobile/module/rumah/models/house.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class IklanPage extends StatefulWidget {
  const IklanPage({super.key});

  @override
  State<IklanPage> createState() => _IklanPageState();
}

class _IklanPageState extends State<IklanPage> {
  late List<String> _houseList;

  @override
  void initState() {
    super.initState();
    fetchHouseNames(context.read<CookieRequest>());
  }

  Future<void> fetchHouseNames(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/iklan/create/');
      print(response);
      if (response['houses'] != null) {
        _houseList = (response['houses'] as List)
            .map((houseData) => houseData['name'] as String)
            .toList();
      } else {
        _houseList = [];
      }
      print(_houseList);
    } catch (error) {
      print('Error fetching house names: $error');
      _houseList = [];
    }
  }

  Future<List<Iklan>> fetchIklan(CookieRequest request) async {
    final response2 = await request.get('http://127.0.0.1:8000/iklan/json/');
    List<Iklan> iklanList = (response2['iklan'] as List)
        .map((iklanData) => Iklan.fromJson(iklanData))
        .toList();
    return iklanList;
  }

  Future<void> createIklan(CookieRequest request, Iklan iklan) async {
    final response = await request.post(
      'http://127.0.0.1:8000/iklan/create/',
      iklan.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create Iklan');
    }
  }

  Future<void> updateIklan(CookieRequest request, Iklan iklan) async {
    final response = await request.post(
      'http://127.0.0.1:8000/iklan/edit/${iklan.id}/',
      iklan.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update Iklan');
    }
  }

  Future<void> deleteIklan(CookieRequest request, String id) async {
    final response = await request.post(
        'http://127.0.0.1:8000/iklan/delete/$id/', // Ensure this endpoint is correct for deletions
        {} // Pass an empty body if the API does not require any data
        );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete Iklan');
    }
  }

  void showCreateDialog(BuildContext context) {
    String? selectedHouse; // Initialize selectedHouse to null
    DateTime? startDate;
    DateTime? endDate;
    String? bannerFilePath; // Variable to hold the banner file path

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Iklan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // House Selection Dropdown
              DropdownButton<String>(
                value: selectedHouse,
                hint: Text('Select House'),
                items: _houseList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedHouse =
                        newValue; // Update the selectedHouse variable
                  });
                },
              ),
              // Start Date Picker
              TextField(
                readOnly: true,
                decoration: InputDecoration(hintText: 'Select Start Date'),
                onTap: () async {
                  startDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                },
              ),
              // End Date Picker
              TextField(
                readOnly: true,
                decoration: InputDecoration(hintText: 'Select End Date'),
                onTap: () async {
                  endDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 30)),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                },
              ),
              // Banner File Uploader
              TextField(
                readOnly: true,
                decoration: InputDecoration(hintText: 'Upload Banner File'),
                controller: TextEditingController(
                    text: bannerFilePath), // Display the selected file path
                onTap: () async {
                  // Open file picker
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image, // Specify the type of files to pick
                  );

                  if (result != null) {
                    setState(() {
                      bannerFilePath =
                          result.files.single.path; // Get the file path
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Create Iklan logic here using the selected values
                // Example:
                // final newIklan = Iklan(...);
                // createIklan(context.read<CookieRequest>(), newIklan);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the list
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(BuildContext context, Iklan iklan) {
    final titleController = TextEditingController(text: iklan.title);
    final houseUrlController = TextEditingController(text: iklan.houseUrl);
    final houseAddressController =
        TextEditingController(text: iklan.houseAddress);
    final housePriceController =
        TextEditingController(text: iklan.housePrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Iklan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Enter House Title'),
              ),
              TextField(
                controller: houseUrlController,
                decoration: InputDecoration(hintText: 'Enter House URL'),
              ),
              TextField(
                controller: houseAddressController,
                decoration: InputDecoration(hintText: 'Enter House Address'),
              ),
              TextField(
                controller: housePriceController,
                decoration: InputDecoration(hintText: 'Enter House Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedIklan = Iklan(
                  id: iklan.id,
                  title: titleController.text,
                  houseUrl: houseUrlController.text,
                  houseTitle: iklan.houseTitle,
                  houseAddress: houseAddressController.text,
                  houseImageURL: iklan.houseImageURL,
                  housePrice: int.parse(housePriceController.text),
                  startDate: iklan.startDate,
                  endDate: iklan.endDate,
                  seller: iklan.seller,
                  createdAt: iklan.createdAt,
                  updatedAt: DateTime.now(),
                  bannerURL: iklan.bannerURL,
                );
                updateIklan(context.read<CookieRequest>(), updatedIklan);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the list
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
    final response = await request
        .get('https://tristan-agra-househunt.pbp.cs.ui.ac.id/iklan/get-all/');
    var data = response;
    List<Iklan> listIklan = [];
    for (var d in data) {
      if (d != null) {
        listIklan.add(Iklan.fromJson(d));
      }
    }
    return listIklan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iklan List'),
      ),
      drawer: LeftDrawer(), // Assuming you have a DrawerWidget
      body: FutureBuilder<List<Iklan>>(
        future: fetchIklan(context.read<CookieRequest>()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final iklanList = snapshot.data!;
            return ListView.builder(
              itemCount: iklanList.length,
              itemBuilder: (context, index) {
                final iklan = iklanList[index];
                return ListTile(
                  title: Text(iklan.title),
                  subtitle: Text(iklan.houseAddress),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => showEditDialog(context, iklan),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteIklan(context.read<CookieRequest>(), iklan.id);
                          setState(() {}); // Refresh the list
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
