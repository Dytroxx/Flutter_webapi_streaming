import 'package:flutter/material.dart';

import 'AlarmListView.dart';
 
class AlarmScreen extends StatelessWidget {
  const AlarmScreen({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Alarm List",
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromARGB(230, 255, 255, 255)),
      home: Scaffold(appBar: AppBar(title: const Text("Alarm List"),
      ),
      body: const Center(child: AlarmsListView()),
      )
    );
  }
  
}
