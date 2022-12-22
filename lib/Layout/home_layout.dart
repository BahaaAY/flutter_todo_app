import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Modules/archived_tasks/archived_tasks_screen.dart';
import 'package:flutter_todo_app/Modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_todo_app/Modules/new_tasks/new_tasks_screen.dart';
import 'package:flutter_todo_app/Shared/components.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  bool isBottomSheetShown = false;
  late Database database;
  int currentIndex = 1;
  List<Widget> screens = [
    ArchivedTasksScreen(),
    NewTasksScreen(),
    DoneTasksScreen(),
  ];

  @override
  void initState() {
    super.initState();
    getDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isBottomSheetShown) {
              if(formKey.currentState!.validate())
                {

                  Navigator.pop(context);
                  isBottomSheetShown = !isBottomSheetShown;
                  debugPrint("DateTime: ${dateTime.toString()}");
                  insertToDatabase();
                }
            } else {
              isBottomSheetShown = !isBottomSheetShown;
              scaffoldKey.currentState?.showBottomSheet((context) {
                return Container(
                  padding: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultFormField(
                            prefix: Icon(Icons.title),
                            controller: titleController,
                            inputType: TextInputType.text,
                            label: "Task Title",
                            validate: (value) {
                              if(value.toString().isEmpty)
                                {
                                  return "Title shouldn't be empty";
                                }
                              return null;
                            }),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultFormField(
                          readOnly: true,
                          controller: timeController,
                          inputType: TextInputType.datetime,
                          label: "Time",
                          validate: (value) {
                            if(value.toString().isEmpty)
                              {
                                return "You should select task time";
                              }
                            return null;
                          },
                          onTap: () {
                            setState(() {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((time) {
                                if (time != null) {
                                  timeController.text = time.format(context);
                                  dateTime = joinTime(dateTime, time);
                                } else {
                                  if (timeController.text.isEmpty) {
                                    timeController.clear();
                                  }
                                }
                              });
                            });
                          },
                          prefix: Icon(Icons.watch_later_outlined),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        defaultFormField(
                          readOnly: true,
                          controller: dateController,
                          inputType: TextInputType.datetime,
                          label: "Date",
                          validate: (value) {
                            if(value.toString().isEmpty)
                            {
                              return "You should select task date";
                            }
                            return null;
                          },
                          onTap: () {
                            setState(() {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year,
                                    DateTime.now().month + 1, DateTime.now().day),
                              ).then((date) {
                                if (date != null) {
                                  dateController.text = DateFormat.yMMMd().format(date);
                                  dateTime = joinDate(dateTime, date);
                                } else {
                                  if (dateController.text.isEmpty) {
                                    dateController.clear();
                                  }
                                }
                              });
                            });
                          },
                          prefix: Icon(Icons.calendar_today_outlined),
                        ),
                      ],
                    ),
                  ),
                );
              });
            }
          });
        },
        child: Icon(isBottomSheetShown ? Icons.check : Icons.add),
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


  void
      getDatabase() async //Get the Database: Create new one or open existing one
  {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        log('Database created Successfully');
        await database
            .execute(
                "CREATE TABLE tasks ('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'title' TEXT, 'datetime' TEXT, 'status' TEXT );")
            .then((value) {
          log("Table Created Successfully");
        }).catchError((error) {
          log("An error occured while creating database ${error.toString()}");
        });
      },
      onOpen: (database) async {
        log("Database Opened Successfully");
      },
    );
  }

  void insertToDatabase() async{
    await database.transaction((txn) async {
      await txn.rawInsert("INSERT INTO 'tasks'(title, datetime, status) VALUES('${titleController.text}', '${dateTime}, 'new');");

    }).then((value) {
      log("Inserted Successfully!");
    }).catchError((error){
      log("Error Inserting to Databas ${error}");
    });

  }

  DateTime joinTime(DateTime date, TimeOfDay time) {
    return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
  DateTime joinDate(DateTime date, DateTime newDate) {
    return new DateTime(newDate.year, newDate.month, newDate.day, date.hour, date.minute);
  }
}
