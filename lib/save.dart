import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class Save{
  Recording _recording = new Recording();
  String textVal;
  LocalFileSystem localFileSystem;
  Save(String Val,LocalFileSystem local){
    textVal=Val;
    localFileSystem = local ?? LocalFileSystem();
  }

  start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        if (textVal != null && textVal != "") {
          String path = textVal;
          if (!textVal.contains('/')) {
            io.Directory appDocDirectory =
            await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + textVal;
          }
          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          print('thissss');
          await AudioRecorder.start();
        }
        _recording = new Recording(duration: new Duration(), path: "");
      } else {
        print('You have to accept permissionsss');
      }
    } catch (e) {
      print(e);
    }
  }
  Duration getDuration(){
    return _recording.duration;
  }
  String getPath(){
    return _recording.path;
  }
  stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    File file = localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    _recording = recording;
    textVal = recording.path;
  }

}