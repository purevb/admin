import 'dart:convert';
import 'package:admin/models/answer_model.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:admin/services/answer_service.dart';
import 'package:admin/services/question_service.dart';
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

// List<QuestionType> list = List.generate(
//   QuestionTypeEnum.values.length - 2,
//   (index) => QuestionType(
//     questionsTypeId: index + 1,
//     questionType: QuestionTypeEnum.values[index],
//     questions: [],
//   ),
// );

class _AdminDashState extends State<AdminDash> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int number = 1;
  List<TextEditingController> _controllers = [];
  // List<int> _values = [];
  // List<bool> _isChecked = [];
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
    // _values.add(0);
    // _isChecked = List<bool>.filled(number, false);
    getData();
  }

  // List<Answer>? pastAnswers;
  // List<Question>? pastQuestions;
  List<Survey>? pastSurveys;
  var isLoaded = false;
  getData() async {
    // pastAnswers = await RemoteService().getAnswer();
    // pastQuestions = await QuestionRemoteService().getQuestion();
    pastSurveys = await SurveyRemoteService().getSurvey();
    // print(pastQuestions![0].questionsTypeID.toString());
    if (pastSurveys != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  // List.generate(Question, (index) => null)
  void addOptions() {
    setState(() {
      number++;
      _controllers.add(TextEditingController(text: "Option $number"));
      // _values.add(number);
      // _isChecked = List<bool>.filled(number, false);
    });
  }

  Future<void> postSurvey(Survey survey) async {
    final url = Uri.parse('http://localhost:3106/api/survey');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(survey.toJson()),
    );

    if (response.statusCode == 200) {
      print('Survey saved successfully');
    } else {
      print('Failed to save survey');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 105, 4, 114),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.02, horizontal: width * 0.3),
            child: Column(
              children: [
                //Text(pastSurveys![0].surveyDescription),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          bool isActive = selectedEndDate != null &&
                              selectedEndDate!.isAfter(DateTime.now());
                          if (selectedStartDate != null &&
                              selectedEndDate != null) {
                            final survey = Survey(
                              surveyId:
                                  pastSurveys?.length ?? 0, // ajillahgu bgaa
                              surveyStatus: isActive,
                              surveyName: sName,
                              surveyDescription: sDesc,
                              surveyStartDate: selectedStartDate!,
                              surveyEndDate: selectedEndDate!,
                              // questions: [],
                            );

                            postSurvey(survey);
                          } else {
                            print('Start and end dates are required');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 105, 4, 114),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (pastSurveys != null)
                  // Text('Number of past surveys: ${pastSurveys!.length}'),
                  ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return quests[index];
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                    ),
                    itemCount: quests.length,
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            quests.add(QuestionWidget());
          });
        },
        child: const Icon(Icons.add),
        tooltip: "Add questions",
      ),
    );
  }
}
