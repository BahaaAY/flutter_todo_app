import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/Shared/components.dart';
import 'package:flutter_todo_app/Shared/cubit/cubit.dart';
import 'package:flutter_todo_app/Shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  bool isBottomSheetShown = false;
  late Database database;




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state){},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text("Todo App"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
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
                              prefix: const Icon(Icons.title),
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
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());
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
                            },
                            prefix: Icon(Icons.watch_later_outlined),
                          ),
                          const SizedBox(
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
                            },
                            prefix: Icon(Icons.calendar_today_outlined),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }
            },
            child: Icon(isBottomSheetShown ? Icons.check : Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeNavBarState(index);
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
          body: cubit.screens[cubit.currentIndex],
        );
        },
      ),
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

