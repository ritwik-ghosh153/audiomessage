import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Upload{
  String audioURL;
  Future<void> uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    audioURL=url;
  }
}