import 'package:flutter/material.dart';
import 'question.dart';

final _formKey = GlobalKey<FormState>();

class AdminDash extends StatefulWidget {
  const AdminDash({super.key});

  @override
  State<AdminDash> createState() => _AdminDashState();
}

const List<String> list = <String>[
  'Logical',
  'Single Choice',
  'Multiple Choice',
  'Numeric',
  'Text'
];

class _AdminDashState extends State<AdminDash> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String dropdownValue = list.first;
  DateTime? selectedDate;
  // int _selectedValue = 1;
  int number = 1;
  List<TextEditingController> _controllers = [];
  List<int> _values = [];
  List<bool> _isChecked = [];
  List<Widget> quests = [];

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController(text: "Option $number"));
    _values.add(0);
    _isChecked = List<bool>.filled(number, false);
  }

  void addOptions() {
    setState(() {
      number++;
      _controllers.add(TextEditingController(text: "Option $number"));
      _values.add(number);
      _isChecked = List<bool>.filled(number, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 105, 4, 114),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.02, horizontal: width * 0.3),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Survey Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (name) =>
                            name!.length == 0 ? "Nertei baih ystoi" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                        ),
                        validator: (description) => description!.length == 0
                            ? "Zaaval descriptiontei baih ystoi"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      InputDatePickerFormField(
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        fieldLabelText: 'Start Date',
                        errorFormatText: 'Invalid date',
                        errorInvalidText: 'Invalid date',
                        onDateSubmitted: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        onDateSaved: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      InputDatePickerFormField(
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        fieldLabelText: 'End Date',
                        errorFormatText: 'Invalid date',
                        errorInvalidText: 'Invalid date',
                        onDateSubmitted: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                        onDateSaved: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return quests[index];
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: 10,
                  ),
                  itemCount: quests.length,
                ),
                //...quests,
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.validate();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 105, 4, 114),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            quests.add(QuestionWidget());
          });
        },
        child: Icon(Icons.add),
        tooltip: "Add questions",
      ),
    );
  }
}
