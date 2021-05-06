import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:primo_ng/archivePlayer.dart';
import 'package:primo_ng/background.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  List<String> seasonName = ['Filter By Season'];
  String season;

  @override
  void initState() {
    getSeasons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return seasonName.length > 1
        ? Scaffold(
            appBar: AppBar(
              title: Container(
                // height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.mirror,
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image(
                          image: AssetImage('images/primologo.png'),
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Archive',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: CustomPaint(
              painter: BluePainter(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    searchBar(),
                    Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: season != null && season != 'Filter By Season'
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('archive')
                                  .where('seasonName', isEqualTo: season)
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 10),
                                        Text(
                                          'No archive content yet',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else
                                  return GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    children:
                                        snapshot.data.docs.map((document) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ArchivePlayer(
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
                                        child: Card(
                                          elevation: 4.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(06.0),
                                              color: Colors.blue.shade800,
                                            ),
                                            child: Stack(
                                              //fit: StackFit.expand,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            05.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          document[
                                                              'artistphoto']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: 25),
                                                  child: Center(
                                                    child: Icon(
                                                      MaterialCommunityIcons
                                                          .play_circle_outline,
                                                      size: 15,
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    document['seasonWinner'] ==
                                                            true
                                                        ? Row(
                                                            children: [
                                                              Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .account_box_rounded,
                                                                  size: 10.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .orange),
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                document[
                                                                        'contestcategory'] +
                                                                    ' winner',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            document[
                                                                'contestcategory'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                    Wrap(
                                                      //mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          document[
                                                                  'seasonName'] +
                                                              ' season',
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      document['stagename'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
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
                              })
                          : StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('archive')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 10),
                                        Text(
                                          'No archive content yet',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else
                                  return GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    children:
                                        snapshot.data.docs.map((document) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ArchivePlayer(
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
                                        child: Card(
                                          elevation: 4.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(06.0),
                                              color: Colors.blue.shade800,
                                            ),
                                            child: Stack(
                                              //fit: StackFit.expand,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            05.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          document[
                                                              'artistphoto']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: 25),
                                                  child: Center(
                                                    child: Icon(
                                                      MaterialCommunityIcons
                                                          .play_circle_outline,
                                                      size: 15,
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    document['seasonWinner'] ==
                                                            true
                                                        ? Row(
                                                            children: [
                                                              Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .account_box_rounded,
                                                                  size: 10.0,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .orange),
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                document[
                                                                        'contestcategory'] +
                                                                    ' winner',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            document[
                                                                'contestcategory'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                    Wrap(
                                                      //mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          document[
                                                                  'seasonName'] +
                                                              ' season',
                                                          style: TextStyle(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      document['stagename'],
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
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
                  ],
                ),
              ),
            ),
          )
        : waiting();
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        children: [
          Card(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.mirror,
              )),
              padding: EdgeInsets.only(left: 10, right: 10),
              //color: Colors.blueGrey,
              child: DropdownButtonFormField(
                value: season,
                onChanged: (itemvalue) {
                  setState(() {
                    season = itemvalue.toString();
                    print('Selected season: ' + season);
                  });
                },
                items: seasonName.map((itemvalue) {
                  return DropdownMenuItem(
                      value: itemvalue, child: Text(itemvalue));
                }).toList(),

                icon: Icon(Icons.search),
                iconEnabledColor: Colors.greenAccent,
                iconDisabledColor: Colors.white.withOpacity(0.6),
                //isExpanded: true,
                elevation: 4,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                hint: Text(
                  'Filter By Season',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                dropdownColor: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getSeasons() async {
    FirebaseFirestore.instance.collection('archive').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          String unit = element['seasonName'.toString()];
          if (!seasonName.contains(unit)) {
            seasonName.add(unit);
          }
        });
      });
    });
  }

  waiting() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/primonigeria.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.lightBlue, BlendMode.overlay),
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
                    height: 150,
                  ),
                  Center(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image(
                          image: AssetImage('images/primo.png'),
                          height: 70,
                          width: 200,
                        ),
                        height: 70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['No Archive Yet'],
                    textStyle: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Until end of first season.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 2.0,
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
}
