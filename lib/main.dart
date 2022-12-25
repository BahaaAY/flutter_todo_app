import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Layout/home_layout.dart';

import 'Shared/cubit/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomeLayout(),
    );
  }
}
