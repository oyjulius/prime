import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File profileImage;
  bool _saving = false;
  DocumentReference profile =
      FirebaseFirestore.instance.collection('submissions').doc();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(_auth.currentUser.photoURL),
                    fit: BoxFit.cover),
              ),
              child: Center(
                child: InkWell(
                  onTap: () {
                    getImage(true);
                  },
                  child: Icon(
                    Icons.photo_camera_outlined,
                    size: 30,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                await saveImages(profileImage);
              },
              color: Colors.redAccent,
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    } else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }
    setState(() {
      if (pickedFile != null) {
        profileImage = (File(pickedFile.path));
        print('Image added');
      } else {
        Fluttertoast.showToast(
            msg: 'No image selected',
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white,
            backgroundColor: Colors.red);
      }
    });
  }

  Future<String> uploadFile(File _image) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile/${(_image.path)}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask;
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  Future<void> saveImages(File _image) async {
    if (profileImage != null) {
      String imageURL = await uploadFile(_image);
      await FirebaseFirestore.instance
          .collection('submissions')
          .where('artistemail', isEqualTo: _auth.currentUser.email)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.update({
            'artistphoto': imageURL,
          });
        });
      });
    } else {
      print('No Photo selected');
      Fluttertoast.showToast(
        msg: 'No photo selected',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
