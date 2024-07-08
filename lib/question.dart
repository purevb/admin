import 'dart:convert';
import 'package:admin/models/answer_model.dart';
import 'package:admin/models/survey_model.dart';
import 'package:admin/services/answer_service.dart';
import 'package:admin/services/question_service.dart';
import 'package:admin/services/question_type_service.dart';
import 'package:admin/services/survey_services.dart';
import 'package:http/http.dart' as http;

import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool isMandatory = false;
  DateTime? selectedDate;
  int _selectedValue = 1;
  int number = 1;
  // late int urt;

  List<TextEditingController> _controllers = [];
  List<int> _values = [];
  List<bool> _isChecked = [];
  List<Widget> quests = [];
  final _questionController = TextEditingController();
  final _textController = TextEditingController();
  String ques = '';
  List<Answer> answer = [];
  var isLoaded = false;
  List<QuestionType>? pastTypes;
  List<Answer>? pastAnswers;
  List<Question>? pastQuestions;
  List<Survey>? pastSurveys;
  List<String> list = [];
  String? dropdownValue;
  int urt = 0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  // Asynchronous function to fetch data and update state
  getData() async {
    // Fetching data from remote services
    pastTypes = await TypesRemoteService().getType();
    pastAnswers = await RemoteService().getAnswer();
    pastQuestions = await QuestionRemoteService().getQuestion();
    pastSurveys = await SurveyRemoteService().getSurvey();

    // Updating the state once data is fetched
    setState(() {
      // Mark data as loaded
      isLoaded = true;
      urt = pastSurveys!.length;
      // Generate list of question types from pastTypes
      list = List.generate(
        pastTypes!.length,
        (index) => pastTypes![index].questionType,
      );

      // Set dropdownValue to the first item in the list or null if the list is empty
      dropdownValue = list.isNotEmpty ? list.first : null;
    });
  }

// Initialize urt with the length of pastSurveys or 0 if pastSurveys is null

  void addOptions() {
    setState(() {
      _controllers.add(TextEditingController(text: "Option $number"));
      _isChecked.add(false);
      _values.add(_values.length + 1);
      answer.add(Answer(
          answersId: _values.length,
          questionsId: '',
          answerText: "Option $number"));
      number++;
    });
  }

  Future<void> postQuestion(Question question) async {
    final url = Uri.parse('http://localhost:3106/api/question');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(question.toJson()),
    );

    if (response.statusCode == 200) {
      print('question saved successfully');
    } else {
      print('Failed to save question');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Column(
        children: [
          // Text(pastAnswers![0].answerText.toString()),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey.withOpacity(0.08),
                  child: TextFormField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Асуулт",
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      setState(() {
                        ques = value;
                      });
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.image_outlined,
                  size: 30,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Column(
            children: List.generate(_controllers.length, (index) {
              if (dropdownValue == "Multiple Choice") {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked[index],
                        activeColor: Colors.purple,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked[index] = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              answer[index] = Answer(
                                answersId: index + 1,
                                questionsId: '',
                                answerText: value,
                              );
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _isChecked.removeAt(index);
                            answer.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                );
              } else if (dropdownValue == "Text") {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Hariult avah heseg",
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              answer[index] = Answer(
                                answersId: index + 1,
                                questionsId: '',
                                answerText: value,
                              );
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _values.removeAt(index);
                            answer.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Radio(
                        value: _values[index],
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              answer[index] = Answer(
                                answersId: index + 1,
                                questionsId: '',
                                answerText: value,
                              );
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _values.removeAt(index);
                            answer.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: addOptions,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Radio(
                            value: 50,
                            groupValue: _selectedValue,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                          ),
                          Text(
                            "Add option",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        child: Row(
                          children: [
                            Checkbox(
                                value: isMandatory,
                                onChanged: (value) {
                                  setState(() {
                                    isMandatory = value!;
                                  });
                                }),
                            ElevatedButton(
                              onPressed: () {
                                print(list);
                                // print("asdasd");
                                // print(pastQuestions![2].questionText); // print(pastQuestions?.length);
                                switch (dropdownValue) {
                                  case "Multiple Choice":
                                    final question = Question(
                                      questionsID: pastQuestions?.length ?? 0,
                                      questionsTypeID:
                                          "668b5ee28fe4ad9832cda5c4",
                                      questionText: ques,
                                      surveyID: "",

                                      isMandatory: isMandatory,
                                      // answers: [],
                                    );
                                    postQuestion(question);
                                    break;
                                  case "Single Choice":
                                    final question = Question(
                                      questionsID: pastQuestions?.length ?? 0,
                                      questionsTypeID:
                                          "668b5ec48fe4ad9832cda5c2",
                                      questionText: ques,
                                      surveyID: "66612b52caf041775985b0ef",
                                      isMandatory: isMandatory,
                                      // answers: [],
                                    );
                                    postQuestion(question);
                                    break;
                                  case "Text":
                                    final question = Question(
                                      questionsID: pastQuestions?.length ?? 0,
                                      questionsTypeID:
                                          "66615953779fe29889d1d075",
                                      questionText: ques,
                                      surveyID: "66612b52caf041775985b0ef",
                                      isMandatory: isMandatory,
                                      // answers: [],
                                    );
                                    postQuestion(question);
                                    break;
                                  case "Numeric":
                                    final question = Question(
                                      questionsID: pastQuestions?.length ?? 0,
                                      questionsTypeID:
                                          "665e90a44026f697ef6234eb",
                                      questionText: ques,
                                      surveyID: "66612b52caf041775985b0ef",
                                      isMandatory: isMandatory,
                                      // answers: [],
                                    );
                                    postQuestion(question);
                                    break;
                                  case "Numeric":
                                    final question = Question(
                                      questionsID: pastQuestions?.length ?? 0,
                                      questionsTypeID:
                                          "665e90954026f697ef6234e9",
                                      questionText: ques,
                                      surveyID: "66612b52caf041775985b0ef",
                                      isMandatory: isMandatory,
                                      // answers: [],
                                    );
                                    postQuestion(question);
                                    break;
                                }
                              },
                              child: Text(
                                "Save",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
