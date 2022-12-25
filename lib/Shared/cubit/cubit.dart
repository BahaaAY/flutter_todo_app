import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/Modules/archived_tasks/archived_tasks_screen.dart';
import 'package:flutter_todo_app/Modules/done_tasks/done_tasks_screen.dart';
import 'package:flutter_todo_app/Modules/new_tasks/new_tasks_screen.dart';
import 'package:flutter_todo_app/Shared/cubit/states.dart';
class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 1;
  List<Widget> screens = [
    ArchivedTasksScreen(),
    NewTasksScreen(),
    DoneTasksScreen(),
  ];
  void changeNavBarState(int index){
    currentIndex = index;
    emit(AppChangeNavBarState());
}


}