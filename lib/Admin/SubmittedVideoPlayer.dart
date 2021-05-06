import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SubmittedVideoPlayer extends StatefulWidget {
  final videoUrl;
  SubmittedVideoPlayer({
    this.videoUrl,
  });
  @override
  _SubmittedVideoPlayerState createState() => _SubmittedVideoPlayerState();
}

class _SubmittedVideoPlayerState extends State<SubmittedVideoPlayer> {
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  //Widget _child;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerController2 = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
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
        title: Text('Submitted Video'),
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
              height: 230,
              width: MediaQuery.of(context).size.width,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
