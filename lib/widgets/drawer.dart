import 'package:flutter/material.dart';
import 'package:househunt_mobile/module/auth/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

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
            child: Text(
              isAuthenticated
                  ? 'Hello, ${request.jsonData['username']}!'
                  : 'Hello, Guest!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Menu untuk user yang login
          if (isAuthenticated) ...[
            if (isBuyer) ...[
              ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFF4A628A)),
                title: const Text('Wishlist'),
                onTap: () {
                  Navigator.pushNamed(context, '/wishlist');
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Color(0xFF4A628A)),
                title: const Text('Diskusi'),
                onTap: () {
                  Navigator.pushNamed(context, '/discussion');
                },
              ),
              ListTile(
                leading: const Icon(Icons.house, color: Color(0xFF4A628A)),
                title: const Text('Cek Rumah'),
                onTap: () {
                  Navigator.pushNamed(context, '/check_houses');
                },
              ),
              ListTile(
                leading: const Icon(Icons.gavel, color: Color(0xFF4A628A)),
                title: const Text('Lelang'),
                onTap: () {
                  Navigator.pushNamed(context, '/auction');
                },
              ),
            ],
            if (isSeller) ...[
              ListTile(
                leading: const Icon(Icons.ads_click, color: Color(0xFF4A628A)),
                title: const Text('Iklan'),
                onTap: () {
                  Navigator.pushNamed(context, '/advertisements');
                },
              ),
              ListTile(
                leading: const Icon(Icons.message, color: Color(0xFF4A628A)),
                title: const Text('Diskusi'),
                onTap: () {
                  Navigator.pushNamed(context, '/discussion');
                },
              ),
              ListTile(
                leading: const Icon(Icons.house, color: Color(0xFF4A628A)),
                title: const Text('Cek Rumah'),
                onTap: () {
                  Navigator.pushNamed(context, '/check_houses');
                },
              ),
              ListTile(
                leading: const Icon(Icons.gavel, color: Color(0xFF4A628A)),
                title: const Text('Lelang'),
                onTap: () {
                  Navigator.pushNamed(context, '/auction');
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
                await request.logout(
                    "http://tristan-agra-househuntx.pbp.cs.ui.ac.id/auth/logout/flutter/");
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
              title: const Text('Daftar'),
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ],
      ),
    );
  }
}
