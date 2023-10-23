import 'package:flutter/material.dart';
import 'package:todocrudapp/utils/utils.dart';

class TaskCard extends StatelessWidget {
  final Map task;
  final int index;
  final Function(Map) navigateToEdit;
  final Function(String) deleteByID;

  const TaskCard({
    super.key,
    required this.task,
    required this.index,
    required this.navigateToEdit,
    required this.deleteByID,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    final id = task['_id'] as String;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            '${index + 1}',
          ),
        ),
        title: Text(
          '${task['title']}',
        ),
        subtitle: SelectableText(
          '${task['_id']}',
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              // Open Edit Page
              navigateToEdit(task);
            } else if (value == 'delete') {
              // Delete and remove the item
              deleteByID(id);
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ];
          },
        ),
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              height: deviceSize.height * 0.25,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Text(
                    task['description'] != ''
                        ? '${task['description']}'
                        : 'No Description',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
