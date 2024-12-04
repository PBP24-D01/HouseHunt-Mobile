import 'package:flutter/material.dart';
import 'package:househunt_mobile/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'HouseHunt',
            style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            ),
        ),
        // Warna latar belakang AppBar diambil dari skema warna tema aplikasi.
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Mengganti warna icon drawer menjadi putih
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: const Center(
        child: Text('Welcome to Home Page'),
      ),
    );
  }
}
