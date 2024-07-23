import 'package:flutter/material.dart';
import 'admin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFf9f9fb)),
      debugShowCheckedModeBanner: false,
      home: AdminDash(),
    );
  }
}
