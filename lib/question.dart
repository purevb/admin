import 'dart:convert';
import 'package:admin/models/answer_model.dart';
import 'package:admin/models/survey_model.dart';
import 'package:admin/quest/quest.dart';
import 'package:admin/services/answer_service.dart';
import 'package:admin/services/question_service.dart';
import 'package:admin/services/question_type_service.dart';
import 'package:admin/services/survey_services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;

import 'package:admin/models/question_model.dart';
import 'package:admin/models/question_type_model.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

final _formKey = GlobalKey<FormState>();

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

  getData() async {
    pastTypes = await TypesRemoteService().getType();
    pastAnswers = await RemoteService().getAnswer();
    pastQuestions = await QuestionRemoteService().getQuestion();
    pastSurveys = await SurveyRemoteService().getSurvey();

    setState(() {
      isLoaded = true;
      urt = pastSurveys!.length;
      list = List.generate(
        pastTypes!.length,
        (index) => pastTypes![index].questionType,
      );

      dropdownValue = list.isNotEmpty ? list.first : null;
    });
  }

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
    return Scaffold(
      appBar: AppBar(
          // centerTitle: true,
          backgroundColor: const Color(0xff333541),
          title: const Text(
            "Admin Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text("Surveys"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff333541),
                  foregroundColor: Colors.white),
            ),
            SizedBox(
              width: width * 0.2,
            ),
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
      body: Container(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Container(
                    width: width * 0.3,
                    height: height + 20,
                    color: const Color.fromARGB(255, 59, 59, 57),
                  ),
                  Column(
                    children: [
                      if (pastSurveys != null)
                        const SizedBox(
                          height: 10,
                        ),
                      // Text('Number of past surveys: ${pastSurveys!.length}'),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        width: width * 0.7 - 30,
                        height: height,
                        child: ListView.separated(
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
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            quests.add(QuestWidget());
            // print(quests);
          });
        },
        child: const Icon(Icons.add),
        tooltip: "Add questions",
        backgroundColor: Color(0xff15ae5c),
      ),
    );
  }
}
