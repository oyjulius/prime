import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:primo_ng/Admin/ActivateUser.dart';
import 'package:primo_ng/archive.dart';
import 'package:primo_ng/background.dart';
import 'package:primo_ng/comedy/comedy.dart';
import 'package:primo_ng/dance/dance.dart';
import 'package:primo_ng/modelling/modelling.dart';
import 'package:primo_ng/music/music_category.dart';
import 'package:primo_ng/photography/photography.dart';
import 'package:primo_ng/sign_in.dart';
import 'package:primo_ng/skit/skit.dart';
import 'package:primo_ng/splash_screen.dart';
import 'package:primo_ng/submit_video.dart';
import 'package:primo_ng/winners.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool _saving = false;
  DocumentReference profile =
      FirebaseFirestore.instance.collection('submissions').doc();
  int hasSponsors = 0;
  File profileImage;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getSponsors();
    Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Image(
          image: AssetImage('images/primo.png'),
          height: 50,
          width: 100,
        ),
        elevation: 0.8,
        shadowColor: Colors.white,
      ),
      drawer: Drawer(
        elevation: 4.0,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue],
          )),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              // UserAccountsDrawerHeader(
              //   accountName: Text(_auth.currentUser.displayName.toString()),
              //   accountEmail: Text(_auth.currentUser.email.toString()),
              //   currentAccountPicture: InkWell(
              //     onTap: () {
              //       getImage(true).whenComplete(() async {
              //         setState(() {
              //           _saving = true;
              //         });
              //         await saveImages(profileImage).whenComplete(() {
              //           setState(() {
              //             _saving = false;
              //           });
              //         });
              //       });
              //     },
              //     child: CircleAvatar(
              //       backgroundColor: Colors.white54,
              //       backgroundImage: profileImage != null
              //           ? FileImage(profileImage)
              //           : NetworkImage(_auth.currentUser.photoURL),
              //     ),
              //   ),
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('images/primo1.jpg'),
              //       fit: BoxFit.cover,
              //       colorFilter:
              //           ColorFilter.mode(Colors.blue, BlendMode.overlay),
              //     ),
              //   ),
              // ),
              InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivateUser()));
                      },
                      child: ListTile(
                        title: Text(
                          'Activate User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Icon(
                          Icons.verified_user,
                          color: Colors.white,
                        ),
                      ),
                    ),

              Divider(
                thickness: 0.5,
                // color: Colors.redAccent,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Categories()));
                },
                child: ListTile(
                  title: Text(
                    'Contest Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                  ),
                ),
              ),
              Divider(
                thickness: 0.5,
                // color: Colors.redAccent,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Winners()));
                },
                child: ListTile(
                  title: Text(
                    'Winners',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.account_box_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              Divider(
                thickness: 0.5,
                // color: Colors.redAccent,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Archive()));
                },
                child: ListTile(
                  title: Text(
                    'Archive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    MaterialCommunityIcons.video,
                    color: Colors.white,
                  ),
                ),
              ),
              Divider(
                thickness: 0.5,
                // color: Colors.redAccent,
              ),
              InkWell(
                onTap: () => signOutGoogle().whenComplete(() async {
                  await _auth.signOut().whenComplete(() {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                        (route) => false);
                  });
                }),
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ModalProgressHUD(
        child: CustomPaint(
          painter: BluePainter(),
          child: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  carol,
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Competition Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Comedy()));
                        },
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.blue,
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/comedy01.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.blue, BlendMode.overlay),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 90,
                            width: 150,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Comedy',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    letterSpacing: 2.0,
                                    shadows: [Shadow(color: Colors.black)],
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Music()));
                        },
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.blue,
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage('images/music1.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.blue, BlendMode.overlay),
                              ),
                            ),
                            height: 90,
                            width: 150,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Music',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    letterSpacing: 2.0,
                                    shadows: [Shadow(color: Colors.black)],
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Dance()));
                        },
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.blue,
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage('images/primong.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.blue, BlendMode.overlay),
                              ),
                            ),
                            height: 90,
                            width: 150,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Dance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    letterSpacing: 2.0,
                                    shadows: [Shadow(color: Colors.black)],
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Skit()));
                        },
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.blue,
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage('images/sport.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.blue, BlendMode.overlay),
                              ),
                            ),
                            height: 90,
                            width: 150,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Sports',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    letterSpacing: 2.0,
                                    shadows: [Shadow(color: Colors.black)],
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Modelling()));
                        },
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.blue,
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage('images/model.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.blue, BlendMode.overlay),
                              ),
                            ),
                            height: 90,
                            width: 150,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Modelling',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    letterSpacing: 2.0,
                                    shadows: [Shadow(color: Colors.black)],
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Photography()));
                        },
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.blue,
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage('images/photography.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.blue, BlendMode.overlay),
                              ),
                            ),
                            height: 90,
                            width: 150,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Photography',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    letterSpacing: 2.0,
                                    shadows: [Shadow(color: Colors.black)],
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: _saving,
      ),
      bottomNavigationBar: hasSponsors == 0
          ? Text('')
          : Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sponsors:',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 10),
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(maxWidth: 200),
                    color: Colors.transparent,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('sponsors')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshort) {
                          if (!snapshort.hasData) {
                            return Container(
                              height: 20,
                              width: 20,
                              color: Colors.transparent,
                            );
                          } else
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshort.data.docs.map((document) {
                                return Container(
                                  height: 40,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(document['logo']),
                                        fit: BoxFit.contain),
                                  ),
                                );
                              }).toList(),
                            );
                        }),
                  ),
                ],
              ),
            ),
      bottomSheet: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(0.5),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade800,
                  Colors.blue,
                ]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                splashColor: Colors.deepOrange,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SubmitVideo()));
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.video_collection,
                      color: Colors.white,
                    ),
                    Text(
                      "Contest",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.deepOrange,
                onTap: () {},
                child: Column(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.deepOrange,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Winners()));
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.ballot,
                      color: Colors.white,
                    ),
                    Text(
                      "Results",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget carol = new Container(
    height: 200,
    child: Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('images/break.jpg'),
        AssetImage('images/music011.jpg'),
        AssetImage('images/primong.jpg'),
      ],
      autoplay: true,
      autoplayDuration: Duration(milliseconds: 10000),
    ),
  );

  Future getSponsors() async {
    await FirebaseFirestore.instance.collection('sponsors').get().then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          hasSponsors = 1;
        });
      }
    });
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
      }).whenComplete(() async {
        await FirebaseFirestore.instance
            .collection('voters')
            .where('artistemail', isEqualTo: _auth.currentUser.email)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            element.reference.update({
              'artistphoto': imageURL,
            });
          });
        });
      }).whenComplete(() {
        Fluttertoast.showToast(
          msg:
              'Image Saved for submissions only. Change your dp in Gmail for better experience',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
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
