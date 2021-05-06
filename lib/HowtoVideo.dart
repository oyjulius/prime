import 'package:chewie/chewie.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:primo_ng/categories.dart';
import 'package:primo_ng/submit_video.dart';
import 'package:video_player/video_player.dart';

class HowToVideo extends StatefulWidget {
  final videoUrl;

  HowToVideo({this.videoUrl});

  @override
  _HowToVideoState createState() => _HowToVideoState();
}

class _HowToVideoState extends State<HowToVideo> {
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  Widget _child = SubmitVideo();

  @override
  void initState() {
    _videoPlayerController1 = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerController2 = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 4 / 6,
      autoPlay: false,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.blue,
          bufferedColor: Colors.lightBlueAccent,
          backgroundColor: Colors.black),
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
        title: Row(
          children: [
            Image(
              image: AssetImage('images/primologo.png'),
              height: 30,
              width: 30,
            ),
            SizedBox(width: 5),
            Text('How to upload a video',
                style: TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              // width: MediaQuery.of(context).size.width,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: [
                      Text(
                        'Simply record a video with your phone, upload the video to '
                        'Google drive which you can also find on your phone or google it.'
                        'Then select share, copy the link and paste it on Primo.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
}
