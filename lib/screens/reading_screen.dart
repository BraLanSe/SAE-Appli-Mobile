import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class ReadingScreen extends StatefulWidget {
  final Book book;

  const ReadingScreen({super.key, required this.book});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  // Settings State
  double _fontSize = 18.0;
  String _fontFamily = 'Serif'; // 'Serif' or 'Sans'
  String _themeMode = 'Light'; // 'Light', 'Sepia', 'Dark'
  bool _controlsVisible = true;

  // Dummy Content Generator
  String get _bookContent => List.generate(
      50,
      (index) =>
          "Chapitre ${index + 1}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. "
          "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, "
          "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
          "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
          "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n"
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, "
          "totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.\n\n").join();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('reader_font_size') ?? 18.0;
      _fontFamily = prefs.getString('reader_font_family') ?? 'Serif';
      _themeMode = prefs.getString('reader_theme_mode') ?? 'Light';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('reader_font_size', _fontSize);
    await prefs.setString('reader_font_family', _fontFamily);
    await prefs.setString('reader_theme_mode', _themeMode);
  }

  Color get _backgroundColor {
    switch (_themeMode) {
      case 'Dark':
        return const Color(0xFF121212); // True Black
      case 'Sepia':
        return const Color(0xFFF4ECD8); // Warm Paper
      case 'Light':
      default:
        return Colors.white;
    }
  }

  Color get _textColor {
    switch (_themeMode) {
      case 'Dark':
        return const Color(0xFFE0E0E0); // Off-white
      case 'Sepia':
        return const Color(0xFF5B4636); // Dark Brown
      case 'Light':
      default:
        return Colors.black87; // Dark Grey
    }
  }

  TextStyle get _textStyle {
    final color = _textColor;
    if (_fontFamily == 'Sans') {
      return GoogleFonts.roboto(fontSize: _fontSize, color: color, height: 1.6);
    } else {
      return GoogleFonts.merriweather(
          fontSize: _fontSize,
          color: color,
          height: 1.8); // Merriweather is great for reading
    }
  }

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          _themeMode == 'Dark' ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final textColor =
                _themeMode == 'Dark' ? Colors.white : Colors.black87;

            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Apparence",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                  const SizedBox(height: 24),

                  // Theme Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildThemeOption(
                          'Light', Colors.white, Colors.black, setModalState),
                      _buildThemeOption('Sepia', const Color(0xFFF4ECD8),
                          const Color(0xFF5B4636), setModalState),
                      _buildThemeOption('Dark', const Color(0xFF121212),
                          Colors.white, setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Font Family Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFontOption(
                          "Sans", GoogleFonts.roboto(), setModalState),
                      _buildFontOption(
                          "Serif", GoogleFonts.merriweather(), setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Font Size Slider
                  Row(
                    children: [
                      Icon(Icons.format_size, size: 20, color: textColor),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 12.0,
                          max: 32.0,
                          divisions: 10,
                          activeColor: Colors.deepPurple,
                          onChanged: (val) {
                            setModalState(() {}); // Local update
                            setState(
                                () => _fontSize = val); // Main screen update
                            _saveSettings();
                          },
                        ),
                      ),
                      Icon(Icons.format_size, size: 30, color: textColor),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeOption(
      String mode, Color bg, Color heavyColor, StateSetter setModalState) {
    final isSelected = _themeMode == mode;
    return GestureDetector(
      onTap: () {
        setModalState(() {});
        setState(() => _themeMode = mode);
        _saveSettings();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? Colors.deepPurple
                  : Colors.grey.withValues(alpha: 0.3),
              width: isSelected ? 3 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)
            ]),
        child: Center(
          child: Text(
            "Aa",
            style: TextStyle(
                color: heavyColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildFontOption(
      String family, TextStyle style, StateSetter setModalState) {
    final isSelected = _fontFamily == family;
    return ChoiceChip(
      label: Text(family,
          style: style.copyWith(color: isSelected ? Colors.white : null)),
      selected: isSelected,
      selectedColor: Colors.deepPurple,
      onSelected: (bool selected) {
        if (selected) {
          setModalState(() {});
          setState(() => _fontFamily = family);
          _saveSettings();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Content
            GestureDetector(
              onTap: () {
                setState(() => _controlsVisible = !_controlsVisible);
              },
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                child: Text(
                  _bookContent,
                  style: _textStyle,
                ),
              ),
            ),

            // Controls (Header)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _controlsVisible ? 0 : -100,
              left: 0,
              right: 0,
              child: Container(
                color: _backgroundColor.withValues(
                    alpha: 0.95), // Semi-transparent header
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: _textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      widget.book.title,
                      style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      icon: Icon(Icons.settings, color: _textColor),
                      onPressed: _showSettingsModal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
