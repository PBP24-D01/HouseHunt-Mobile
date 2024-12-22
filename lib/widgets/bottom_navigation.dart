import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/auth/login.dart';
import 'package:househunt_mobile/module/auth/register_buyer.dart';
import 'package:househunt_mobile/module/auth/register_seller.dart';
import 'package:househunt_mobile/module/cekrumah/cekrumah_buyer.dart';
import 'package:househunt_mobile/module/cekrumah/cekrumah_seller.dart';
import 'package:househunt_mobile/module/diskusi/main.dart';
import 'package:househunt_mobile/module/iklan/main.dart';
import 'package:househunt_mobile/module/lelang/main.dart';
import 'package:househunt_mobile/module/rumah/main.dart';
import 'package:househunt_mobile/module/wishlist/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    bool isAuthenticated = request.loggedIn;
    bool isBuyer = request.jsonData['is_buyer'] ?? false;

    _pages = isAuthenticated
        ? [
            AuctionPage(),
            DiscussionPage(),
            HomePage(),
            isBuyer ? WishlistPage() : IklanPage(),
            isBuyer ? CekRumahBuyer() : CekRumahSeller(),
          ]
        : [
            LoginPage(),
            HomePage(),
            RegisterBuyerPage(),
            RegisterSellerPage(),
          ];
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    bool isAuthenticated = request.loggedIn;
    bool isBuyer = request.jsonData['is_buyer'] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => _pages[index]));
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromRGBO(74, 98, 138, 1),
        unselectedItemColor: Colors.grey,
        items: isAuthenticated
            ? [
                _buildNavItem(Icons.gavel, 'Lelang', 0),
                _buildNavItem(Icons.forum, 'Diskusi', 1),
                _buildNavItem(Icons.home, 'Home', 2),
                isBuyer
                    ? _buildNavItem(Icons.favorite, 'Wishlist', 3)
                    : _buildNavItem(Icons.campaign, 'Iklan', 3),
                _buildNavItem(Icons.calendar_today, 'Cek Rumah', 4),
              ]
            : [
                _buildNavItem(Icons.login, 'Login', 0),
                _buildNavItem(Icons.home, 'Home', 1),
                _buildNavItem(Icons.person_add, 'Register Buyer', 2),
                _buildNavItem(Icons.person_add, 'Register Seller', 3),
              ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.only(bottom: 5, top: 5),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
