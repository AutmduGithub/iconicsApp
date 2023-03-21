// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final String videoLink;
  const Video({Key? key, required this.videoLink}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoLink)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : const CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class LocalVideo extends StatefulWidget {
  final String path;
  const LocalVideo({Key? key, required this.path}) : super(key: key);

  @override
  State<LocalVideo> createState() => _LocalVideoState();
}

class _LocalVideoState extends State<LocalVideo> {
  late VideoPlayerController _localcontroller;

  @override
  void initState() {
    super.initState();
    _localcontroller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {
          _localcontroller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _localcontroller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _localcontroller.value.aspectRatio,
              child: VideoPlayer(_localcontroller),
            )
          : const CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _localcontroller.dispose();
  }
}
