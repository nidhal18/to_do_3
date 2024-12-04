

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box _todoBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  // Open the Hive box
  void _openBox() async {
    _todoBox = await Hive.openBox('todoBox');
    setState(() {});
  }

  // Add a new task
  void _addTask(String task) {
    if (task.isNotEmpty) {
      _todoBox.add(task);
      setState(() {});
    }
  }

  // Delete a task
  void _deleteTask(int index) {
    _todoBox.deleteAt(index);
    setState(() {});
  }

  // Show dialog to add a new task
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a New Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: 'Enter task'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Add the task
                _addTask(taskController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: _todoBox.isOpen
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _todoBox.length,
                    itemBuilder: (context, index) {
                      final task = _todoBox.getAt(index);
                      return ListTile(
                        title: Text(task),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
