import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/lelang/models/auction.dart';
import 'package:househunt_mobile/module/lelang/models/available_auction.dart';
import 'package:househunt_mobile/module/lelang/screens/detail.dart';
import 'package:househunt_mobile/module/lelang/screens/lelang_form.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  Future<List<AvailableAuction>> fetchHouses(CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/auction/available-houses/');

    var data = response;

    List<AvailableAuction> houses = [];
    for (var house in data) {
      if (house != null) {
        houses.add(AvailableAuction.fromJson(house));
      }
    }
    return houses;
  }

  Future<List<Auction>> fetchAuction(CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/auction/get-all/');

    var data = response;

    List<Auction> listAuction = [];
    for (var d in data) {
      if (d != null) {
        listAuction.add(Auction.fromJson(d));
      }
    }
    return listAuction;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    bool isBuyer = request.jsonData['is_buyer'] ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lelang',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Auction>>(
                future: fetchAuction(request),
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
                        const Center(
                          child: Text(
                            'Lelang Tersedia',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        if (!isBuyer)
                          FutureBuilder<List<AvailableAuction>>(
                              future: fetchHouses(request),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AvailableAuction>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text('No houses available');
                                } else {
                                  return ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuctionFormPage(
                                                        house: snapshot.data ??
                                                            [])));
                                      },
                                      child: Text('Tambah Lelang'));
                                }
                              }),
                        const SizedBox(height: 12.0),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final auction = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        auction.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        auction.houseTitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Image.network(
                                        'http://127.0.0.1:8000/${auction.houseImage}',
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Real Price:',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Rp ${auction.housePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const Text(
                                        'Highest Bidder:',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        auction.highestBuyer ??
                                            'Belum ada bidder',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      const Text(
                                        'Current Price:',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Rp ${auction.currentPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Start Date:\n${auction.startDate}',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'End Date:\n${auction.endDate}',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuctionDetail(
                                                  auctionId: auction.id,
                                                  title: auction.title,
                                                ),
                                              ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          backgroundColor: const Color.fromRGBO(
                                              74, 98, 138, 1),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                        ),
                                        child: const Text(
                                          'Detail',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
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
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
