import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_bus_pass_system/home_screen.dart';

class MultilangScreen extends StatefulWidget {
  final Function(Locale) onLanguageSelected; // ✅ Accept Locale now

  const MultilangScreen({Key? key, required this.onLanguageSelected}) : super(key: key);

  @override
  _MultilangScreenState createState() => _MultilangScreenState();
}

class _MultilangScreenState extends State<MultilangScreen> {
  final List<Map<String, dynamic>> _languages = [
    {'name': 'English', 'code': 'en', 'flag': '🇬🇧'},
    {'name': 'हिन्दी', 'code': 'hi', 'flag': '🇮🇳'},
    {'name': 'मराठी', 'code': 'mr', 'flag': '🇮🇳'},
    {'name': 'বাংলা', 'code': 'bn', 'flag': '🇮🇳'},
    {'name': 'தமிழ்', 'code': 'ta', 'flag': '🇮🇳'},
    {'name': 'తెలుగు', 'code': 'te', 'flag': '🇮🇳'},
    {'name': 'ಕನ್ನಡ', 'code': 'kn', 'flag': '🇮🇳'},
    {'name': 'മലയാളം', 'code': 'ml', 'flag': '🇮🇳'},
    {'name': 'ਪੰਜਾਬੀ', 'code': 'pa', 'flag': '🇮🇳'},
    // {'name': 'कोंकणी', 'code': 'kok', 'flag': '🇮🇳'},
  ];

  int? _selectedIndex;

  Future<void> _setLanguage(int index) async {
    try {
      String selectedLangCode = _languages[index]['code'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', selectedLangCode);

      // ✅ Convert to Locale and notify parent
      widget.onLanguageSelected(Locale(selectedLangCode));

      setState(() {
        _selectedIndex = index;
      });
    } catch (e) {
      debugPrint("Error saving language preference: $e");
    }
  }

  void _proceed() {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a language")),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Select Language"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose one language",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      _languages[index]['flag'],
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(_languages[index]['name']),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: _selectedIndex,
                      onChanged: (int? value) {
                        if (value != null) {
                          _setLanguage(value);
                        }
                      },
                    ),
                    onTap: () => _setLanguage(index),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceed,
                child: const Text("Proceed to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

