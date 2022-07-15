import 'package:flutter/material.dart';

import 'gcoreServerListView.dart';
 
class GcoreServerScreen extends StatelessWidget {
  const GcoreServerScreen({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Remote Server List",
      theme: ThemeData(scaffoldBackgroundColor: Color.fromARGB(230, 21, 21, 21)),
      home: Scaffold(appBar: AppBar(title: const Text("Remote Server List", style: TextStyle(color: Colors.black),),
                                    backgroundColor: Color.fromARGB(255, 215, 215, 0)
      ),
      body: const Center(child: GcoreServerListView()),
      )
    );
  }
  
}
