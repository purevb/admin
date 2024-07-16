import 'package:admin/admin.dart';
import 'package:admin/question.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFf9f9fb)),
      debugShowCheckedModeBanner: false,
      // home: AdminDash(),
      home: QuestionWidget(),
    );
  }
}
