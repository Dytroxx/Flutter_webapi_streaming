import 'dart:async';

 import 'bottom_navigation/screens/login.dart';
 import 'bottom_navigation/screens/mediachannel.dart';
 import 'bottom_navigation/screens/alarm.dart';
 import 'bottom_navigation/screens/gcore_server.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const VideoPlayerApp myPlayer =  VideoPlayerApp();
const VideoPlayerScreen myScreen = VideoPlayerScreen();
_VideoPlayerScreenState myState = _VideoPlayerScreenState();


void main() { 
  
  runApp(MaterialApp(
    theme: ThemeData(scaffoldBackgroundColor: const Color.fromARGB(230, 21, 21, 21)),
    initialRoute: '/',
    routes:{ 
      '/': (context) =>  const HomeRoute(),
      '/videoPlayer': (context) => myPlayer,
      '/screens/mediaChannel': (context) => const MediaChannelScreen(),
      '/screens/gcoreServer': (context) => const GcoreServerScreen(),
      '/screens/login': (context) => const LoginScreen(),
      '/screens/alarm': (context) => const AlarmScreen(),
    },
  )); 
  }

class ConnectionCredentials {
  String? hostname;
  String? port;
  String? mediaChannelId;

  ConnectionCredentials(String a, String b, String c )
  {
    hostname = a;
    port=b;
    mediaChannelId=c;
  }
}

class HomeRoute extends StatefulWidget{
  const HomeRoute({Key? key}) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  ConnectionCredentials connectionCredentials = ConnectionCredentials("localhost", "13332", "1");

var txtPort = TextEditingController();
var txtHost = TextEditingController();

 @override 
 void initState() {
  super.initState();
  txtHost.text = "localhost";
  txtPort.text = "13332";
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Made by Geutebrück - Viewer App 0.2', style: TextStyle(color: Colors.black),),
        backgroundColor: const Color.fromARGB(255, 215, 215, 0),
      ),
      body: Form(child: Scrollbar(child: SingleChildScrollView(padding: const EdgeInsets.all(20),
      
      child: Column(
        children: [
        Image.asset("assets/GeuLogo.jpg"),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          textInputAction: TextInputAction.next,
          controller: txtHost,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            hintText: "Hostname or Ip",
            labelText: "Hostname",
            hintStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.white)
          ),
          onChanged: (value){
            connectionCredentials.hostname = value;
          },
        ),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          controller : txtPort,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            hintText: "Port",
            labelText: 'Port',
            hintStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.white)
          ),
          onChanged: (value) {
            connectionCredentials.port = value;
                  },
                  ),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            hintText: "MediaChannel ID",
            labelText: 'MediaChannel ID',
            hintStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.white)
          ),
          onChanged: (value) {
            connectionCredentials.mediaChannelId = value;
                    },
                  ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 215, 215, 0),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              textStyle: const TextStyle(
              fontSize: 25,)),
              child: const Text('Connect!', style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.pushNamed(context, "/videoPlayer");
                myState.startVideo(connectionCredentials);
                }),
            ElevatedButton(style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 215, 215, 0),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              textStyle: const TextStyle(
              fontSize: 25,)),
              onPressed:() {Navigator.pushNamed(context, '/screens/mediaChannel');  },
              child: const Text("MediaChannel List", style: TextStyle(color: Colors.black),),
              ),
            ElevatedButton(style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 215, 215, 0),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              textStyle: const TextStyle(
              fontSize: 25,)),
              onPressed:() {Navigator.pushNamed(context, '/screens/gcoreServer');  },
              child: const Text("Remote Server List", style: TextStyle(color: Colors.black),),
              ),
            ElevatedButton(style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 215, 215, 0),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              textStyle: const TextStyle(
              fontSize: 25,)),
              onPressed:() {Navigator.pushNamed(context, '/screens/alarm');  },
              child: const Text("Alarm List", style: TextStyle(color: Colors.black),),
              )
      ]),
      ),)),
    );  
  }
}


class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player',
      home: myScreen,
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() {
    return myState;
  }
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  
  var _index = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  void startVideo(ConnectionCredentials cc){
    _controller = VideoPlayerController.network(
      'http://${cc.hostname}:${cc.port}/api/1/VideoFile/live.mp4?MediaChannelIdentifier=${cc.mediaChannelId}',
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebApi Streaming is lit', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.yellow,
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 215, 215, 0),
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (int index) => setState(() => _index = index),
        selectedItemColor: const Color.fromARGB(255, 215, 215, 0), 
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            backgroundColor: Colors.black,
            label: "Login",
            icon: Icon(Icons.home),

          ),
          const BottomNavigationBarItem(
            label: "MediaChannels",
            icon: Icon(Icons.add_chart),

          ),
          const BottomNavigationBarItem(
            label: "Alarms",
            icon: Icon(Icons.add_alarm),
            
          ),
          const BottomNavigationBarItem(
            label: "GCore Servers",
            icon: Icon(Icons.account_tree_sharp),
          ), 
        ],

      ),
    );
  }

}