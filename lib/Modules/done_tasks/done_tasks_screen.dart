import 'package:flutter/material.dart';

class DoneTasksScreen extends StatefulWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  _DoneTasksScreenState createState() => _DoneTasksScreenState();
}

class _DoneTasksScreenState extends State<DoneTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Done Tasks!",
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
