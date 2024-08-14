import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:admin/models/survey_model.dart';
import 'package:admin/screens/all_surveys.dart';
import 'package:admin/services/question_service.dart';
import 'package:admin/services/question_type_service.dart';

class QuestionWidget extends StatefulWidget {
  final Survey survey;
  final String id;

  const QuestionWidget({super.key, required this.survey, required this.id});

  @override
  QuestionWidgetState createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  final List<QuestionModel> quests = [];
  List<bool> isMandatory = [];
  List<String> dropdownValue = [];
  final _textController = TextEditingController();
  final List<List<TextEditingController>> _controllers = [];
  final List<List<int>> _values = [];
  final List<List<bool>> _isChecked = [];
  final List<TextEditingController> _questionController = [];
  int _selectedValue = 1;
  List<QuestionType>? pastTypes;
  List<QuestionModel>? pastQuestions;
  List<String> list = [];
  bool isLoaded = false;

  final List<String>? takeQuestion = [];
  List<bool>? takeMandatory = [];
  List<String>? takeAnswers = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      pastTypes = await TypesRemoteService().getType();
      pastQuestions = await QuestionRemoteService().getQuestion();
      setState(() {
        isLoaded = true;
        if (pastTypes != null && pastTypes!.isNotEmpty) {
          list = pastTypes!.map((type) => type.questionType).toList();

          dropdownValue = List.generate(
            quests.length,
            (index) => list.isNotEmpty ? list.first : '',
          );
        } else {
          dropdownValue = List.filled(quests.length, '');
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoaded = false;
      });
    }
  }

  void collectSaveQuestions() {
    List<QuestionModel> allQuestions = List.from(quests);
    saveQuestionsToBackend(allQuestions);
  }

  Future<void> saveQuestionsToBackend(List<QuestionModel> questions) async {
    final url = Uri.parse('http://localhost:3106/api/questions');
    try {
      final questionJson = questions.map((q) => q.toJson()).toList();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(questionJson),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Questions saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save questions')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while posting questions')),
      );
    }
  }

  void addQuestion() {
    setState(() {
      var question = QuestionModel(surveyID: widget.id);
      quests.add(question);
      _questionController.add(TextEditingController());
      _controllers.add([]);
      _isChecked.add([]);
      _values.add([]);
      takeQuestion!.add("");
      takeMandatory!.add(false);
      takeAnswers!.add("");
      isMandatory.add(false);
      dropdownValue.add(list.isNotEmpty ? list.first : "");
    });
  }

  void addOptions(int index) {
    setState(() {
      _controllers[index].add(TextEditingController(
          text: "Option ${_controllers[index].length + 1}"));
      _isChecked[index].add(false);
      _values[index].add(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff333541),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllSurveys()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff333541),
              foregroundColor: Colors.white,
            ),
            child: const Text("Surveys"),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: const Color(0xff8146f6),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: addQuestion,
                tooltip: "Add Question",
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            color: const Color.fromARGB(255, 59, 59, 57),
            child: SurveyDetails(survey: widget.survey),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  quests.length,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 10, right: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.grey.withOpacity(0.08),
                                  child: TextFormField(
                                    controller: _questionController[index],
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      labelText: "Question",
                                      labelStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        takeQuestion![index] = value;
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: dropdownValue[index],
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  items: list.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue[index] = value!;
                                      // for (var type in pastTypes!) {
                                      //   if (value == type.questionType) {
                                      //     quests[index].questionsTypeID =
                                      //         type.id!;
                                      //   }
                                      // }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: List.generate(_controllers[index].length,
                                (optIndex) {
                              if (dropdownValue[index] == "Multiple Choice") {
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _isChecked[index][optIndex],
                                        activeColor:
                                            Colors.black.withOpacity(0.5),
                                        onChanged: (value) {
                                          setState(() {
                                            _isChecked[index][optIndex] =
                                                value!;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _controllers[index]
                                              [optIndex],
                                          decoration: const InputDecoration(
                                            enabledBorder: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              takeAnswers![index] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _controllers[index]
                                                .removeAt(optIndex);
                                            _isChecked[index]
                                                .removeAt(optIndex);
                                            _values[index].removeAt(optIndex);
                                          });
                                        },
                                        icon: const Icon(Icons.cancel_outlined),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (dropdownValue[index] == "Text") {
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _textController,
                                          decoration: const InputDecoration(
                                            hintText: "Answer field",
                                            enabledBorder: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _textController.clear();
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
                                        value: _values[index][optIndex],
                                        groupValue: _selectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedValue = value!;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _controllers[index]
                                              [optIndex],
                                          decoration: const InputDecoration(
                                            enabledBorder: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              takeAnswers![index] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _controllers[index]
                                                .removeAt(optIndex);
                                            _values[index].removeAt(optIndex);
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
                                onTap: () => addOptions(index),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        quests.removeAt(index);
                                        _questionController.removeAt(index);
                                        _controllers.removeAt(index);
                                        _isChecked.removeAt(index);
                                        _values.removeAt(index);
                                        takeMandatory!.removeAt(index);
                                        dropdownValue.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                              const VerticalDivider(thickness: 5),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isMandatory[index],
                                    onChanged: (value) {
                                      setState(() {
                                        isMandatory[index] = value!;
                                      });
                                    },
                                  ),
                                  const Text("Required"),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: collectSaveQuestions,
        backgroundColor: const Color(0xff15ae5c),
        tooltip: "Save all questions",
        child: const Icon(Icons.save),
      ),
    );
  }
}

class SurveyDetails extends StatelessWidget {
  final Survey survey;
  const SurveyDetails({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            survey.imgUrl,
            height: 50,
            width: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              );
            },
          ),
          Text(
            "Survey Name: ${survey.surveyName}",
            style: const TextStyle(color: Colors.white),
          ),
          Text("Survey description: ${survey.surveyDescription}",
              style: const TextStyle(color: Colors.white)),
          Text("Survey status: ${survey.surveyStatus}",
              style: const TextStyle(color: Colors.white)),
          Text(
              "Survey start date: ${survey.surveyStartDate.toString().split(" ")[0]}",
              style: const TextStyle(color: Colors.white)),
          Text(
              "Survey end date: ${survey.surveyEndDate.toString().split(' ')[0]}",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
