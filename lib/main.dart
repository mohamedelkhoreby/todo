import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}
class Task {
  final String title;
  bool isCompleted;

  Task(this.title, {this.isCompleted = false});
}

class TaskList extends ChangeNotifier {
  List<List<Task>> pages = [
    [
      Task('Task 1'),
      Task('Task 2'),
      Task('Task 3'),
      Task('Task 4'),
      Task('Task 5'),

    ],
    [
      Task('Task 6'),
      Task('Task 7'),
      Task('Task 8'),
      Task('Task 9'),
      Task('Task 10'),
    ],
  ];

  void toggleTaskCompletion(int pageIndex, int taskIndex) {
    pages[pageIndex][taskIndex].isCompleted =
        !pages[pageIndex][taskIndex].isCompleted;
    notifyListeners();
  }

  void addTask(int pageIndex, String title) {
    if (pages[pageIndex].length < 6) {
      pages[pageIndex].add(Task(title));
      notifyListeners();
    }
  }

  void removeTask(int pageIndex, int taskIndex) {
    pages[pageIndex].removeAt(taskIndex);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskList(),
      child: MaterialApp(
        title: 'To-Do List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Consumer<TaskList>(
        builder: (context, taskList, child) {
          return PageView.builder(
            itemCount: taskList.pages.length,
            itemBuilder: (context, pageIndex) {
              return TaskPage(taskList.pages[pageIndex], pageIndex);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskPage extends StatelessWidget {
  final List<Task> tasks;
  final int pageIndex;

  const TaskPage(this.tasks, this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              Provider.of<TaskList>(context, listen: false)
                  .toggleTaskCompletion(pageIndex, index);
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TaskList>(context, listen: false)
                  .removeTask(pageIndex, index);
            },
          ),
        );
      },
    );
  }
}

class AddTaskPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter Task Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final taskTitle = _controller.text.trim();
                if (taskTitle.isNotEmpty) {
                  Provider.of<TaskList>(context, listen: false)
                      .addTask(Provider.of<TaskList>(context, listen: false)
                          .pages
                          .length - 1, taskTitle);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
