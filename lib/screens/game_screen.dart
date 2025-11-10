import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final String _iframeId = 'youtube-player-iframe';

  @override
  void initState() {
    super.initState();
    _registerIframe();
  }

  void _registerIframe() {
    // ID del video de YouTube
    const String youtubeVideoId = 'A6DCSSA3r0Y';
    final String embedUrl = 
        'https://www.youtube.com/embed/$youtubeVideoId?autoplay=1&mute=0&controls=1&rel=0&modestbranding=1&playsinline=1';
    
    // Crea el elemento iframe para embeber YouTube
    final html.IFrameElement iframe = html.IFrameElement()
      ..src = embedUrl
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
      ..allowFullscreen = true;

    // Registra el iframe en la plataforma web
    ui_web.platformViewRegistry.registerViewFactory(
      _iframeId,
      (int viewId) => iframe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Iframe de YouTube embebido
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: HtmlElementView(viewType: _iframeId),
            ),
          ),
          // Overlay con info del "juego en la nube"
          Positioned(
            top: 40,
            left: 40,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.cloud, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '🎮 Jugando en la nube',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botón de regreso
          Positioned(
            top: 40,
            right: 40,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
