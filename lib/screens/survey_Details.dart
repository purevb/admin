import 'package:flutter/material.dart';
import 'package:admin/models/all_survey_model.dart';
import 'package:admin/services/all_survey.dart';

class SurveyDetailWidget extends StatefulWidget {
  final String id;

  const SurveyDetailWidget({Key? key, required this.id}) : super(key: key);

  @override
  _SurveyDetailWidgetState createState() => _SurveyDetailWidgetState();
}

class _SurveyDetailWidgetState extends State<SurveyDetailWidget> {
  List<AllSurvey>? allSurveys;
  bool isLoaded = false;

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
      ),
      body: isLoaded
          ? (allSurveys != null && allSurveys!.isNotEmpty
              ? ListView.builder(
                  itemCount: allSurveys!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Find the survey matching the widget.id
                    if (allSurveys![index].id == widget.id) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Survey Name: ${allSurveys![index].surveyName}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Survey Description: ${allSurveys![index].surveyDescription}',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                      'Survey Start Date: ${allSurveys![index].startDate.toString().split(" ")[0]}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Survey End Date: ${allSurveys![index].endDate.toString().split(" ")[0]}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                  SizedBox(height: 8),
                                  Text(
                                      'Survey Status: ${allSurveys![index].surveyStatus ? 'Active' : 'Inactive'}',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Survey Questions:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  allSurveys![index].question.map((question) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    padding: EdgeInsets.only(right: 5, left: 2),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        SizedBox(height: 4),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              question.answerText.map((answer) {
                                            return Text(
                                              answer.answerText,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 8),
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
              : Center(child: Text('No surveys available')))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
