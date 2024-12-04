import 'package:flutter/material.dart';
// import 'package:househunt_mobile/module/auth/login.dart';
import 'package:househunt_mobile/module/rumah/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'HouseHunt',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[200],
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey,
          ).copyWith(secondary: Colors.grey[800]),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
