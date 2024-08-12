import 'dart:convert';
import 'package:admin/models/question_type_model.dart';
import 'package:admin/models/survey_model.dart';
import 'package:admin/provider/question_provider.dart';
import 'package:admin/screens/all_surveys.dart';
import 'package:admin/services/question_service.dart';
import 'package:admin/services/question_type_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/question_model.dart';

class QuestionWidget extends StatefulWidget {
  final Survey survey;
  final String id;

  const QuestionWidget({super.key, required this.survey, required this.id});

  @override
  QuestionWidgetState createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  final List<QuestionModel> quests = [];
  bool isMandatory = false;
  int _selectedValue = 1;
  int number = 1;
  final List<TextEditingController> _controllers = [];
  final List<int> _values = [];
  final List<bool> _isChecked = [];
  final _questionController = TextEditingController();
  final _textController = TextEditingController();
  String ques = '';
  List<String> ans = [];
  var isLoaded = false;
  List<QuestionType>? pastTypes;
  List<QuestionModel>? pastQuestions;
  List<String> list = [];
  String? dropdownValue;

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

  void addOptionController() {
    setState(() {
      _controllers.add(TextEditingController(text: "Option $number"));
      _isChecked.add(false);
      _values.add(number++);
      ans.add("");
    });
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
          SnackBar(content: Text('Questions saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save questions')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while posting questions')),
      );
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
                onPressed: () {
                  QuestionModel? question;
                  List<AnswerModel> answers =
                      ans.map((e) => AnswerModel(answerText: e)).toList();
                  for (var type in pastTypes!) {
                    if (dropdownValue == type.questionType) {
                      question = QuestionModel(
                        surveyID: widget.id,
                        questionsTypeID: type.id!,
                        questionText: ques,
                        answers: answers,
                        isMandatory: isMandatory,
                      );
                      quests.add(question);
                      break;
                    }
                  }
                  setState(() {});
                },
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
                children: quests
                    .map((e) => Container(
                          margin:
                              EdgeInsets.only(bottom: 15, left: 10, right: 10),
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
                                        controller: _questionController,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          labelText: "Асуулт",
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 16,
                                      items: list.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          dropdownValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children:
                                    List.generate(_controllers.length, (index) {
                                  if (dropdownValue == "Multiple Choice") {
                                    return Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _isChecked[index],
                                            activeColor:
                                                Colors.black.withOpacity(0.5),
                                            onChanged: (value) {
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
                                            icon: const Icon(
                                                Icons.cancel_outlined),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (dropdownValue == "Text") {
                                    return Container(
                                      padding: const EdgeInsets.all(8.0),
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
                                                setState(() {});
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
                                            icon: const Icon(
                                                Icons.cancel_outlined),
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
                                            onChanged: (value) {
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
                                            icon: const Icon(
                                                Icons.cancel_outlined),
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
                                        onPressed: () {},
                                        icon: const Icon(Icons.copy_rounded),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Provider.of<QuestionProvider>(context, listen: false)
                                          //     .removeQuestion(widget);
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                      ),
                                    ],
                                  ),
                                  const VerticalDivider(
                                    thickness: 5,
                                  ),
                                  SizedBox(
                                    child: Row(children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Required",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Checkbox(
                                            value: isMandatory,
                                            activeColor:
                                                Colors.black.withOpacity(0.6),
                                            onChanged: (value) {
                                              setState(() {
                                                isMandatory = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
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
