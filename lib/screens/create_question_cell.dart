import 'dart:convert';
import 'package:admin/provider/question_provider.dart';
import 'package:admin/services/question_service.dart';
import 'package:admin/services/question_type_service.dart';
import 'package:http/http.dart' as http;
import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestWidget extends StatefulWidget {
  final String id;
  final VoidCallback onQuestionSaved;
  const QuestWidget({
    super.key,
    required this.id,
    required this.onQuestionSaved,
  });

  @override
  QuestWidgetState createState() => QuestWidgetState();
}

class QuestWidgetState extends State<QuestWidget> {
  bool isMandatory = false;
  int _selectedValue = 1;
  int number = 1;
  var dataProvider = QuestionProvider();
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
  List<QuestionModel>? pastQuestions;
  List<String> list = [];
  String? dropdownValue;
  int urt = 0;

  List<QuestionModel>? asuult = [];

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

  Future<void> postQuestion(QuestionModel question) async {
    final url = Uri.parse('http://localhost:3106/api/question');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(question.toJson()),
    );
    if (response.statusCode == 200) {
      // print('Question saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Question saved succesfully'),
      ));
      widget.onQuestionSaved();
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
      child: Column(children: [
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
                    // if (pastTypes[index].questionType == value!) {
                    //   dropdownValue = pastTypes[index].id;
                    // }
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
                      activeColor: Colors.black.withOpacity(0.5),
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
                    Provider.of<QuestionProvider>(context, listen: false)
                        .removeQuestions(widget);
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                      value: isMandatory,
                      activeColor: Colors.black.withOpacity(0.6),
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
                ElevatedButton(
                  onPressed: () {
                    QuestionModel? question;
                    List<AnswerModel> answers =
                        ans.map((e) => AnswerModel(answerText: e)).toList();
                    for (var type in pastTypes!) {
                      if (dropdownValue == type.questionType) {
                        // dataProvider.quests.add();

                        question = QuestionModel(
                          surveyID: widget.id,
                          questionsTypeID: type.id,
                          questionText: ques,
                          isMandatory: isMandatory,
                          answers: answers,
                        );
                        break;
                      }
                    }
                    if (question != null) {
                      postQuestion(question);
                    } else {
                      print('Question type taarsngu.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Save"),
                ),
              ]),
            )
          ],
        ),
      ]),
    );
  }
}
