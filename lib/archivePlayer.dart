import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:primo_ng/background.dart';
import 'package:video_player/video_player.dart';

class ArchivePlayer extends StatefulWidget {
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
  ArchivePlayer(
      {this.selectedColor,
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
      this.approval});
  @override
  _ArchivePlayerState createState() => _ArchivePlayerState();
}

class _ArchivePlayerState extends State<ArchivePlayer> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
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
      autoInitialize: true,
    );
    super.initState();
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
        title: Text(widget.stagename),
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
                              child: Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightBlueAccent,
                              ),
                              height: 45,
                              width: 45,
                            ),
                            Container(
                              child: Icon(
                                Icons.thumb_down,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightBlueAccent,
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
                      Expanded(
                        child: Container(
                          child: Card(
                            color: Colors.lightBlue,
                            elevation: 4.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_shared_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Artist: ' + widget.stagename.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    'Title: ' + widget.videotitle.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    'Season: ' + widget.seasonName.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      voteStream(),
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
    );
  }

  Widget displayLikeButtons() {
    return StreamBuilder(
        stream: _firestore
            .collection('archive')
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
                            'Likes: ' + widget.likes.toString(),
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
                            'Dislikes: ' + widget.dislikes.toString(),
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
                            'Shares: ' + widget.shared.toString(),
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

  Widget voteStream() {
    return Expanded(
      child: Container(
        child: StreamBuilder(
            stream: _firestore
                .collection('archive')
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
                            widget.votes.toString(),
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
}
