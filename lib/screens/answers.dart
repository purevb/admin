import 'package:admin/models/answer_options.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/services/answer_options_service.dart';
import 'package:admin/services/question_service.dart';
import 'package:flutter/material.dart';

class SavedAnswers extends StatefulWidget {
  final String id;
  final String name;
  const SavedAnswers({required this.id, required this.name, super.key});

  @override
  SavedAnswersWidgetState createState() => SavedAnswersWidgetState();
}

class SavedAnswersWidgetState extends State<SavedAnswers> {
  List<QuestionModel>? questions;
  bool isLoaded = false;
  List<AnswerOptions>? allAnswers;
  List<AnswerOptions> filteredAnswers = [];
  List<QuestionModel> filteredQuestions = [];
  Map<String, int> answerCounts = {};

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

    answerCounts.clear();

    final counta =
        filteredAnswers.fold<Map<String, int>>({}, (counts, answerOption) {
      for (var choice in answerOption.userChoice ?? []) {
        counts[choice] = (counts[choice] ?? 0) + 1;
      }
      return counts;
    });

    answerCounts = counta;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff333541),
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: isLoaded
            ? filteredQuestions.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredQuestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (filteredQuestions[index]
                          .questionsTypeID!
                          .contains("66b19afb79959b160726b2c4")) {
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
                                  itemCount: filteredAnswers.length,
                                  itemBuilder: (BuildContext context, int a) {
                                    final userChoices =
                                        filteredAnswers[a].userChoice ?? [];
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: userChoices.length,
                                      itemBuilder:
                                          (BuildContext context, int b) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 4),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  child: Text(userChoices[b]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
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
                                  itemCount: filteredQuestions[index]
                                          .answers
                                          ?.length ??
                                      0,
                                  itemBuilder: (BuildContext context, int a) {
                                    final answerId =
                                        filteredQuestions[index].answers![a].id;
                                    final count = answerCounts[answerId] ?? 0;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                  filteredQuestions[index]
                                                      .answers![a]
                                                      .answerText),
                                            ),
                                            SizedBox(
                                              child: Text('Count: $count'),
                                            )
                                          ],
                                        ),
                                      ),
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
