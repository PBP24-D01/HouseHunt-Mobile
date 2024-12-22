import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/lelang/models/auction.dart';
import 'package:househunt_mobile/module/lelang/models/available_auction.dart';
import 'package:househunt_mobile/module/lelang/screens/detail.dart';
import 'package:househunt_mobile/module/lelang/screens/lelang_form.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage>
    with TickerProviderStateMixin {
  late Future<List<AvailableAuction>> _availableAuctionFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _availableAuctionFuture = fetchHouses(request);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<AvailableAuction>> fetchHouses(CookieRequest request) async {
    final response = await request.get(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/auction/available-houses/');
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
    final response = await request
        .get('https://tristan-agra-househunt.pbp.cs.ui.ac.id/auction/get-all/');
    var data = response;
    List<Auction> listAuction = [];
    for (var d in data) {
      if (d != null) {
        listAuction.add(Auction.fromJson(d));
      }
    }
    return listAuction;
  }

  DateTime convertToDateTime(String strDatetime) {
    String formattedDateString = strDatetime.replaceAllMapped(
        RegExp(r'(\d{2}):(\d{2}):(\d{2}) (\d{2})-(\d{2})-(\d{4})'),
        (match) =>
            '${match[6]}-${match[5]}-${match[4]}T${match[1]}:${match[2]}:${match[3]}');
    return DateTime.parse(formattedDateString);
  }

  Widget _buildAuctionList(List<Auction> auctions, bool showActive) {
    final filteredAuctions =
        auctions.where((auction) => auction.isActive == showActive).toList();

    if (filteredAuctions.isEmpty) {
      return Center(
        child: Text(
          showActive ? 'No active auctions' : 'No inactive auctions',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredAuctions.length,
      itemBuilder: (context, index) {
        final auction = filteredAuctions[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    'https://tristan-agra-househunt.pbp.cs.ui.ac.id${auction.houseImage}',
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
                    auction.highestBuyer ?? 'Belum ada bidder',
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
                  const SizedBox(height: 8.0),
                  const Divider(
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
                      endTime: auction.isActive || auction.isExpired
                          ? convertToDateTime(auction.endDate)
                          : convertToDateTime(auction.startDate),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuctionDetail(
                            auctionId: auction.id,
                            title: auction.title,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    bool isBuyer = request.jsonData['is_buyer'] ?? false;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lelang',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color.fromRGBO(74, 98, 138, 1)),
          foregroundColor: Color.fromRGBO(74, 98, 138, 1),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Lelang berlangsung'),
              Tab(text: 'Lelang lainnya'),
            ],
            labelColor: Color.fromRGBO(74, 98, 138, 1),
            unselectedLabelColor: Color.fromRGBO(74, 98, 138, 0.7),
            indicatorColor: Color.fromRGBO(74, 98, 138, 1),
            dividerColor: const Color.fromARGB(127, 196, 195, 195),
          ),
        ),
        drawer: const LeftDrawer(),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
        floatingActionButton: !isBuyer
            ? FutureBuilder<List<AvailableAuction>>(
                future: _availableAuctionFuture,
                builder: (context, snapshot) {
                  return FloatingActionButton(
                    onPressed: () {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuctionFormPage(
                              house: snapshot.data!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No house available for auction'),
                          ),
                        );
                      }
                    },
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                    child: const Icon(Icons.add),
                  );
                },
              )
            : null,
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<Auction>>(
                  future: fetchAuction(request),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No auctions available'));
                    }
                    return _buildAuctionList(snapshot.data!, true);
                  },
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<Auction>>(
                  future: fetchAuction(request),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No auctions available'));
                    }
                    return _buildAuctionList(snapshot.data!, false);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
