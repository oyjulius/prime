import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:primo_ng/archive.dart';
import 'package:primo_ng/categories.dart';
import 'package:primo_ng/submit_video.dart';
import 'package:primo_ng/videoPlayerScreen.dart';

class Modelling extends StatefulWidget {
  @override
  _ModellingState createState() => _ModellingState();
}

class _ModellingState extends State<Modelling> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isCompetitionOn = false;
  Widget _child;

  @override
  void initState() {
    checkContest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 4.0,
        title: Text('Modelling'),
      ),
      body: isCompetitionOn == true
          ? CustomPaint(
              painter: BluePainter(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: leading(),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: first(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : noData(),
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: MaterialCommunityIcons.card_account_mail,
              backgroundColor: Colors.blue,
              selectedForegroundColor: Colors.white,
              unselectedForegroundColor: Colors.white,
              extras: {"label": "Contest"}),
          FluidNavBarIcon(
              icon: Icons.circle,
              backgroundColor: Colors.blue,
              selectedForegroundColor: Colors.white,
              unselectedForegroundColor: Colors.white,
              extras: {"label": "Stats"}),
          FluidNavBarIcon(
              icon: Icons.home,
              backgroundColor: Colors.blue,
              selectedForegroundColor: Colors.white,
              unselectedForegroundColor: Colors.white,
              extras: {"label": "Home"}),
        ],
        onChange: _handleNavigationChange,
        style: FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.lightBlue,
            barBackgroundColor: Colors.blue.shade800),
        defaultIndex: 1,
        scaleFactor: 1.5,
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras["label"],
          child: item,
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = gotoNextSeason();
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
  gotoNextSeason() {
    Future.delayed(Duration(seconds: 1)).whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SubmitVideo()));
    });
  }

  Widget leading() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/model.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade800.withOpacity(0.5),
                    Colors.black.withOpacity(0.7)
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Text(
                          'Vote',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Your Favorite Model',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget first() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('submissions')
                  .where('contestcategory', isEqualTo: 'modelling')
                  .where('approval', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshort) {
                if (!snapshort.hasData) {
                  return Center(
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text(
                            'New contest coming soon',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else
                  return GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    children: snapshort.data.docs.map((document) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                        artistdisplayname:
                                            document['artistdisplayname'],
                                        artistemail: document['artistemail'],
                                        artistphoto: document['artistphoto'],
                                        artistuid: document['artistuid'],
                                        contestcategory:
                                            document['contestcategory'],
                                        stagename: document['stagename'],
                                        videotitle: document['videotitle'],
                                        videourl: document['videourl'],
                                        likes: document['likes'],
                                        dislikes: document['dislikes'],
                                        seasonName: document['seasonName'],
                                        seasonWinner: document['seasonWinner'],
                                        seen: document['seen'],
                                        shared: document['shared'],
                                        votes: document['votes'],
                                        approval: document['approval'],
                                      )));
                        },
                        child: Card(
                          elevation: 4.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(06.0),
                              color: document['selectedcolor'] == null
                                  ? Colors.blue.shade800
                                  : Color(document['selectedcolor'])
                                      .withOpacity(1),
                            ),
                            child: Stack(
                              //fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(05.0),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(document['artistphoto']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(bottom: 25),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.account_box_rounded,
                                        size: 10.0,
                                        color: Colors.white,
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.orange),
                                      width: 20,
                                      height: 20,
                                    ),
                                    Wrap(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          document['stagename'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }),
        ),
      ),
    );
  }

  Widget noData() {
    return CustomPaint(
      painter: BluePainter(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: leading(),
              ),
              SizedBox(height: 15),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Wrap(
                          children: [
                            Text(
                              'No running contest at the moment. Check back later. But you can at least view our archive:',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Archive()));
                            },
                            child: Icon(
                              Icons.video_collection,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkContest() {
    _firestore.collection('submissions').get().then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          isCompetitionOn = true;
        });
      }
    });
  }
}
