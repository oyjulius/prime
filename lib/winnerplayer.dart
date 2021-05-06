import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'background.dart';

class WinnersPlayer extends StatefulWidget {
  final mediaUrl;
  final mediaTitle;
  final artistImage;
  final artistStageName;

  WinnersPlayer({
    this.mediaUrl,
    this.artistImage,
    this.mediaTitle,
    this.artistStageName,
  });

  @override
  _WinnersPlayerState createState() => _WinnersPlayerState();
}

class _WinnersPlayerState extends State<WinnersPlayer> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.mediaUrl);
    _videoPlayerController1.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomPaint(
        painter: BluePainter(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: winnerPlayer(),
          ),
        ),
      ),
    );
  }

  Widget winnerPlayer() {
    final playerWidget = Chewie(
      controller: _chewieController,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: playerWidget),
        Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.artistImage),
                        fit: BoxFit.cover)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stage Name: ' + widget.artistStageName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Performance Title: ' + widget.mediaTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
