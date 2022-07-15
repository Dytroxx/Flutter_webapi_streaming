import 'package:flutter/material.dart';

import 'MediaChannelListView.dart';
 
class MediaChannelScreen extends StatelessWidget {
  const MediaChannelScreen({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MediaChannel List",
      theme: ThemeData(scaffoldBackgroundColor: Color.fromARGB(230, 21, 21, 21)),
      home: Scaffold(appBar: AppBar(title: const Text("Media Channel List", style: TextStyle(color: Colors.black),),
                                    backgroundColor: Color.fromARGB(255, 215, 215, 0)
      ),
      body: const Center(child: MediaChannelsListView()),
      )
    );
  }
  
}
