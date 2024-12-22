import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:househunt_mobile/module/lelang/main.dart';
import 'package:househunt_mobile/module/lelang/models/auction.dart';
import 'package:househunt_mobile/module/lelang/models/available_auction.dart';
import 'package:househunt_mobile/module/lelang/screens/lelang_form.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AuctionDetail extends StatefulWidget {
  final String auctionId;
  final String title;

  const AuctionDetail(
      {super.key, required this.auctionId, required this.title});

  @override
  State<AuctionDetail> createState() => _AuctionDetailState();
}

class _AuctionDetailState extends State<AuctionDetail> {
  final _formKey = GlobalKey<FormState>();
  int _bidValue = 0;
  late Future<Auction> _auctionFuture;

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

  Future<Auction> fetchDetailAuction(CookieRequest request) async {
    final response = await request
        .get('http://127.0.0.1:8000/auction/get/${widget.auctionId}/');

    var data = response;

    Auction auction = Auction.fromJson(data);

    return auction;
  }

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _auctionFuture = fetchDetailAuction(request);
  }

  void refreshAuction() {
    setState(() {
      final request = context.read<CookieRequest>();
      _auctionFuture = fetchDetailAuction(request);
    });
  }

  DateTime convertToDateTime(String dateStr) {
    String formattedDateString = dateStr.replaceAllMapped(
        RegExp(r'(\d{2}):(\d{2}):(\d{2}) (\d{2})-(\d{2})-(\d{4})'),
        (match) =>
            '${match[6]}-${match[5]}-${match[4]}T${match[1]}:${match[2]}:${match[3]}');

    return DateTime.parse(formattedDateString);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Lelang Detail",
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder<Auction>(
                future: _auctionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text('No data'),
                    );
                  } else {
                    final auction = snapshot.data;
                    return Column(
                      children: [
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                    child: Text(
                                  auction!.title,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                const SizedBox(height: 12.0),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                  indent: 8.0,
                                  endIndent: 8.0,
                                ),
                                const SizedBox(height: 8.0),
                                Center(
                                  child: Text(
                                    auction.isActive
                                        ? 'Lelang sedang berlangsung'
                                        : auction.isExpired
                                            ? 'Lelang telah berakhir'
                                            : 'Lelang belum dimulai',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: auction.isActive
                                          ? Colors.green
                                          : auction.isExpired
                                              ? Colors.red
                                              : Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Center(
                                  child: TimerCountdown(
                                    endTime: auction.isActive |
                                            auction.isExpired
                                        ? convertToDateTime(auction.endDate)
                                        : convertToDateTime(auction.startDate),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "House Details",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  auction.houseTitle,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Image.network(
                                  'http://127.0.0.1:8000/${auction.houseImage}',
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Location: ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      auction.houseAddress,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Harga Asli: ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Rp ${auction.housePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Seller: ',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      auction.seller,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Auction Information",
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      const Text(
                                        'Highest Bidder: ',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        auction.highestBuyer ??
                                            'No one has bid yet',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Current Bid: IDR: ',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Rp ${auction.currentPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Starting Price: IDR: ',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Rp ${auction.startingPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  if (auction.isActive &&
                                      request.jsonData['is_buyer'])
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Bid Value',
                                              hintText: 'Enter your bid',
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _bidValue =
                                                    int.tryParse(value!) ?? 0;
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Mohon masukkan nilai bid anda';
                                              } else if (int.tryParse(value) ==
                                                  null) {
                                                return 'Nilai bid harus berupa angka';
                                              } else if (int.tryParse(value)! <=
                                                  auction.currentPrice) {
                                                return 'Nilai bid harus lebih tinggi dari bid sebelumnya';
                                              } else if (int.tryParse(value)! <
                                                  auction.startingPrice) {
                                                return 'Nilai bid harus lebih tinggi dari harga awal';
                                              } else if (int.tryParse(value)! %
                                                      1000 !=
                                                  0) {
                                                return 'Nilai bid harus kelipatan 1000';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16.0),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              minimumSize: const Size(
                                                  double.infinity, 50),
                                              backgroundColor: Colors.green,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                            ),
                                            child: const Text('Bid'),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final response =
                                                    await request.postJson(
                                                  "http://127.0.0.1:8000/auction/bid/api/${auction.id}/",
                                                  jsonEncode(
                                                    <String, String>{
                                                      "price":
                                                          _bidValue.toString(),
                                                    },
                                                  ),
                                                );
                                                if (context.mounted) {
                                                  if (response['status'] ==
                                                      true) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          "Bid kamu berhasil ditambahkan!"),
                                                    ));
                                                    refreshAuction();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(response[
                                                              'message'] ??
                                                          "Terdapat kesalahan, silakan coba lagi."),
                                                    ));
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  if ((auction.isExpired ||
                                          !auction.isActive) &&
                                      !request.jsonData['is_buyer'] &&
                                      auction.sellerId ==
                                          request.jsonData['id'].toString())
                                    FutureBuilder<List<AvailableAuction>>(
                                        future: fetchHouses(request),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<
                                                    List<AvailableAuction>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        backgroundColor:
                                                            const Color
                                                                .fromRGBO(
                                                                74, 98, 138, 1),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12.0),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AuctionFormPage(
                                                                    house: snapshot
                                                                            .data ??
                                                                        [],
                                                                    id: auction
                                                                        .id,
                                                                    isEdit:
                                                                        true,
                                                                    title: auction
                                                                        .title,
                                                                    editHouse: AvailableAuction(
                                                                        id: auction
                                                                            .houseId,
                                                                        title: auction
                                                                            .houseTitle),
                                                                    dateTimeRange: DateTimeRange(
                                                                        start: convertToDateTime(auction
                                                                            .startDate),
                                                                        end: convertToDateTime(
                                                                            auction.endDate)),
                                                                    startingPrice:
                                                                        auction
                                                                            .startingPrice,
                                                                  )),
                                                        );
                                                      },
                                                      child: const Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12.0),
                                                      ),
                                                      onPressed: () async {
                                                        final response =
                                                            await request.get(
                                                                "http://127.0.0.1:8000/auction/delete/api/${widget.auctionId}/");

                                                        if (context.mounted) {
                                                          if (response[
                                                                  'status'] ==
                                                              true) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              content: Text(
                                                                  "Lelang berhasil dihapus!"),
                                                            ));
                                                            Navigator.of(
                                                                    context)
                                                                .popUntil((route) =>
                                                                    route
                                                                        .isFirst);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AuctionPage()),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(response[
                                                                      'message'] ??
                                                                  "Terdapat kesalahan, silakan coba lagi."),
                                                            ));
                                                          }
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }),
                                ]),
                          ),
                        ),
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
