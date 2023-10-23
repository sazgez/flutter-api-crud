// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todocrudapp/screens/screens.dart';
import 'package:todocrudapp/services/services.dart';
import 'package:todocrudapp/utils/utils.dart';
import 'package:todocrudapp/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: RefreshIndicator(
          onRefresh: fetchTasks,
          child: Visibility(
            visible: tasks.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index] as Map;

                return TaskCard(
                  task: task,
                  index: index,
                  navigateToEdit: navigateToEdit,
                  deleteByID: deleteByID,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToCreate,
        label: const Text('Add Task'),
      ),
    );
  }

  Future<void> navigateToCreate() async {
    final route = MaterialPageRoute(
      builder: (context) => const CreateEditPage(),
    );
    await Navigator.push(
      context,
      route,
    ).then(
      (_) => fetchTasks(),
    );
  }

  Future<void> navigateToEdit(Map task) async {
    final route = MaterialPageRoute(
      builder: (context) => CreateEditPage(task: task),
    );
    await Navigator.push(
      context,
      route,
    ).then(
      (_) => fetchTasks(),
    );
  }

  Future<void> deleteByID(String id) async {
    final isSuccess = await TaskService.deleteByID(id: id);
    if (isSuccess) {
      // Remove item from the list
      final filtered = tasks.where((element) => element['_id'] != id).toList();
      setState(() {
        tasks = filtered;
      });
      showMessage(
        context,
        'Deletion Success',
        Colors.green,
      );
    } else {
      showMessage(
        context,
        'Deletion Failed',
        Colors.red,
      );
    }
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    final response = await TaskService.fechTasks();
    response != null
        ? setState(() {
            tasks = response;
          })
        : showMessage(
            context,
            'Something went wrong',
            Colors.red,
          );

    setState(() {
      isLoading = false;
    });
  }
}
