import 'package:admin/models/all_survey_model.dart';
import 'package:admin/services/all_survey.dart';
import 'package:flutter/material.dart';

class AllSurveys extends StatefulWidget {
  AllSurveys({super.key});
  @override
  _AllSurveyWidgetState createState() => _AllSurveyWidgetState();
}

class _AllSurveyWidgetState extends State<AllSurveys> {
  final _formKey = GlobalKey<FormState>();
  bool isMandatory = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  List<AllSurvey>? AllSurveys;
  var isLoaded = false;
  Future<void> getData() async {
    AllSurveys = await AllSurveyRemoteService().getAllSurvey();
    if (AllSurveys != null && AllSurveys!.isNotEmpty) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff333541),
        centerTitle: true,
        title: Text(
          "All surveys",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: isLoaded ? _buildSurveyList() : _buildLoadingIndicator(),
      ),
    );
  }

  Widget _buildSurveyList() {
    if (AllSurveys != null && AllSurveys!.isNotEmpty) {
      return ListView.builder(
        itemCount: AllSurveys!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(AllSurveys![index].questionText),
          );
        },
      );
    } else {
      return Center(
        child: Text("No surveys available"),
      );
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
