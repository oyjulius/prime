import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:primo_ng/statistics.dart';
import 'package:video_player/video_player.dart';

import 'categories.dart';

class VideoPlayerScreen extends StatefulWidget {
  final selectedColor;
  final artistdisplayname;
  final artistemail;
  final artistphoto;
  final artistuid;
  final contestcategory;
  final stagename;
  final videotitle;
  final videourl;
  final likes;
  final dislikes;
  final seasonName;
  final seasonWinner;
  final seen;
  final shared;
  final votes;
  final approval;
  VideoPlayerScreen({
    this.artistdisplayname,
    this.artistemail,
    this.artistphoto,
    this.artistuid,
    this.contestcategory,
    this.stagename,
    this.videotitle,
    this.videourl,
    this.likes,
    this.dislikes,
    this.seasonName,
    this.seasonWinner,
    this.seen,
    this.shared,
    this.votes,
    this.approval,
    this.selectedColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerScreenState();
  }
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  Widget _child;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  int like = 0;
  int dislike = 0;
  int confirmLike = 0;
  int voted = 0;
  CollectionReference thisContestant =
      FirebaseFirestore.instance.collection('submissions');
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _child = Categories();
    checkLike();
    checkVoted();
    _videoPlayerController1 = VideoPlayerController.network(widget.videourl);
    _videoPlayerController2 = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:

      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        //backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videotitle
            ),
      ),
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: BluePainter(),
          child: Expanded(
            child: Container(
              child: Column(children: <Widget>[
                Container(
                  height: 245,
                  width: MediaQuery.of(context).size.width,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
                Card(
                  color: Colors.transparent,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  like == 0 ? doLike() : doRemoveLike();
                                },
                                child: Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: like == 0
                                    ? Colors.blueAccent
                                    : Colors.lightBlueAccent,
                              ),
                              height: 45,
                              width: 45,
                            ),
                            Container(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  dislike == 0
                                      ? doDisLike()
                                      : doRemoveDisLike();
                                },
                                child: Icon(
                                  Icons.thumb_down,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dislike == 0
                                    ? Colors.blueAccent
                                    : Colors.lightBlueAccent,
                              ),
                              height: 45,
                              width: 45,
                            ),
                            Container(
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                              ),
                              height: 45,
                              width: 45,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                displayLikeButtons(),
                SizedBox(height: 50),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Card(
                            color: Colors.lightBlue,
                            elevation: 4.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(widget.artistphoto),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
                      ),
                      voteStream(),
                      Expanded(
                        child: Container(
                          child: Card(
                            color: Colors.lightBlue,
                            elevation: 4.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  voted == 0 ? vote() : printVoted();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.how_to_vote,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Vote',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: MaterialCommunityIcons.nature_people,
              backgroundColor: Colors.blue,
              selectedForegroundColor: Colors.white,
              unselectedForegroundColor: Colors.white,
              extras: {"label": "Voters"}),
          FluidNavBarIcon(
              icon: MaterialCommunityIcons.circle,
              backgroundColor: Colors.blue,
              selectedForegroundColor: Colors.white,
              unselectedForegroundColor: Colors.white,
              extras: {"label": "Stats"}),
          FluidNavBarIcon(
              icon: Icons.home,
              backgroundColor: Colors.lightBlue,
              selectedForegroundColor: Colors.white,
              unselectedForegroundColor: Colors.white,
              extras: {"label": "Home"}),
        ],
        onChange: _handleNavigationChange,
        style: FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.lightBlue,
            barBackgroundColor: Colors.lightBlue),
        defaultIndex: 1,
        scaleFactor: 1.5,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras["label"],
          child: item,
        ),
      ),
    );
  }

  doLike() async {
    if (like == 0) {
      setState(() {
        like = 1;
      });
      await _firestore.collection('likes').add({
        'artistuid': widget.artistuid,
        'seasonName': widget.seasonName,
        'contestcategory': widget.contestcategory,
        'videotitle': widget.videotitle,
        'liker': _auth.currentUser.uid,
      }).whenComplete(() async {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('submissions')
            .where('artistuid', isEqualTo: widget.artistuid)
            .where('seasonName', isEqualTo: widget.seasonName)
            .where('contestcategory', isEqualTo: widget.contestcategory)
            .where('videotitle', isEqualTo: widget.videotitle)
            .get();
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.forEach((doc) async {
            await doc.reference.update({'likes': FieldValue.increment(1)});
          });
        }
      });
    }
  }

  doRemoveLike() async {
    await deductLike();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('artistuid', isEqualTo: widget.artistuid)
        .where('seasonName', isEqualTo: widget.seasonName)
        .where('contestcategory', isEqualTo: widget.contestcategory)
        .where('videotitle', isEqualTo: widget.videotitle)
        .where('liker', isEqualTo: _auth.currentUser.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    }
  }

  deductLike() async {
    if (like == 1) {
      setState(() {
        like = 0;
      });
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('submissions')
          .where('artistuid', isEqualTo: widget.artistuid)
          .where('seasonName', isEqualTo: widget.seasonName)
          .where('contestcategory', isEqualTo: widget.contestcategory)
          .where('videotitle', isEqualTo: widget.videotitle)
          .get();
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) async {
          await doc.reference.update({'likes': FieldValue.increment(-1)});
        });
      }
    }
  }

  checkLike() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('artistuid', isEqualTo: widget.artistuid)
        .where('seasonName', isEqualTo: widget.seasonName)
        .where('contestcategory', isEqualTo: widget.contestcategory)
        .where('videotitle', isEqualTo: widget.videotitle)
        .where('liker', isEqualTo: _auth.currentUser.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        like = 1;
      });
    } else {
      setState(() {
        like = 0;
      });
    }
  }

  doDisLike() async {
    if (dislike == 0) {
      setState(() {
        dislike = 1;
      });
      await _firestore.collection('dislikes').add({
        'artistuid': widget.artistuid,
        'seasonName': widget.seasonName,
        'contestcategory': widget.contestcategory,
        'videotitle': widget.videotitle,
        'disliker': _auth.currentUser.uid,
      }).whenComplete(() async {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('submissions')
            .where('artistuid', isEqualTo: widget.artistuid)
            .where('seasonName', isEqualTo: widget.seasonName)
            .where('contestcategory', isEqualTo: widget.contestcategory)
            .where('videotitle', isEqualTo: widget.videotitle)
            .get();
        if (snapshot.docs.isNotEmpty) {
          snapshot.docs.forEach((doc) async {
            await doc.reference.update({'dislikes': FieldValue.increment(1)});
          });
        }
      });
    }
  }

  doRemoveDisLike() async {
    deductDisLike();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('dislikes')
        .where('artistuid', isEqualTo: widget.artistuid)
        .where('seasonName', isEqualTo: widget.seasonName)
        .where('contestcategory', isEqualTo: widget.contestcategory)
        .where('videotitle', isEqualTo: widget.videotitle)
        .where('disliker', isEqualTo: _auth.currentUser.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
    }
  }

  deductDisLike() async {
    if (dislike == 1) {
      setState(() {
        dislike = 0;
      });
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('submissions')
          .where('artistuid', isEqualTo: widget.artistuid)
          .where('seasonName', isEqualTo: widget.seasonName)
          .where('contestcategory', isEqualTo: widget.contestcategory)
          .where('videotitle', isEqualTo: widget.videotitle)
          .get();
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) async {
          await doc.reference.update({'dislikes': FieldValue.increment(-1)});
        });
      }
    }
  }

  Widget voteStream() {
    return Expanded(
      child: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('submissions')
                .where('artistuid', isEqualTo: widget.artistuid)
                .where('seasonName', isEqualTo: widget.seasonName)
                .where('contestcategory', isEqualTo: widget.contestcategory)
                .where('videotitle', isEqualTo: widget.videotitle)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Card(
                color: Colors.lightBlue,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data.docs.map((docum) {
                      return Column(
                        children: [
                          Text(
                            docum['votes'].toString(),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Votes',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
      ),
    );
  }

  vote() async {
    QuerySnapshot checkVoted = await FirebaseFirestore.instance
        .collection('voters')
        .where('voteruid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('artistuid', isEqualTo: widget.artistuid)
        .where('seasonName', isEqualTo: widget.seasonName)
        .where('contestcategory', isEqualTo: widget.contestcategory)
        .where('videotitle', isEqualTo: widget.videotitle)
        .get();
    if (checkVoted.docs.isEmpty) {
      QuerySnapshot snapvote = await FirebaseFirestore.instance
          .collection('submissions')
          .where('artistuid', isEqualTo: widget.artistuid)
          .where('seasonName', isEqualTo: widget.seasonName)
          .where('contestcategory', isEqualTo: widget.contestcategory)
          .where('videotitle', isEqualTo: widget.videotitle)
          .get();
      if (snapvote.docs.isNotEmpty) {
        snapvote.docs.forEach((doc) async {
          await doc.reference.update(
              {'votes': FieldValue.increment(1)}).whenComplete(() async {
            await FirebaseFirestore.instance.collection('voters').add({
              'voteruid': _auth.currentUser.uid,
              'voterImage': _auth.currentUser.photoURL,
              'voterName': _auth.currentUser.displayName,
              'voterEmail': _auth.currentUser.email,
              'artistuid': widget.artistuid,
              'artistdisplayname': widget.artistdisplayname,
              'artistphoto': widget.artistphoto,
              'stagename': widget.stagename,
              'artistemail': widget.artistemail,
              'seasonName': widget.seasonName,
              'contestcategory': widget.contestcategory,
              'videotitle': widget.videotitle,
            }).whenComplete(() {
              setState(() {
                voted = 1;
              });
              Fluttertoast.showToast(
                msg: 'You have successfully voted: ' +
                    widget.videotitle.toString(),
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white,
                backgroundColor: Colors.blue,
                toastLength: Toast.LENGTH_SHORT,
              );
            });
          });
        });
      }
    }
  }

  checkVoted() async {
    QuerySnapshot checkVoted = await FirebaseFirestore.instance
        .collection('voters')
        .where('voteruid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('artistuid', isEqualTo: widget.artistuid)
        .where('seasonName', isEqualTo: widget.seasonName)
        .where('contestcategory', isEqualTo: widget.contestcategory)
        .where('videotitle', isEqualTo: widget.videotitle)
        .get();
    if (checkVoted.docs.isNotEmpty) {
      setState(() {
        voted = 1;
      });
    }
  }

  Widget displayLikeButtons() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('submissions')
            .where('artistuid', isEqualTo: widget.artistuid)
            .where('seasonName', isEqualTo: widget.seasonName)
            .where('contestcategory', isEqualTo: widget.contestcategory)
            .where('videotitle', isEqualTo: widget.videotitle)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data.docs.map((docu) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Likes: ' + docu['likes'].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dislikes: ' + docu['dislikes'].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Shares: ' + docu['shared'].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        });
  }

  printVoted() {
    Fluttertoast.showToast(
      msg: 'You have already voted for this video',
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.redAccent,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = gotoStatistics();
          break;
        case 1:
          _child = gotoVotersList();
          break;
        case 2:
          _child = gotoCategories();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }

  gotoCategories() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Categories()));
    });
  }

  gotoVotersList() {}
  gotoStatistics() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Statistics(
                    artistdisplayname: widget.artistdisplayname,
                    artistemail: widget.artistemail,
                    artistphoto: widget.artistphoto,
                    artistuid: widget.artistuid,
                    contestcategory: widget.contestcategory,
                    stagename: widget.stagename,
                    videotitle: widget.videotitle,
                    videourl: widget.videotitle,
                    likes: widget.likes,
                    dislikes: widget.dislikes,
                    seasonName: widget.seasonName,
                    seasonWinner: widget.seasonWinner,
                    seen: widget.seen,
                    shared: widget.shared,
                    votes: widget.votes,
                    approval: widget.approval,
                  )));
    });
  }
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.blue.shade700;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    // Start paint from 20% height to the left
    ovalPath.moveTo(0, height * 0.2);

    // paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);

    // Paint a curve from current position to bottom left of screen at width * 0.1
    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);

    // draw remaining line to bottom left side
    ovalPath.lineTo(0, height);

    // Close line to reset it back
    ovalPath.close();

    paint.color = Colors.blue.shade600;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
