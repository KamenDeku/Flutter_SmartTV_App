import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GameScreen extends StatefulWidget {
  final Map<String, String> item;

  const GameScreen({super.key, required this.item});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final String videoUrl = widget.item['videoUrl']!;
    _controller = videoUrl.startsWith('lib/')
        ? VideoPlayerController.asset(videoUrl)
        : VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
