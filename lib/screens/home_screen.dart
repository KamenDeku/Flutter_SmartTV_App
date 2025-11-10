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
  bool _bannerFocused = false;
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
          if (_bannerFocused) {
            // move focus from banner into the first category row
            _bannerFocused = false;
            _focusedRow = 0;
          } else {
            _focusedRow = (_focusedRow + 1).clamp(0, catalogData.length - 1);
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (!_bannerFocused && _focusedRow == 0) {
            // move focus from first row up to the banner
            _bannerFocused = true;
          } else {
            _focusedRow = (_focusedRow - 1).clamp(0, catalogData.length - 1);
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _focusedSection = 1;
          _focusedCol = (_focusedCol + 1).clamp(
            0,
            catalogData.values.elementAt(_focusedRow).length - 1,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (_bannerFocused) {
            // pressing left from the banner moves focus to the sidebar
            _bannerFocused = false;
            _focusedSection = 0;
          } else if (_focusedCol > 0) {
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
      backgroundColor: const Color(0xFF272936),
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
                bannerFocused: _bannerFocused,
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
  final bool bannerFocused;

  const _ContentGrid({
    required this.isFocused,
    required this.focusedRow,
    required this.focusedCol,
    required this.bannerFocused,
  });

  @override
  Widget build(BuildContext context) {
    final categories = catalogData.keys.toList();
    // Use a single ListView so the banner scrolls with the categories.
    return ListView.builder(
      itemCount: categories.length + 1, // +1 for the banner
      itemBuilder: (context, index) {
        if (index == 0) {
          // Banner as the first scrollable item
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = MediaQuery.of(context).size.height;
                final targetHeight = (isFocused && bannerFocused)
                    ? screenHeight * 0.5
                    : 140.0;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: targetHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.black26,
                    // Show a green border and glow when the banner is focused
                    border: (isFocused && bannerFocused)
                        ? Border.all(color: Colors.green, width: 3)
                        : null,
                    boxShadow: (isFocused && bannerFocused)
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ]
                        : null,
                    image: DecorationImage(
                      image: AssetImage(catalogData.values.first[0]['poster']!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black45,
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Featured',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        // Category items (shift index by -1 because 0 is banner)
        final rowIndex = index - 1;
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
                    color: Colors.white,
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
                            !bannerFocused &&
                            focusedRow == rowIndex &&
                            focusedCol == colIndex,
                        child: SizedBox(
                          width: 160,
                          height: 240,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              item['poster']!,
                              fit: BoxFit.cover,
                              width: 160,
                              height: 240,
                            ),
                          ),
                        ),
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
