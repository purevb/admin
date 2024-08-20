import 'package:admin/models/answer_options.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/services/answer_options_service.dart';
import 'package:admin/services/question_service.dart';
import 'package:flutter/material.dart';

class SavedAnswers extends StatefulWidget {
  final String id;
  const SavedAnswers({required this.id, super.key});

  @override
  SavedAnswersWidgetState createState() => SavedAnswersWidgetState();
}

class SavedAnswersWidgetState extends State<SavedAnswers> {
  List<QuestionModel>? question;
  bool isLoaded = false;
  List<AnswerOptions>? allAnswers;
  List<AnswerOptions> myQuestions = [];
  List<QuestionModel> myQues = [];

  @override
  void initState() {
    super.initState();
    getData();
    myQuestions = [];
  }

  Future<void> getData() async {
    try {
      question = await QuestionRemoteService().getQuestion();
      allAnswers = await AnswerOptionsRemoteService().getAnswerOptions();

      if (question != null &&
          question!.isNotEmpty &&
          allAnswers != null &&
          allAnswers!.isNotEmpty) {
        getSurveyAnswers();
        print(question!.length);
        print(allAnswers!.length);
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void getSurveyAnswers() {
    if (question != null && allAnswers != null) {
      for (var a in allAnswers!) {
        if (widget.id == a.surveyId) {
          myQuestions.add(a);
        }
      }
      print('Total questions: ${question!.length}');
      print('Total answers: ${allAnswers!.length}');
      print('Filtered answers: ${myQuestions.length}');
      for (var answer in myQuestions) {
        print('Question ID: ${answer.questionId}');
        print('Survey ID: ${answer.surveyId}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff333541),
        centerTitle: true,
        title: const Text(
          "Saved Answers",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
              child: Container(
                color: const Color(0xff8146f6),
                child: IconButton(
                  iconSize: 23,
                  icon: const Icon(Icons.question_answer_sharp),
                  onPressed: () {},
                ),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: const Color(0xff8146f6),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
                tooltip: "Create Survey",
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: isLoaded
            ? myQuestions.isNotEmpty
                ? SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: myQuestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            myQuestions[index].questionId.questionText ?? "s",
                          ),
                        );
                      },
                    ),
                  )
                : const Center(child: Text('No data available'))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
