import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:primo_ng/videoPlayerScreen.dart';

class Statistics extends StatefulWidget {
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
  Statistics({
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
  });
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  String prize = '';

  @override
  void initState() {
    super.initState();
    getPrize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contestcategory + ' rankings',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            statHeader(),
            Container(
              child: CustomPaint(
                painter: BluePainter(),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('submissions')
                      .where('seasonName', isEqualTo: widget.seasonName)
                      .where('contestcategory',
                          isEqualTo: widget.contestcategory)
                      .where('approval', isEqualTo: true)
                      .orderBy('votes', descending: true)
                      .limit(10)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Awaiting Results',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 2),
                            )
                          ],
                        ),
                      );
                    } else
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Top 10 leading votes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      wordSpacing: 1.5,
                                      height: 1.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                children: snapshot.data.docs.map((document) {
                                  return Container(
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayerScreen(
                                                        artistdisplayname: document[
                                                            'artistdisplayname'],
                                                        artistemail: document[
                                                            'artistemail'],
                                                        artistphoto: document[
                                                            'artistphoto'],
                                                        artistuid: document[
                                                            'artistuid'],
                                                        contestcategory: document[
                                                            'contestcategory'],
                                                        stagename: document[
                                                            'stagename'],
                                                        videotitle: document[
                                                            'videotitle'],
                                                        videourl: document[
                                                            'videourl'],
                                                        likes:
                                                            document['likes'],
                                                        dislikes: document[
                                                            'dislikes'],
                                                        seasonName: document[
                                                            'seasonName'],
                                                        seasonWinner: document[
                                                            'seasonWinner'],
                                                        seen: document['seen'],
                                                        shared:
                                                            document['shared'],
                                                        votes:
                                                            document['votes'],
                                                        approval: document[
                                                            'approval'],
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: GridTile(
                                            footer: Container(
                                              color:
                                                  Colors.blue.withOpacity(0.7),
                                              child: ListTile(
                                                leading: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      document['stagename'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      document['votes']
                                                              .toString() +
                                                          ' Vote',
                                                      style: (TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            child: Image.network(
                                              document['artistphoto'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statHeader() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/primo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0, bottom: 30.0),
            child: Column(
              children: [
                Text(
                  'Winner wins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  prize,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getPrize() async {
    await FirebaseFirestore.instance
        .collection('settings')
        .doc('prizes')
        .get()
        .then((value) {
      if (value[widget.contestcategory].toString().isNotEmpty) {
        setState(() {
          prize = value[widget.contestcategory.toString()];
        });
      } else {
        setState(() {
          prize = 'High Prize';
        });
      }
    });
  }
}
