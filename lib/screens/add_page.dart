import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              label: Text(
                'Title',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              hintText: 'Type here...',
            ),
          ),
          const Gap(20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              label: Text(
                'Description',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              hintText: 'Type here...',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const Gap(20),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(
                Colors.green,
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            onPressed: submitTask,
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitTask() async {
    // create the data (body) to be posted
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // submit the data to the server
    final url = Uri.parse('https://api.nstack.in/v1/todos');
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // show success or fail message based on status
    if (response.statusCode == 201) {
      titleController.clear();
      descriptionController.clear();
      showMessage(
        'Creation Success  |  Code: ${response.statusCode}',
        Colors.green,
      );
    } else {
      showMessage(
        'Creation Failed  |  Code: ${response.statusCode}',
        Colors.red,
      );
    }
  }

  void showMessage(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
