import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

const Map<String, List<Map<String, String>>> catalogData = {
  "Trending": [
    {"title": "SilkSong", "poster": "lib/assets/posters/silksong.png"},
  ],

  "Indie Games": [
    {"title": "OneShot", "poster": "lib/assets/posters/oneshot.png"},
    {
      "title": "The binding of isaac",
      "poster": "lib/assets/posters/the_binding_of_isaac.png",
    },
    {"title": "Undertale", "poster": "lib/assets/posters/undertale.png"},
  ],

  "Anime like": [
    {
      "title": "Genshin Impact",
      "poster": "lib/assets/posters/genshin_impact.png",
    },
    {
      "title": "Uma Musume: Pretty Derby",
      "poster": "lib/assets/posters/uma_musume_pretty_derby.png",
    },
  ],
};

//--------------------------------------------------------------------------
void main() {
  runApp(const TvGamingApp());
}

class TvGamingApp extends StatelessWidget {
  const TvGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreaMAX Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF141414),
      ),
      home: const HomeScreen(),
    );
  }
}

// --- HomeScreen: The main screen with navigation and catalog ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State to manage the focus position
  int _focusedSection = 0; // 0 for the sidebar, 1 for the content
  int _focusedRow = 0;
  int _focusedCol = 0;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Logic to handle D-Pad navigation
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      setState(() {
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          if (_focusedSection == 0) {
            // Navigation in the sidebar
            _focusedRow = (_focusedRow + 1).clamp(0, 4);
          } else {
            // Navigation in the content
            _focusedRow = (_focusedRow + 1).clamp(
              0,
              catalogData.keys.length - 1,
            );
            _focusedCol = _focusedCol.clamp(
              0,
              catalogData.values.elementAt(_focusedRow).length - 1,
            );
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          if (_focusedSection == 0) {
            _focusedRow = (_focusedRow - 1).clamp(0, 4);
          } else {
            _focusedRow = (_focusedRow - 1).clamp(
              0,
              catalogData.keys.length - 1,
            );
            _focusedCol = _focusedCol.clamp(
              0,
              catalogData.values.elementAt(_focusedRow).length - 1,
            );
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          if (_focusedSection == 0) {
            // Move from the sidebar to the content
            _focusedSection = 1;
            _focusedCol = 0;
          } else {
            // Move between content cards
            _focusedCol = (_focusedCol + 1).clamp(
              0,
              catalogData.values.elementAt(_focusedRow).length - 1,
            );
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (_focusedSection == 1 && _focusedCol > 0) {
            // Move between cards
            _focusedCol--;
          } else {
            // Move from content to the sidebar
            _focusedSection = 0;
          }
        } else if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.select) {
          if (_focusedSection == 1) {
            // If enter is pressed on a card
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
            // --- Side Navigation Bar ---
            _SideNavBar(
              isFocused: _focusedSection == 0,
              focusedIndex: _focusedRow,
            ),
            // --- Content Catalog ---
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

// --- Widget: Side Navigation Bar ---
class _SideNavBar extends StatelessWidget {
  final bool isFocused;
  final int focusedIndex;
  final List<String> navItems = [
    "Home",
    "Series",
    "Movies",
    "My List",
    "Search",
  ];

  _SideNavBar({required this.isFocused, required this.focusedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'StreaMAX',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 60),
          ...List.generate(navItems.length, (index) {
            return _FocusableItem(
              isFocused: isFocused && focusedIndex == index,
              child: Text(
                navItems[index],
                style: const TextStyle(fontSize: 22),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// --- Widget: Main Content Catalog ---
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
                      child: _FocusableItem(
                        isFocused:
                            isFocused &&
                            focusedRow == rowIndex &&
                            focusedCol == colIndex,
                        child: AspectRatio(
                          aspectRatio: 2 / 3,
                          child: Image.network(
                            item['poster']!,
                            fit: BoxFit.cover,
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

// --- Widget: Focusable and animated item ---
class _FocusableItem extends StatelessWidget {
  final bool isFocused;
  final Widget child;

  const _FocusableItem({required this.isFocused, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: isFocused
          ? (Matrix4.identity()..scale(1.1))
          : Matrix4.identity(),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: isFocused
            ? Border.all(color: Colors.red, width: 4)
            : Border.all(color: Colors.transparent, width: 4),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.7),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(4), child: child),
    );
  }
}

// --- DetailScreen: Displays details of a selected item ---
class DetailScreen extends StatelessWidget {
  final Map<String, String> item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.network(
            item['poster']!,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          // Gradient for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF141414),
                  const Color(0xFF141414).withOpacity(0.8),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 1.0],
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
                  "This is an example description for the selected content. The synopsis of the movie or series would be displayed here, along with relevant information such as the cast, director, and release year.",
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(item: item),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, size: 30),
                  label: const Text("Play", style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- PlayerScreen: Plays an example video ---
class PlayerScreen extends StatefulWidget {
  final Map<String, String> item;

  const PlayerScreen({super.key, required this.item});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // CAMBIO: Lee la 'videoUrl' del 'item' que se le pasó al widget
    final String videoUrl = widget.item['videoUrl']!;

    // CAMBIO: Decide qué controlador usar (asset o network) basado en la URL
    if (videoUrl.startsWith('assets/')) {
      // Es un video local
      _controller = VideoPlayerController.asset(videoUrl)
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    } else {
      // Es un video de red
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
    }
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
