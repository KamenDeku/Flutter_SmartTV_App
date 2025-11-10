import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GameScreen extends StatefulWidget {
  final Map<String, String> item;

  const GameScreen({super.key, required this.item});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // URL del video de YouTube
    const String youtubeUrl = 'https://www.youtube.com/watch?v=A6DCSSA3r0Y';
    
    // Extrae el ID del video de YouTube
    final String? videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
