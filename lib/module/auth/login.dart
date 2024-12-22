import 'package:flutter/material.dart';
import 'package:househunt_mobile/widgets/bottom_navigation.dart';
import 'package:househunt_mobile/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:househunt_mobile/module/auth/register_buyer.dart';
import 'package:househunt_mobile/module/auth/register_seller.dart';
import 'package:househunt_mobile/module/rumah/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      drawer: const LeftDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      final response = await request
                          .login("http://127.0.0.1:8000/login/flutter/", {
                        'username': username,
                        'password': password,
                      });

                      if (request.loggedIn) {
                        String message = response['message'];
                        String uname = response['username'];
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                  content:
                                      Text("$message Selamat datang, $uname.")),
                            );
                        }
                      } else {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Gagal'),
                              content: Text(response['message']),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 36.0),
                  const Divider(
                    color: Colors.grey, // Line color
                    thickness: 1, // Line thickness
                    indent: 16, // Left padding
                    endIndent: 16, // Right padding
                  ),
                  Center(
                    child: Image.asset('assets/images/HouseHunt.png'),
                  ),
                  const Text(
                    'Belum punya akun? Daftar sekarang',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterSellerPage()),
                      );
                    },
                    child: const Text('Daftar sebagai Penjual'),
                  ),
                  const SizedBox(height: 18.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterBuyerPage()),
                      );
                    },
                    child: const Text('Daftar sebagai Pembeli'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
