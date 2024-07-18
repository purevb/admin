import 'package:admin/quest/quest.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({super.key});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

final _formKey = GlobalKey<FormState>();

class _QuestionWidgetState extends State<QuestionWidget> {
  bool isMandatory = false;
  List<Widget> quests = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
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
