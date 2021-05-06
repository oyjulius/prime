import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:primo_ng/categories.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AnimationController controller;
  Animation animation;
  bool wipedata = false;
  @override
  void initState() {
    orderexec();
    controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    animation = ColorTween(begin: Colors.blue[400], end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(Duration(seconds: 8), () {
      if (_auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Categories()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/primo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.2), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Center(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image(
                          image: AssetImage('images/primo.png'),
                          width: 200,
                          height: 150,
                        ),
                        // child: FlutterLogo(
                        //   size: 100,
                        // ),
                        height: 150,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['NAIJA \n VIDEO CONTEST'],
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    splashColor: Colors.white,
                    color: Colors.deepOrangeAccent,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage("images/primong.jpg"),
                              height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Vote your favourite video.\n Most voted video wins a prize',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 2.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget welcome() {
    MaterialButton(
      splashColor: Colors.orange,
      color: Colors.deepOrangeAccent,
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/primonigeria.jpg"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Vote your favourite video.\n Most voted video wins a prize',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 2.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Here we are going to send all submissions of just concluded season to archive
  Future<void> archive() async {
    await _firestore
        .collection('settings')
        .doc('contest')
        .get()
        .then((value) async {
      bool activeContest = value.get('isActive');
      if (activeContest == false) {
        await _firestore.collection('submissions').get().then((subvalue) {
          if (subvalue.docs.isNotEmpty) {
            subvalue.docs.forEach((element) {
              _firestore.collection('archive').add(element.data());
            });
          }
          subvalue.docs.forEach((element) {
            element.reference.delete();
          });
        });
      }
    });
  }

  //here we are going to award winner to the first leading candidate in music
  Future musicWinner() async {
    _firestore
        .collection('submissions')
        .where('contestcategory', isEqualTo: 'music')
        .orderBy('votes', descending: true)
        .limit(1)
        .get()
        .then((musicvalue) {
      if (musicvalue.docs.isNotEmpty) {
        musicvalue.docs.forEach((element) {
          element.reference.update({
            'seasonWinner': true,
          });
        });
      }
    });
  }

  //here we are going to award winner to the first leading candidate in comedy
  Future comedyWinner() async {
    _firestore
        .collection('submissions')
        .where('contestcategory', isEqualTo: 'comedy')
        .orderBy('votes', descending: true)
        .limit(1)
        .get()
        .then((comedyvalue) {
      if (comedyvalue.docs.isNotEmpty) {
        comedyvalue.docs.forEach((element) {
          element.reference.update({
            'seasonWinner': true,
          });
        });
      }
    });
  }

  //here we are going to award winner to the first leading candidate in dance
  Future danceWinner() async {
    _firestore
        .collection('submissions')
        .where('contestcategory', isEqualTo: 'dance')
        .orderBy('votes', descending: true)
        .limit(1)
        .get()
        .then((dancevalue) {
      if (dancevalue.docs.isNotEmpty) {
        dancevalue.docs.forEach((element) {
          element.reference.update({
            'seasonWinner': true,
          });
        });
      }
    });
  }

  //here we are going to award winner to the first leading candidate in photography
  Future photographyWinner() async {
    _firestore
        .collection('submissions')
        .where('contestcategory', isEqualTo: 'photography')
        .orderBy('votes', descending: true)
        .limit(1)
        .get()
        .then((pvalue) {
      if (pvalue.docs.isNotEmpty) {
        pvalue.docs.forEach((element) {
          element.reference.update({
            'seasonWinner': true,
          });
        });
      }
    });
  }

  //here we are going to award winner to the first leading candidate in modelling
  Future modellingWinner() async {
    _firestore
        .collection('submissions')
        .where('contestcategory', isEqualTo: 'modelling')
        .orderBy('votes', descending: true)
        .limit(1)
        .get()
        .then((mvalue) {
      if (mvalue.docs.isNotEmpty) {
        mvalue.docs.forEach((element) {
          element.reference.update({
            'seasonWinner': true,
          });
        });
      }
    });
  }

  //here we are going to award winner to the first leading candidate in skits
  Future skitWinner() async {
    _firestore
        .collection('submissions')
        .where('contestcategory', isEqualTo: 'skits')
        .orderBy('votes', descending: true)
        .limit(1)
        .get()
        .then((svalue) {
      if (svalue.docs.isNotEmpty) {
        svalue.docs.forEach((element) {
          element.reference.update({
            'seasonWinner': true,
          });
        });
      }
    });
  }

  //Order of execution
  Future orderexec() async {
    await _firestore.collection('settings').doc('contest').get().then((value) {
      bool activeContest = value.get('isActive');
      if (activeContest == false) {
        setState(() {
          wipedata = true;
        });
        skitWinner();
        modellingWinner();
        photographyWinner();
        danceWinner();
        comedyWinner();
        musicWinner();
      }
    }).whenComplete(() async {
      if (wipedata == true) {
        await archive();
      }
    });
  }
}
