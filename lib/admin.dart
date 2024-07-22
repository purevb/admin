import 'dart:convert';
import 'package:admin/services/survey_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/survey_model.dart';
import 'question.dart';

final _formKey = GlobalKey<FormState>();

class AdminDash extends StatefulWidget {
  const AdminDash({super.key});
  @override
  State<AdminDash> createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int number = 1;
  List<TextEditingController> _controllers = [];
  List<Widget> quests = [];
  bool active = false;
  String sName = '';
  String sDesc = '';
  String sDate = '';
  String eDate = '';
  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController(text: "Option $number"));
    getData();
  }

  List<Survey>? pastSurveys;
  var isLoaded = false;
  Future<void> getData() async {
    pastSurveys = await SurveyRemoteService().getSurvey();
    if (pastSurveys != null && pastSurveys!.isNotEmpty) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  void addOptions() {
    setState(() {
      number++;
      _controllers.add(TextEditingController(text: "Option $number"));
    });
  }

  Future<dynamic> postSurvey(Survey survey) async {
    final url = Uri.parse('http://localhost:3106/api/survey');
    final surveyJson = json.encode(survey.toJson());
    print('Survey JSON: $surveyJson'); // Print survey data
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: surveyJson,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff333541),
          title: const Text(
            "Admin Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Placeholder(
              fallbackHeight: 30,
              fallbackWidth: 100,
            ),
            SizedBox(
              width: 20,
            ),
            Placeholder(
              fallbackHeight: 30,
              fallbackWidth: 100,
            ),
            SizedBox(
              width: 20,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Container(
                color: Color(0xff8146f6),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ),
            )
          ]),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Survey",
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  padding: EdgeInsets.only(right: width * 0.5, top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {
                            sName = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Survey Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (name) =>
                            name!.isEmpty ? "Survey name is required" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        onChanged: (value) {
                          setState(() {
                            sDesc = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                        ),
                        validator: (description) => description!.isEmpty
                            ? "Description is required"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _startDateController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedStartDate = pickedDate;
                              _startDateController.text =
                                  pickedDate.toIso8601String().split('T').first;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: "Start Date",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => {sDate = value},
                        validator: (date) =>
                            date!.isEmpty ? "Start date is required" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _endDateController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedEndDate = pickedDate;
                              _endDateController.text =
                                  pickedDate.toIso8601String().split('T').first;
                            });
                          }
                        },
                        onChanged: (value) => {eDate = value},
                        decoration: const InputDecoration(
                          labelText: "End Date",
                          border: OutlineInputBorder(),
                        ),
                        validator: (date) =>
                            date!.isEmpty ? "End date is required" : null,
                      ),
                      SizedBox(
                        height: height * 0.035,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool isActive = selectedEndDate != null &&
                                    selectedEndDate!.isAfter(DateTime.now());
                                if (selectedStartDate != null &&
                                    selectedEndDate != null) {
                                  final survey = Survey(
                                    surveyName: sName,
                                    surveyDescription: sDesc,
                                    surveyStartDate: selectedStartDate!,
                                    surveyEndDate: selectedEndDate!,
                                    surveyStatus: isActive,
                                  );
                                  print('Survey to post: ${survey.toJson()}');
                                  var res = await postSurvey(survey);
                                  print(res["data"]["_id"]);
                                  if (res["data"]["_id"] != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuestionWidget(
                                            survey: survey,
                                            id: res["data"]["_id"].toString()),
                                      ),
                                    );
                                  } else {
                                    print('Failed to get objectId');
                                  }
                                } else {
                                  print('Start and end dates are required');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff15ae5c),
                            ),
                            child: const Text(
                              "Create Survey",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
