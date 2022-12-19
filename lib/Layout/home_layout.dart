import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Modules/archived_tasks/archived_tasks_screen.dart';
import 'package:flutter_todo_app/Modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_todo_app/Modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 1;
  List<Widget> screens = [
    ArchivedTasksScreen(),
    NewTasksScreen(),
    DoneTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var name =  await getName();
          print(name);

        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Archive",
            icon: Icon(Icons.archive),
          ),
          BottomNavigationBarItem(
            label: "Tasks",
            icon: Icon(Icons.menu),
          ),
          BottomNavigationBarItem(
            label: "Done",
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }
 Future<String> getName() async
 {
   return 'User';
 }
}
