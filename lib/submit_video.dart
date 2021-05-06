import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:primo_ng/HowtoVideo.dart';
import 'package:primo_ng/categories.dart';
import 'package:primo_ng/components/rounded_button.dart';

String publicKey = 'pk_test_b0bcaa7a1b270176db843c11319cac204909be64';

enum Categorie { music, dance, skits, comedy, modelling, photography }

class SubmitVideo extends StatefulWidget {
  // SubmitVideo({this.isContest});
  @override
  _SubmitVideoState createState() => _SubmitVideoState();
}

class _SubmitVideoState extends State<SubmitVideo> {
  var publicKey = 'pk_test_b0bcaa7a1b270176db843c11319cac204909be64';
  final plugin = PaystackPlugin();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(4279592384);
  bool musiccontest = false;
  bool dancecontest = false;
  bool skitcontest = false;
  bool comedycontest = false;
  bool modellingcontest = false;
  bool photographycontest = false;
  final textEditingController = TextEditingController();
  final textEditingController2 = TextEditingController();
  final textEditingController3 = TextEditingController();
  bool showSpinner = false;
  String videoUrl = "";
  String videoTitle = "";
  String stageName = "";
  Categorie contestcate = Categorie.music;
  int countThis;
  bool isContest = true;
  String seasonName;
  String newVideoUrl;
  int amount;
  DateTime now = DateTime.now();
  String videoTutorial;
  String username = 'support@primo.ng';
  String password = 'foryoume@1';

