import 'dart:convert';
import 'package:admin/models/answer_model.dart';
import 'package:admin/services/answer_service.dart';
import 'package:admin/services/question_service.dart';
import 'package:http/http.dart' as http;

import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

List<QuestionType> list = List.generate(
  QuestionTypeEnum.values.length,
  (index) => QuestionType(
    questionsTypeId: index + 1,
    questionType: QuestionTypeEnum.values[index],
    questions: [],
  ),
);

class _QuestionWidgetState extends State<QuestionWidget> {
  List<Answer>? pastAnswers;
  List<Question>? pastQuestions;
  var isLoaded = false;
  getData() async {
    pastAnswers = await RemoteService().getAnswer();
    pastQuestions = await QuestionRemoteService().getQuestion();
    print(pastQuestions![0].questionsTypeID.toString());
    if (pastAnswers != null && pastQuestions != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  bool isMandatory = false;
  QuestionType dropdownValue = list.first;
  DateTime? selectedDate;
  int _selectedValue = 1;
  int number = 1;
  List<TextEditingController> _controllers = [];
  List<int> _values = [];
  List<bool> _isChecked = [];
  List<Widget> quests = [];
  final _questionController = TextEditingController();
  String ques = '';
  List<Answer> answer = [];

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

  Future<void> postQuestion(Question survey) async {
    final url = Uri.parse('http://localhost:3106/api/question');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(survey.toJson()),
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
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Column(
        children: [
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
                child: DropdownButton<QuestionType>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  items: list.map<DropdownMenuItem<QuestionType>>(
                      (QuestionType value) {
                    return DropdownMenuItem<QuestionType>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (QuestionType? value) {
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
              if (dropdownValue.questionType ==
                  QuestionTypeEnum.MultipleChoice) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked[index],
                        activeColor: Colors.amber,
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
                    Container(
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
                                final question = Question(
                                  questionsID: 5,
                                  questionsTypeID: "665e90a44026f697ef6234eb",
                                  questionText: ques,
                                  surveyID: "66612b52caf041775985b0ef",
                                  isMandatory: isMandatory,
                                  answers: [],
                                );
                                postQuestion(question);
                              },
                              child: Text("Save")),
                        ],
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
