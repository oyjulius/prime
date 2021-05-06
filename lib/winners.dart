import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:primo_ng/background.dart';
import 'package:primo_ng/categories.dart';
import 'package:primo_ng/submit_video.dart';
import 'package:primo_ng/winnerplayer.dart';

class Winners extends StatefulWidget {
  @override
  _WinnersState createState() => _WinnersState();
}

class _WinnersState extends State<Winners> {
  Widget _child;
  String mediaUrl = '';
  String mediaTitle = '';
  String artistImage = '';
  String artistStageName = '';

  DateTime now = DateTime.now();
  Timestamp firebaseTime;
  Timestamp duration;
  int voteDuration = 1;
  String seasonName;
  String contestcategory;

  @override
  void initState() {
    super.initState();
    getTime();
    getActiveSeason();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Winners'),
      ),
      body: CustomPaint(
        painter: BluePainter(),
        child: voteDuration < 0
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Text(
                                'This season \nwinners',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 22,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('images/primo.jpg'),
                        fit: BoxFit.cover,
                      )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                  height: 180,
                                  width: 150,
                                  child: MusicWinner())),
                          Expanded(
                              child: Container(
                                  height: 180,
                                  width: 150,
                                  child: ComedyWinner())),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                  height: 180,
                                  width: 150,
                                  child: DanceWinner())),
                          Expanded(
                            child: Container(
                                height: 180, width: 150, child: SkitWinner()),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                  height: 180,
                                  width: 150,
                                  child: ModellingWinner())),
                          Expanded(
                            child: Container(
                                height: 180,
                                width: 150,
                                child: PhotographyWinner()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              icon: Icons.where_to_vote_outlined,
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

  Widget MusicWinner() {
    return Container(
      height: 50,
      width: 50,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('submissions')
              .where('seasonName', isEqualTo: seasonName)
              .where('contestcategory', isEqualTo: 'music')
              .where('approval', isEqualTo: true)
              .orderBy('votes', descending: true)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  children: snapshot.data.docs.map((document) {
                    return Stack(
                      children: [
                        GridTile(
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(document['artistphoto']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          header: Container(
                            height: 20,
                            // width: double.minPositive,
                            color: Colors.white,
                            child: Text(
                              'Music Winner',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          footer: Container(
                            color: Colors.white,
                            child: Text(
                              document['stagename'],
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WinnersPlayer(
                                          mediaTitle: document['videotitle'],
                                          mediaUrl: document['videourl'],
                                          artistImage: document['artistphoto'],
                                          artistStageName:
                                              document['stagename'],
                                        )));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList());
          }),
    );
  }

  Widget ComedyWinner() {
    return Container(
      height: 50,
      width: 50,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('submissions')
              .where('seasonName', isEqualTo: seasonName)
              .where('contestcategory', isEqualTo: 'comedy')
              .where('approval', isEqualTo: true)
              .orderBy('votes', descending: true)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  children: snapshot.data.docs.map((document) {
                    return Stack(
                      children: [
                        GridTile(
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(document['artistphoto']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          header: Container(
                            height: 20,
                            color: Colors.white,
                            child: Text(
                              'Comedy Winner',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          footer: Container(
                            color: Colors.white,
                            child: Text(
                              document['stagename'],
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WinnersPlayer(
                                          mediaTitle: document['videotitle'],
                                          mediaUrl: document['videourl'],
                                          artistImage: document['artistphoto'],
                                          artistStageName:
                                              document['stagename'],
                                        )));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList());
          }),
    );
  }

  Widget SkitWinner() {
    return Container(
      height: 50,
      width: 50,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('submissions')
              .where('seasonName', isEqualTo: seasonName)
              .where('contestcategory', isEqualTo: 'skits')
              .where('approval', isEqualTo: true)
              .orderBy('votes', descending: true)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  children: snapshot.data.docs.map((document) {
                    // mediaUrl = document['videourl'];
                    // print('MediaUrl is: $mediaUrl');
                    return Stack(
                      children: [
                        GridTile(
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(document['artistphoto']),
                                  fit: BoxFit.cover,
                                  // colorFilter: ColorFilter.mode(
                                  //     Colors.blue, BlendMode.overlay),
                                ),
                              ),
                            ),
                          ),
                          header: Container(
                            height: 20,
                            // width: double.minPositive,
                            color: Colors.white,
                            child: Text(
                              'Skit Winner',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          footer: Container(
                            color: Colors.white,
                            child: Text(
                              document['stagename'],
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WinnersPlayer(
                                          mediaTitle: document['videotitle'],
                                          mediaUrl: document['videourl'],
                                          artistImage: document['artistphoto'],
                                          artistStageName:
                                              document['stagename'],
                                        )));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList());
          }),
    );
  }

  Widget DanceWinner() {
    return Container(
      height: 50,
      width: 50,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('submissions')
              .where('seasonName', isEqualTo: seasonName)
              .where('contestcategory', isEqualTo: 'dance')
              .where('approval', isEqualTo: true)
              .orderBy('votes', descending: true)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  children: snapshot.data.docs.map((document) {
                    return Stack(
                      children: [
                        GridTile(
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(document['artistphoto']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          header: Container(
                            height: 20,
                            // width: double.minPositive,
                            color: Colors.white,
                            child: Text(
                              'Dance Winner',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          footer: Container(
                            color: Colors.white,
                            child: Text(
                              document['stagename'],
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WinnersPlayer(
                                          mediaTitle: document['videotitle'],
                                          mediaUrl: document['videourl'],
                                          artistImage: document['artistphoto'],
                                          artistStageName:
                                              document['stagename'],
                                        )));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList());
          }),
    );
  }

  Widget PhotographyWinner() {
    return Container(
      height: 50,
      width: 50,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('submissions')
              .where('seasonName', isEqualTo: seasonName)
              .where('contestcategory', isEqualTo: 'photography')
              .where('approval', isEqualTo: true)
              .orderBy('votes', descending: true)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  children: snapshot.data.docs.map((document) {
                    return Stack(
                      children: [
                        GridTile(
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(document['artistphoto']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          header: Container(
                            height: 20,
                            color: Colors.white,
                            child: Text(
                              'Photography Winner',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          footer: Container(
                            color: Colors.white,
                            child: Text(
                              document['stagename'],
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WinnersPlayer(
                                          mediaTitle: document['videotitle'],
                                          mediaUrl: document['videourl'],
                                          artistImage: document['artistphoto'],
                                          artistStageName:
                                              document['stagename'],
                                        )));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList());
          }),
    );
  }

  Widget ModellingWinner() {
    return Container(
      height: 50,
      width: 50,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('submissions')
              .where('seasonName', isEqualTo: seasonName)
              .where('contestcategory', isEqualTo: 'modelling')
              .where('approval', isEqualTo: true)
              .orderBy('votes', descending: true)
              .limit(1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  children: snapshot.data.docs.map((document) {
                    return Stack(
                      children: [
                        GridTile(
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(document['artistphoto']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          header: Container(
                            height: 20,
                            color: Colors.white,
                            child: Text(
                              'Modelling Winner',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          footer: Container(
                            color: Colors.white,
                            child: Text(
                              document['stagename'],
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WinnersPlayer(
                                          mediaTitle: document['videotitle'],
                                          mediaUrl: document['videourl'],
                                          artistImage: document['artistphoto'],
                                          artistStageName:
                                              document['stagename'],
                                        )));
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList());
          }),
    );
  }

  Future getActiveSeason() async {
    await FirebaseFirestore.instance
        .collection('settings')
        .doc('seasons')
        .get()
        .then((value1) {
      setState(() {
        seasonName = value1['activeSeason'].toString();
      });
    });
  }

  Future getTime() async {
    await FirebaseFirestore.instance
        .collection('settings')
        .doc('seasons')
        .get()
        .then((timeValue) async {
      setState(() {
        Timestamp i = Timestamp.fromDate(now);
        firebaseTime = timeValue['duration'];
        voteDuration = firebaseTime.compareTo(i).toInt();
      });
    });
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
}
