import 'package:flutter/material.dart';
import 'save.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'upload.dart';

void main()=>runApp(VoiceNote());

class VoiceNote extends StatefulWidget {
  @override
  _VoiceNoteState createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNote> {
  final player=AudioPlayer();
  String audioURL;
  Save save; //class object for saving to local storage
  Upload upload; //class object to upload to firebase
  String duration; //accesses duration of the
  Color _micColor=Colors.grey;
  String name;
  bool isRecording=false;
  Icon play=Icon(Icons.play_arrow, size: 50, color: Colors.black,);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30),
                child: SizedBox(
                  height: 50,
                  child: Visibility(
                    visible: isRecording,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                          child: Text('Recording...',
                          style: TextStyle(
                            color: Colors.white
                          ),
                          )
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Icon(Icons.mic, size: 50, color: _micColor,),
                    onLongPressStart: (details)async{
                      isRecording=true;
                      name=DateTime.now().toIso8601String();
                      save=Save(name,null);
                      await save.start();
                      setState(() {
                        _micColor=Colors.black;
                      });
                    },
                    onLongPressEnd: (details)async{
                      isRecording=false;
                      await save.stop();
                      final path=save.getPath();
                      duration=save.getDuration().toString();
                      upload=Upload();
                      upload.uploadFile(File(path), name);
                      //TODO: retrieve this recording at path and push it to firebase
                      var record=File(path);
                      print(record);
                      setState(() {
                        _micColor=Colors.grey;
                      });
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.play_arrow, size: 50, color: Colors.black,),
                    onTap: ()async{
                      setState(() {
                        play=Icon(Icons.pause, size: 50, color: Colors.black,);
                      });
                      print('ritwik'+upload.audioURL);
                      await player.play(upload.audioURL);
                      setState(() {
                        play=play=Icon(Icons.play_arrow, size: 50, color: Colors.black,);
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

