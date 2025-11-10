import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, String> item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FocusNode _playButtonFocus = FocusNode();
  final FocusNode _backButtonFocus = FocusNode();
  int _focusedButton = 0; // 0 = Play, 1 = Back

  @override
  void initState() {
    super.initState();
    // El botón Play tiene el foco inicial
    _playButtonFocus.requestFocus();
  }

  @override
  void dispose() {
    _playButtonFocus.dispose();
    _backButtonFocus.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      setState(() {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _focusedButton = 1;
          _backButtonFocus.requestFocus();
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _focusedButton = 0;
          _playButtonFocus.requestFocus();
        } else if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.select) {
          if (_focusedButton == 0) {
            // Navegar a GameScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );
          } else {
            // Volver atrás
            Navigator.pop(context);
          }
        } else if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.logicalKey == LogicalKeyboardKey.backspace) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _handleKeyEvent,
      autofocus: true,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              widget.item['poster']!,
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
                    widget.item['title']!,
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
                  Row(
                    children: [
                      // Botón Play
                      Focus(
                        focusNode: _playButtonFocus,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()
                            ..scale(_focusedButton == 0 ? 1.1 : 1.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _focusedButton == 0
                                  ? Colors.white
                                  : Colors.white70,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                            ),
                            icon: const Icon(Icons.play_arrow, size: 30),
                            label: const Text(
                              "Play",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Botón Volver
                      Focus(
                        focusNode: _backButtonFocus,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()
                            ..scale(_focusedButton == 1 ? 1.1 : 1.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _focusedButton == 1
                                  ? Colors.white
                                  : Colors.white38,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                            ),
                            icon: const Icon(Icons.arrow_back, size: 30),
                            label: const Text(
                              "Volver",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
