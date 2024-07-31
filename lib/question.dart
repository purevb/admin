import 'dart:convert';
import 'package:admin/models/survey_model.dart';
import 'package:admin/provider/question_provider.dart';
import 'package:admin/screens/all_surveys.dart';
import 'package:admin/services/question_type_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'models/question_model.dart';
import 'models/question_type_model.dart';
import 'screens/create_question_cell.dart';

class QuestionWidget extends StatefulWidget {
  final Survey survey;
  final String id;

  const QuestionWidget({super.key, required this.survey, required this.id});

  @override
  QuestionWidgetState createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  final _questionFormKey = GlobalKey<FormState>();
  bool isMandatory = false;
  int number = 1;
  final List<String> ans = [];
  String ques = '';
  List<QuestionType>? pastTypes;
  List<String> list = [];
  String? dropdownValue;
  var dataProvider = QuestionProvider();
  Future<void> postQuestion(List<QuestionModel?> question) async {
    final url = Uri.parse('http://localhost:3106/api/question');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(question.map((q) => q?.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        print('Question saved successfully');
      } else {
        print('Failed to save question. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while posting question: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getQuestionTypeData();
  }

  Future<void> getQuestionTypeData() async {
    try {
      pastTypes = await TypesRemoteService().getType();
      setState(() {
        if (pastTypes != null && pastTypes!.isNotEmpty) {
          list = pastTypes!.map((type) => type.questionType).toList();
          dropdownValue = list.isNotEmpty ? list.first : null;
        } else {
          dropdownValue = null;
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void debugPrintQuestions() {
    for (var question in dataProvider.questions) {
      print('Question to send: ${question?.toJson()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllSurveys()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff333541),
              foregroundColor: Colors.white,
            ),
            child: const Text("Surveys"),
          ),
          SizedBox(
            width: width * 0.2,
          ),
          const Placeholder(
            fallbackHeight: 30,
            fallbackWidth: 100,
          ),
          const SizedBox(
            width: 20,
          ),
          const Placeholder(
            fallbackHeight: 30,
            fallbackWidth: 100,
          ),
          const SizedBox(
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: const Color(0xff8146f6),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Provider.of<QuestionProvider>(context, listen: false)
                      .addQuestion(QuestWidget(id: widget.id));
                },
                tooltip: "Add Question",
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _questionFormKey,
        child: Row(
          children: [
            Container(
              width: width * 0.3,
              height: height + 20,
              color: const Color.fromARGB(255, 59, 59, 57),
              child: SurveyDetails(survey: widget.survey),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20),
              width: width * 0.7 - 30,
              height: height,
              child: Consumer<QuestionProvider>(
                builder: (context, questionProvider, child) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return questionProvider.quests[index];
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 10,
                    ),
                    itemCount: questionProvider.quests.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (ques.isEmpty) {
            print('Question text is empty.');
            return;
          }
          List<AnswerModel> answers =
              ans.map((e) => AnswerModel(answerText: e)).toList();
          for (var type in pastTypes!) {
            if (dropdownValue == type.questionType) {
              dataProvider.addQuestionData(
                QuestionModel(
                  surveyID: widget.id,
                  questionsTypeID: type.id ?? "",
                  questionText: ques,
                  isMandatory: isMandatory,
                  answers: answers,
                ),
              );
              break;
            }
          }
          debugPrintQuestions();
          if (dataProvider.questions.isNotEmpty) {
            postQuestion(dataProvider.questions);
          } else {
            print('No questions to save.');
          }
        },
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
