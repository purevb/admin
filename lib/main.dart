import 'package:admin/admin.dart';
import 'package:admin/screens/allSurveys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin/provider/question_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionProvider(),
      child: MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFf9f9fb)),
        debugShowCheckedModeBanner: false,
        home: AllSurveys(),
      ),
    );
  }
}
