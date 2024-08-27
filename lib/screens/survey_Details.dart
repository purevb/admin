import 'package:admin/provider/question_provider.dart';
import 'package:admin/screens/create_question_cell.dart';
import 'package:admin/screens/edit_survey_details.dart';
import 'package:admin/services/question_service.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/all_survey_model.dart';
import 'package:admin/services/all_survey.dart';
import 'package:provider/provider.dart';

class SurveyDetailWidget extends StatefulWidget {
  final String id;
  const SurveyDetailWidget({super.key, required this.id});

  @override
  SurveyDetailWidgetState createState() => SurveyDetailWidgetState();
}

class SurveyDetailWidgetState extends State<SurveyDetailWidget> {
  List<AllSurvey>? allSurveys;
  bool isLoaded = false;

  Future<void> removeQuestions(String questionId) async {
    try {
      await QuestionRemoteService().deleteQuestion(questionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question deleted successfully'),
        ),
      );

      getData();
    } catch (e) {
      print('Error deleting question: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete question'),
        ),
      );
    }
  }

  Future<void> _dialogBuilder(BuildContext context, String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Асуулт устгах"),
            content: const Text("Асуулт устгах зөвшөөрөл!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Үгүй"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, removeQuestions(id));
                },
                child: const Text("Тийм"),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      List<AllSurvey>? surveys = await AllSurveyRemoteService().getAllSurvey();
      setState(() {
        allSurveys = surveys;
        isLoaded = true;
      });
    } catch (e) {
      print('Error fetching surveys: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff333541),
        centerTitle: true,
        title: const Text(
          "Survey",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditSurveyDetailWidget(
                    id: widget.id,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: const Color(0xff8146f6),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Provider.of<QuestionProvider>(context, listen: false)
                      .addQuestions(
                    QuestWidget(
                      id: widget.id,
                      onQuestionSaved: () {
                        getData();
                        Provider.of<QuestionProvider>(context, listen: false)
                            .removeQuestions(widget);
                      },
                    ),
                  );
                },
                tooltip: "Create question",
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: isLoaded
          ? (allSurveys != null && allSurveys!.isNotEmpty
              ? ListView.builder(
                  itemCount: allSurveys!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (allSurveys![index].id == widget.id) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Survey Name: ${allSurveys![index].surveyName}',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Survey Description: ${allSurveys![index].surveyDescription}',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Survey Start Date: ${allSurveys![index].startDate.toString().split(" ")[0]}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Survey End Date: ${allSurveys![index].endDate.toString().split(" ")[0]}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Survey Status: ${allSurveys![index].surveyStatus ? 'Active' : 'Inactive'}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Image Url: ${allSurveys![index].imgUrl}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Survey Questions:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  allSurveys![index].question.map((question) {
                                return Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.2)),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0, horizontal: 6.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Question:",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    question.questionText,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                  tooltip: "Delete question",
                                                  onPressed: () {
                                                    // removeQuestions(
                                                    //     question.id);
                                                    _dialogBuilder(
                                                        context, question.id);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              question.answerText.map((answer) {
                                            return ListTile(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              title: Text(
                                                answer.answerText,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ));
                              }).toList(),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<QuestionProvider>(
                                builder: (context, questionProvider, child) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return questionProvider
                                          .questionWidget[index];
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(height: 10),
                                    itemCount:
                                        questionProvider.questionWidget.length,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              : const Center(child: Text('No surveys available')))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
