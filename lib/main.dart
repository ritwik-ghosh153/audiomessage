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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      height: 30,
                      width: 180,
                      child: Visibility(
                        visible: isRecording,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),),
                          ),
                          child: Center(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.mic, color: Colors.red,),
                                  Text('<<< swipe to cancel',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) => GestureDetector(
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
                        if(details.localPosition.dx <-80){
                          isRecording = false;
                          await save.stop();
                          final path = save.getPath();
                          print(details.localPosition.dx);
                          setState(() {
                            _micColor = Colors.grey;
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Recording cancelled'),duration: Duration(seconds: 2),));
                        }
                        else {
                          isRecording = false;
                          await save.stop();
                          final path = save.getPath();
                          duration = save.getDuration().toString();
                          upload = Upload();
                          upload.uploadFile(File(path), name);
                          //TODO: retrieve this recording at path and push it to firebase
                          var record = File(path);
                          print(record);
                          print(details.localPosition.dx);
                          setState(() {
                            _micColor = Colors.grey;
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Recording saved'),duration: Duration(seconds: 2),));
                        }
                      },
                    ),
                  ),
                ],
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
        ),
      ),
    );
  }

}

