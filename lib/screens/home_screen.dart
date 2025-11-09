import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/side_nav_bar.dart';
import '../widgets/focusable_item.dart';
import 'details_screen.dart';

const Map<String, List<Map<String, String>>> catalogData = {
  "Trending": [
    {"title": "SilkSong", "poster": "assets/posters/silksong.png"},
  ],
  "Indie Games": [
    {"title": "OneShot", "poster": "assets/posters/oneshot.png"},
    {
      "title": "The Binding of Isaac",
      "poster": "assets/posters/the_binding_of_isaac.png",
    },
    {"title": "Undertale", "poster": "assets/posters/undertale.png"},
  ],
  "Anime like": [
    {"title": "Genshin Impact", "poster": "assets/posters/genshin_impact.png"},
    {
      "title": "Uma Musume: Pretty Derby",
      "poster": "assets/posters/uma_musume_pretty_derby.png",
    },
  ],
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _focusedSection = 0; // 0 = sidebar, 1 = contenido
  int _focusedRow = 0;
  int _focusedCol = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus(); // Activa el control del teclado al iniciar
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // 🎮 Control de navegación con el teclado del control remoto o D-Pad
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      setState(() {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _focusedRow = (_focusedRow + 1).clamp(0, catalogData.length - 1);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _focusedRow = (_focusedRow - 1).clamp(0, catalogData.length - 1);
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _focusedSection = 1;
          _focusedCol = (_focusedCol + 1).clamp(
            0,
            catalogData.values.elementAt(_focusedRow).length - 1,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (_focusedCol > 0) {
            _focusedCol--;
          } else {
            _focusedSection = 0;
          }
        } else if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.select) {
          if (_focusedSection == 1) {
            final item = catalogData.values.elementAt(_focusedRow)[_focusedCol];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailScreen(item: item)),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: Row(
          children: [
            SideNavBar(
              isFocused: _focusedSection == 0,
              focusedIndex: _focusedRow,
            ),
            Expanded(
              child: _ContentGrid(
                isFocused: _focusedSection == 1,
                focusedRow: _focusedRow,
                focusedCol: _focusedCol,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Catálogo principal de contenido ---
class _ContentGrid extends StatelessWidget {
  final bool isFocused;
  final int focusedRow;
  final int focusedCol;

  const _ContentGrid({
    required this.isFocused,
    required this.focusedRow,
    required this.focusedCol,
  });

  @override
  Widget build(BuildContext context) {
    final categories = catalogData.keys.toList();
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, rowIndex) {
        final category = categories[rowIndex];
        final items = catalogData[category]!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, colIndex) {
                    final item = items[colIndex];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: colIndex == 0 ? 40 : 20,
                        right: colIndex == items.length - 1 ? 40 : 0,
                      ),
                      child: FocusableItem(
                        isFocused:
                            isFocused &&
                            focusedRow == rowIndex &&
                            focusedCol == colIndex,
                        child: Image.asset(item['poster']!, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
