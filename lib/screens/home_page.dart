import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todocrudapp/screens/screens.dart';
import 'package:http/http.dart' as http;

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
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index] as Map;
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '${index + 1}',
                  ),
                ),
                title: Text(
                  '${task['title']}',
                ),
                subtitle: Text(
                  '${task['description']}',
                ),
                trailing: SelectableText('${task['_id']}'),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToCreatePage,
        label: const Text('Add Task'),
      ),
    );
  }

  void navigateToCreatePage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=20');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final data = json['items'] as List;
      setState(() {
        tasks = data;
      });
    } else {
      // show error
    }
    setState(() {
      isLoading = false;
    });
  }
}
