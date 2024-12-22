import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/iklan/models/iklan.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class IklanPage extends StatefulWidget {
  const IklanPage({super.key});

  @override
  State<IklanPage> createState() => _IklanPageState();
}

class _IklanPageState extends State<IklanPage> {
  Future<List<Iklan>> fetchIklan(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/iklan/get-all/');
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
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Use this to make the content scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Iklan>>(
                future: fetchIklan(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No Auction available'),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Auction',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final iklan = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          iklan.houseTitle,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            //Navigator.push(
                                            //  context,
                                            //  MaterialPageRoute(
                                            //    builder: (context) =>
                                            //        DetailProductPage(
                                            //            keyboard: keyboard),
                                            //  ),
                                            //);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.amber, // Button color
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                          ),
                                          child: const Text(
                                            'Detail',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ), // Add spacing between sections
            ],
          ),
        ),
      ),
    );
  }
}