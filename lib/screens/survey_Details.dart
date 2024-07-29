import 'package:admin/screens/edit_survey_details.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/all_survey_model.dart';
import 'package:admin/services/all_survey.dart';

class SurveyDetailWidget extends StatefulWidget {
  final String id;
  const SurveyDetailWidget({super.key, required this.id});

  @override
  SurveyDetailWidgetState createState() => SurveyDetailWidgetState();
}

class SurveyDetailWidgetState extends State<SurveyDetailWidget> {
  List<AllSurvey>? allSurveys;
  bool isLoaded = false;
  List<String>? questionIds;

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
                                    // questionIds.toString(),
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
                                        Text(
                                          question.questionText,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        const SizedBox(height: 4),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              question.answerText.map((answer) {
                                            return Text(
                                              answer.answerText,
                                              style: const TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ));
                              }).toList(),
                            ),
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
