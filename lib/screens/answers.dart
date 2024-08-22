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
  List<QuestionModel>? questions;
  bool isLoaded = false;
  List<AnswerOptions>? allAnswers;
  List<AnswerOptions> filteredAnswers = [];
  List<QuestionModel> filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      questions = await QuestionRemoteService().getQuestion();
      allAnswers = await AnswerOptionsRemoteService().getAnswerOptions();

      if (questions != null &&
          questions!.isNotEmpty &&
          allAnswers != null &&
          allAnswers!.isNotEmpty) {
        filterSurveyAnswers();
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void filterSurveyAnswers() {
    filteredAnswers.clear();
    filteredAnswers =
        allAnswers!.where((a) => a.surveyId == widget.id).toList();

    filteredQuestions.clear();
    filteredQuestions = questions!
        .where((q) => filteredAnswers.any((a) => a.questionId == q.id))
        .toList();
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
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.only(bottom: 10),
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
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    filteredQuestions[index].answers?.length ??
                                        0,
                                itemBuilder: (BuildContext context, int a) {
                                  final answer =
                                      filteredQuestions[index].answers![a].id;
                                  print("Checking answer: $answer");
                                  print(
                                      "Question ID: ${filteredQuestions[index].id}");

                                  final count = filteredAnswers.where((fa) {
                                    print("Comparing with: ${fa.userChoice}");
                                    return fa.questionId ==
                                            filteredQuestions[index].id &&
                                        fa.userChoice!.contains(answer);
                                  }).length;

                                  print("Count for $answer: $count");

                                  return ListTile(
                                    title: Text(filteredQuestions[index]
                                        .answers![a]
                                        .answerText),
                                    subtitle: Text(count.toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No questions found'))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
