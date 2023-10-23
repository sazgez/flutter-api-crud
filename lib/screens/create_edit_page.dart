// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todocrudapp/services/services.dart';
import 'package:todocrudapp/utils/utils.dart';

class CreateEditPage extends StatefulWidget {
  final Map? task;

  const CreateEditPage({
    super.key,
    this.task,
  });

  @override
  State<CreateEditPage> createState() => _CreateEditPageState();
}

class _CreateEditPageState extends State<CreateEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      isEdit = true;
      _titleController.text = widget.task!['title'];
      _descriptionController.text = widget.task!['description'];
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Task' : 'Create Task',
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
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
            controller: _descriptionController,
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
            onPressed: isEdit ? updateTask : submitTask,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                isEdit ? 'Update' : 'Submit',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final isSuccess = await TaskService.submitTask(body: body);

    if (isSuccess) {
      _titleController.clear();
      _descriptionController.clear();
      showMessage(
        context,
        'Creation Success',
        Colors.green,
      );
    } else {
      showMessage(
        context,
        'Creation Failed',
        Colors.red,
      );
    }
  }

  Future<void> updateTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final isCompleted = widget.task!['is_completed'];
    final id = widget.task!['_id'];
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted
    };

    final isSuccess = await TaskService.updateTask(
      id: id,
      body: body,
    );

    isSuccess
        ? showMessage(
            context,
            'Update Success',
            Colors.green,
          )
        : showMessage(
            context,
            'Update Failed',
            Colors.red,
          );
  }
}
