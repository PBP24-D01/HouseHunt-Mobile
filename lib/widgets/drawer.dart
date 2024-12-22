import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/auth/login.dart';
import 'package:househunt_mobile/module/cekrumah/cekrumah_buyer.dart';
import 'package:househunt_mobile/module/cekrumah/cekrumah_seller.dart';
import 'package:househunt_mobile/module/diskusi/main.dart';
import 'package:househunt_mobile/module/iklan/main.dart';
import 'package:househunt_mobile/module/wishlist/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:househunt_mobile/module/rumah/main.dart';
import 'package:househunt_mobile/module/auth/register_buyer.dart';
import 'package:househunt_mobile/module/auth/register_seller.dart';
import 'package:househunt_mobile/module/lelang/main.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);

    // Cek autentikasi dan tipe user
    bool isAuthenticated = request.loggedIn;
    bool isBuyer = request.jsonData['is_buyer'] ?? false;
    bool isSeller = !isBuyer;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Drawer
          DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF4A628A),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAuthenticated
                        ? 'Hello, ${request.jsonData['username']}!'
                        : 'Hello, Guest!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isAuthenticated ? '${request.jsonData['email']}' : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    isAuthenticated
                        ? isBuyer
                            ? 'Akun Pembeli'
                            : 'Akun Penjual'
                        : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )),
          // Menu untuk user yang login
          if (isAuthenticated) ...[
            if (isBuyer) ...[
              ListTile(
                leading: const Icon(Icons.house, color: Color(0xFF4A628A)),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFF4A628A)),
                title: const Text('Wishlist'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WishlistPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Color(0xFF4A628A)),
                title: const Text('Diskusi'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscussionPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.house, color: Color(0xFF4A628A)),
                title: const Text('Cek Rumah'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CekRumahBuyer()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.gavel, color: Color(0xFF4A628A)),
                title: const Text('Lelang'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuctionPage()));
                },
              ),
            ],
            if (isSeller) ...[
              ListTile(
                leading: const Icon(Icons.house, color: Color(0xFF4A628A)),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.ads_click, color: Color(0xFF4A628A)),
                title: const Text('Iklan'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const IklanPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Color(0xFF4A628A)),
                title: const Text('Diskusi'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscussionPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.house, color: Color(0xFF4A628A)),
                title: const Text('Cek Rumah'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CekRumahSeller()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.gavel, color: Color(0xFF4A628A)),
                title: const Text('Lelang'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuctionPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Sell House'),
                onTap: () {
                  Navigator.pushNamed(context, '/sell_house');
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await request.logout("http://127.0.0.1:8000/logout/flutter/");
                if (!request.loggedIn && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Berhasil logout!")),
                  );
                }
              },
            ),
          ],
          // Menu untuk guest (belum login)
          if (!isAuthenticated) ...[
            ListTile(
              leading: const Icon(Icons.house, color: Color(0xFF4A628A)),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.login, color: Color(0xFF4A628A)),
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Color(0xFF4A628A)),
              title: const Text('Daftar Sebagai Pembeli'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterBuyerPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Color(0xFF4A628A)),
              title: const Text('Daftar Sebagai Penjual'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterSellerPage()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}