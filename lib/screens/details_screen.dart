import 'package:flutter/material.dart';
import 'game_screen.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, String> item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            item['poster']!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [const Color(0xFF141414), Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Descripción breve del juego o anime. Aquí podrías mostrar sinopsis, desarrollador, o año de lanzamiento.",
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(item: item),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, size: 30),
                  label: const Text("Play", style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