  @override
  void initState() {
    super.initState();
    checkContest();
    getActiveSeason();
    getContests();
    getTutorialVideo();
    plugin.initialize(publicKey: publicKey);
    Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return isContest == true
        ? Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Image(
                    image: AssetImage('images/primologo.png'),
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(width: 5),
                  Text('Submit a video to contest',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 130.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/break.jpg'),
                            fit: BoxFit.cover)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextField(
                                  controller: textEditingController,
                                  keyboardType: TextInputType.url,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    videoUrl = value;
                                    setState(() {
                                      String t = videoUrl.replaceAll(
                                          'https://drive.google.com/file/d/',
                                          '');
                                      String tt = t.replaceAll(
                                          '/view?usp=drivesdk', '');
                                      newVideoUrl = tt;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Paste your video link here',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              Card(
                                color: Colors.blue.withOpacity(0.6),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HowToVideo(
                                                videoUrl: videoTutorial,
                                              ))),
                                  child: Container(
                                    width: 60,
                                    height: 40,
                                    child: Column(
                                      children: [
                                        Icon(
                                          MaterialCommunityIcons.video,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'How_To',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: TextField(
                            // maxLength: 22,
                            controller: textEditingController2,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              videoTitle = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Your Video Title',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(22),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: TextField(
                            controller: textEditingController3,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              stageName = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Your Stage / Trademark name',
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(16),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 8.0),
                              child: Text(
                                'Select your contest group',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          child: Container(
                            height: 170,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: musiccontest == true
                                          ? RadioListTile(
                                              title: Text(
                                                "Music",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              value: Categorie.music,
                                              groupValue: contestcate,
                                              onChanged: (Categorie value) {
                                                setState(() {
                                                  contestcate = value;
                                                });
                                              })
                                          : Text(''),
                                    ),
                                    Expanded(
                                      child: comedycontest == true
                                          ? RadioListTile(
                                              title: Text(
                                                "Comedy",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              value: Categorie.comedy,
                                              groupValue: contestcate,
                                              onChanged: (Categorie value) {
                                                setState(() {
                                                  contestcate = value;
                                                });
                                              })
                                          : Text(''),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: dancecontest == true
                                          ? RadioListTile(
                                              title: Text(
                                                "Dance",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              value: Categorie.dance,
                                              groupValue: contestcate,
                                              onChanged: (Categorie value) {
                                                setState(() {
                                                  contestcate = value;
                                                });
                                              })
                                          : Text(''),
                                    ),
                                    Expanded(
                                      child: skitcontest == true
                                          ? RadioListTile(
                                              title: Text(
                                                "Sports",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              value: Categorie.skits,
                                              groupValue: contestcate,
                                              onChanged: (Categorie value) {
                                                setState(() {
                                                  contestcate = value;
                                                });
                                              })
                                          : Text(''),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: modellingcontest == true
                                          ? RadioListTile(
                                              title: Text(
                                                "Modelling",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              value: Categorie.modelling,
                                              groupValue: contestcate,
                                              onChanged: (Categorie value) {
                                                setState(() {
                                                  contestcate = value;
                                                });
                                              })
                                          : Text(''),
                                    ),
                                    Expanded(
                                      child: photographycontest == true
                                          ? RadioListTile(
                                              title: Text(
                                                "Photography",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              value: Categorie.photography,
                                              groupValue: contestcate,
                                              onChanged: (Categorie value) {
                                                setState(() {
                                                  contestcate = value;
                                                });
                                              })
                                          : Text(''),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: Container(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 230,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'You may select preferrable color for your backdrop',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Pick a color!'),
                                              content: SingleChildScrollView(
                                                child: ColorPicker(
                                                  pickerColor: pickerColor,
                                                  onColorChanged: changeColor,
                                                  showLabel: true,
                                                  pickerAreaHeightPercent: 0.8,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child:
                                                      const Text('Set Color'),
                                                  onPressed: () {
                                                    setState(() =>
                                                        currentColor =
                                                            pickerColor);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: FittedBox(
                                          child: Icon(
                                            Icons.format_color_fill,
                                            color: currentColor,
                                          ),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.lightBlueAccent.withOpacity(0.2),
              height: 80,
              child: RoundedButton(
                title: 'Submit',
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  submitVideo();
                },
              ),
            ),
          )
        : waitingPage();
  }

  Future submitVideo() async {
    if (videoUrl.isEmpty ||
        videoTitle.isEmpty ||
        stageName.isEmpty ||
        contestcate == null) {
      Fluttertoast.showToast(
          msg: 'All fields must be completed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white70);
    } else if (isContest == false) {
      Fluttertoast.showToast(
          msg:
              'We have come to the end of current contest. New contest coming soon.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white70);
    } else if (seasonName.isEmpty == true) {
      Fluttertoast.showToast(
          msg: 'Technical error, please try again later.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white70);
    } else
      chargeClient();
  }

  waitingPage() {
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
                        height: 80,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['Contests Closed'],
                    textStyle: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    splashColor: Colors.white,
                    color: Colors.deepOrangeAccent,
                    onPressed: () {},
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
                              'New season is coming soon',
                              style: TextStyle(
                                fontSize: 15.0,
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

  Future chargeClient() async {
    await firestore
        .collection('settings')
        .doc('paystack')
        .get()
        .then((value) async {
      setState(() {
        countThis = value['reference'] + 1;
      });
    }).whenComplete(() async {
      Charge charge = Charge()
        ..amount = amount
        ..reference = 'Ref: ' + (countThis).toString()
        ..email = auth.currentUser.email;
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
      );
      if (response.status == true) {
        submit().whenComplete(() async {
          await firestore
              .collection('settings')
              .doc('paystack')
              .update({'reference': FieldValue.increment(1)});
        });
      } else {
        await Fluttertoast.showToast(
          msg: "Payment unsuccessful! Please try again",
          textColor: Colors.white,
          backgroundColor: Colors.redAccent,
        );
      }
    });
  }

  Future submit() async {
    int selectedColor = currentColor.value;
    try {
      String ss = contestcate.toString();
      String s = (ss.replaceAll("Categorie.", ""));
      await firestore.collection('submissions').add({
        'videourl':
            'https://drive.google.com/uc?export=download&id=' + newVideoUrl,
        'videotitle': videoTitle,
        'stagename': stageName,
        'artistphoto': auth.currentUser.photoURL,
        'artistuid': auth.currentUser.uid,
        'artistdisplayname': auth.currentUser.displayName,
        'artistemail': auth.currentUser.email,
        'contestcategory': s,
        'approval': false,
        'likes': 0,
        'dislikes': 0,
        'shared': 0,
        'seasonWinner': false,
        'votes': 0,
        'seen': 0,
        'seasonName': seasonName,
        'selectedcolor': selectedColor,
        'timestamp': now,
      }).then((value) {
        if (value.id.isNotEmpty) {
          sendImail().whenComplete(() {
            textEditingController.clear();
            textEditingController2.clear();
            textEditingController3.clear();
            Fluttertoast.showToast(
                    msg: 'Submission Successful',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.lightBlueAccent,
                    textColor: Colors.white)
                .whenComplete(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Categories()));
            });
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Error, try again please.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white);
        }
      });
    } catch (e) {
      print('//////////////////////////// ERROR: ' + e.toString());
    }
  }

  Future checkContest() async {
    await firestore.collection('settings').doc('contest').get().then((value) {
      setState(() {
        isContest = value['isActive'];
        amount = value['price'];
      });
    });
  }

  Future getActiveSeason() async {
    await firestore.collection('settings').doc('seasons').get().then((value1) {
      setState(() {
        seasonName = value1['activeSeason'].toString();
      });
    });
  }

  Future getContests() async {
    await FirebaseFirestore.instance
        .collection('settings')
        .doc('contest')
        .get()
        .then((contest) {
      setState(() {
        musiccontest = contest['music'];
        dancecontest = contest['dance'];
        skitcontest = contest['skit'];
        comedycontest = contest['comedy'];
        modellingcontest = contest['modelling'];
        photographycontest = contest['photography'];
      });
    });
  }

  Future getTutorialVideo() async {
    await firestore.collection('settings').doc('tutorial').get().then((value) {
      setState(() {
        videoTutorial = value.get('howto');
      });
    });
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> sendImail() async {
    String clientmail = auth.currentUser.email;
    final smtpServer = SmtpServer('primo.ng',
        port: 465,
        name: 'Primo Nigeria',
        username: username,
        password: password,
        ssl: true);

    final message = Message()
      ..from = Address('support@primo.ng', 'Primo Nigeria')
      ..recipients.add(clientmail)
      //..ccRecipients.addAll(['info@primo.ng'])
      ..subject = 'Primo Submission Receipt'
      ..html =
          "Dear Contestant,\n<p><br>Your video has been submitted successful!<br>It is now being reviewed and it will be activated shortly for contest.</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
