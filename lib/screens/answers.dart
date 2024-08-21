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
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void getSurveyAnswers() {
    myQuestions.clear();
    if (question != null && allAnswers != null) {
      for (var a in allAnswers!) {
        if (widget.id == a.surveyId) {
          myQuestions.add(a);
        }
      }
      takedata();
      print('Total questions: ${question!.length}');
      print('Total answers: ${allAnswers!.length}');
      print('Filtered answers: ${myQuestions.length}');
      for (var answer in myQuestions) {
        // bool questionExists = question!.any((q) => q.id == answer.questionId);
        // if (questionExists) {
        print('Question ID: ${answer.questionId}');
        print('Survey ID: ${answer.surveyId}');
        // }
      }
    }
  }

  List<QuestionModel> filteredQuestions = [];

  void takedata() {
    filteredQuestions.clear();

    filteredQuestions = question
            ?.where((q) => myQuestions.any((m) => q.id == m.questionId))
            .toList() ??
        [];
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
            ? filteredQuestions.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredQuestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (myQuestions[index].questionId ==
                          filteredQuestions[index].id) {
                        return Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: const Text("Question"),
                                subtitle: Text(
                                  filteredQuestions[index].questionText ??
                                      "No Text",
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredQuestions[index]
                                          .answers
                                          ?.length ??
                                      0,
                                  itemBuilder: (BuildContext context, int a) {
                                    return ListTile(
                                      title: Text(filteredQuestions[index]
                                              .answers![a]
                                              .answerText ??
                                          "No Answer Text"),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  )
                : const Center(child: Text('No questions found'))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
