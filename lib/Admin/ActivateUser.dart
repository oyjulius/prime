import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:primo_ng/Admin/SubmittedVideoPlayer.dart';
import 'package:primo_ng/background.dart';

class ActivateUser extends StatefulWidget {
  @override
  _ActivateUserState createState() => _ActivateUserState();
}

class _ActivateUserState extends State<ActivateUser> {
  bool activate = false;
  String videoTitle = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activate User'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/primonigeria.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottomSheet: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 15,
              child: Text(
                'Tap on image for video, activate with orange icon',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('submissions')
                    .where('approval', isNotEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData != true) {
                    return Center(
                      child: Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'No Submission yet.',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          )),
                    );
                  } else
                    return CustomPaint(
                      painter: BluePainter(),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          children: snapshot.data.docs.map((document) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubmittedVideoPlayer(
                                                    videoUrl:
                                                        document['videourl'],
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                document['artistphoto']),
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.blue,
                                                BlendMode.overlay)),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, right: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            document['videotitle'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await doActivation(
                                                  document['videotitle']);
                                            },
                                            child: Icon(
                                              Icons.verified,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  doActivation(String video) async {
    await FirebaseFirestore.instance
        .collection('submissions')
        .where('videotitle', isEqualTo: video)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          element.reference.update({
            'approval': true,
          });
        });
      }
    });
  }
}
