import 'package:flutter/material.dart';
import 'package:rojgarmela/widgets/bottom_nav_bar.dart';

class UploadJob extends StatefulWidget {
  const UploadJob({super.key});

  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController jobcategoryController =
      TextEditingController(text: 'Select Job Category');
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController jobDeadlineController = TextEditingController();
  final TextEditingController jobDescriptionController =
      TextEditingController();
  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textformfield(
      {required String valueKey,
      required TextEditingController controller,
      required bool enabled,
      required Function fct,
      required int maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
          onTap: () {
            fct();
          },
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Value is missing';
              }
              return null;
            },
            controller: controller,
            enabled: enabled,
            key: ValueKey(valueKey),
            style: const TextStyle(color: Colors.white),
            maxLines: valueKey == 'Job Description' ? 3 : 1,
            maxLength: maxLength,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.black54,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red))),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(index: 2),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Upload Jobs',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            color: Color.fromARGB(153, 255, 90, 186),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Please fill all fields',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textTitles(label: 'Job Category :'),
                          _textformfield(
                              valueKey: 'Job Category',
                              controller: jobcategoryController,
                              enabled: false,
                              fct: () {},
                              maxLength: 100),
                          _textTitles(label: 'Job Title'),
                          _textformfield(
                              valueKey: 'Job Title',
                              controller: jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100),
                          _textTitles(label: 'Job Description'),
                          _textformfield(
                              valueKey: 'Job Description',
                              controller: jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100),
                          _textTitles(label: 'Job Deadline Date: '),
                          _textformfield(
                              valueKey: 'Deadline',
                              controller: jobDeadlineController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
