import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

imgUpload(file) async {
  if (file == null) return 'Please choose image';
  //Import dart:core
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  /*Step 2: Upload to Firebase storage*/
  //Install firebase_storage
  //Import the library

  //Get a reference to storage root
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImages = referenceRoot.child('images');

  //Create a reference for the image to be stored
  Reference referenceImageToUpload = referenceDirImages.child(file.name);

  //Handle errors/success
  try {
    //Store the file
    await referenceImageToUpload.putFile(File(file!.path));
    //Success: get the download URL
    return await referenceImageToUpload.getDownloadURL();
  } catch (error) {
    //Some error occurred
  }
}
