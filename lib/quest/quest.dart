import 'dart:convert';
import 'package:admin/models/survey_model.dart';
import 'package:admin/services/question_service.dart';
import 'package:admin/services/question_type_service.dart';
import 'package:admin/services/survey_services.dart';
import 'package:http/http.dart' as http;
import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:flutter/material.dart';

class QuestWidget extends StatefulWidget {
  QuestWidget({super.key});
  @override
  _QuestWidgetState createState() => _QuestWidgetState();
}

class _QuestWidgetState extends State<QuestWidget> {
  bool isMandatory = false;
  int _selectedValue = 1;
  int number = 1;
  final List<TextEditingController> _controllers = [];
  final List<int> _values = [];
  final List<bool> _isChecked = [];
  List<Widget> quests = [];
  final _questionController = TextEditingController();
  final _textController = TextEditingController();
  String ques = '';
  List<String> ans = [];
  var isLoaded = false;
  List<QuestionType>? pastTypes;
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

  Future<void> getData() async {
    try {
      pastTypes = await TypesRemoteService().getType();
      pastQuestions = await QuestionRemoteService().getQuestion();
      pastSurveys = await SurveyRemoteService().getSurvey();
      setState(() {
        isLoaded = true;
        if (pastTypes != null && pastTypes!.isNotEmpty) {
          list = List.generate(
            pastTypes!.length,
            (index) => pastTypes![index].questionType,
          );
          dropdownValue = list.isNotEmpty ? list.first : null;
        } else {
          dropdownValue = null;
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoaded = false;
      });
    }
  }

  void addOptions() {
    setState(() {
      _controllers.add(TextEditingController(text: "Option $number"));
      _isChecked.add(false);
      _values.add(_values.length + 1);
      ans.add("");
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
      print('Question saved successfully');
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
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey.withOpacity(0.08),
                  child: TextFormField(
                    controller: _questionController,
                    decoration: const InputDecoration(
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
                icon: const Icon(
                  Icons.image_outlined,
                  size: 30,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
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
                  padding: const EdgeInsets.all(8.0),
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
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              ans[index] = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _isChecked.removeAt(index);
                            _values.removeAt(index);
                            ans.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.cancel_outlined),
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
                          decoration: const InputDecoration(
                            hintText: "Hariult avah heseg",
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (index < ans.length) {
                                ans[index] = value;
                              } else {
                                ans.add(value);
                              }
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _values.removeAt(index);
                            ans.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(8.0),
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
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              ans[index] = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _controllers.removeAt(index);
                            _values.removeAt(index);
                            ans.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.cancel_outlined),
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
              padding: const EdgeInsets.all(8.0),
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
                          const Text(
                            "Add option",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.copy_rounded)),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.delete_outline)),
                ],
              ),
              VerticalDivider(
                thickness: 5,
              ),
              SizedBox(
                child: Container(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Required",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Checkbox(
                              value: isMandatory,
                              onChanged: (value) {
                                setState(() {
                                  isMandatory = value!;
                                });
                              }),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(ans);
                          Question question;
                          List<Answer> answers =
                              ans.map((e) => Answer(answerText: e)).toList();
                          switch (dropdownValue) {
                            case "Multiple Choice":
                              question = Question(
                                questionsID: pastQuestions?.length ?? 0,
                                questionsTypeID: "669763b497492aac645169c1",
                                questionText: ques,
                                isMandatory: isMandatory,
                                answers: answers,
                              );
                              break;
                            case "Single Choice":
                              question = Question(
                                questionsID: pastQuestions?.length ?? 0,
                                questionsTypeID: "669763a597492aac645169bfc",
                                questionText: ques,
                                isMandatory: isMandatory,
                                answers: answers,
                              );
                              break;
                            case "Text":
                              question = Question(
                                questionsID: pastQuestions?.length ?? 0,
                                questionsTypeID: "6697639a97492aac645169bd",
                                questionText: ques,
                                isMandatory: isMandatory,
                                answers: answers,
                              );
                              break;
                            case "Numeric":
                              question = Question(
                                questionsID: pastQuestions?.length ?? 0,
                                questionsTypeID: "6697638f97492aac645169bb",
                                questionText: ques,
                                isMandatory: isMandatory,
                                answers: answers,
                              );
                              break;
                            case "Logical":
                              question = Question(
                                questionsID: pastQuestions?.length ?? 0,
                                questionsTypeID: "669763c097492aac645169c3",
                                questionText: ques,
                                isMandatory: isMandatory,
                                answers: answers,
                              );
                              break;
                            default:
                              return;
                          }

                          postQuestion(question);
                        },
                        child: const Text("Save"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
