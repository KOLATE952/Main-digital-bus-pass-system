// // TODO Implement this library.
//
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter/material.dart';
//
// class VoiceAssistant {
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//   bool _isListening = false;
//
//   Future<void> init() async {
//     await _speech.initialize();
//   }
//
//   void startListening(BuildContext context) {
//     _speech.listen(
//       onResult: (result) {
//         String command = result.recognizedWords.toLowerCase();
//         _processCommand(command, context);
//       },
//     );
//     _isListening = true;
//   }
//
//   void stopListening() {
//     _speech.stop();
//     _isListening = false;
//   }
//
//   void _processCommand(String command, BuildContext context) {
//     if (command.contains("show my pass")) {
//       _speak("Opening your pass");
//       Navigator.pushNamed(context, '/showPass');
//     } else if (command.contains("renew my pass")) {
//       _speak("Opening renew pass page");
//       Navigator.pushNamed(context, '/renewPass');
//     } else if (command.contains("track my bus")) {
//       _speak("Opening bus tracking");
//       Navigator.pushNamed(context, '/trackBus');
//     } else {
//       _speak("Sorry, I didn’t understand that.");
//     }
//   }
//
//   void _speak(String text) async {
//     await _tts.speak(text);
//   }
// }

// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:flutter/material.dart';
//
// class VoiceAssistant {
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//   bool _isListening = false;
//
//   bool get isListening => _isListening;
//
//   // Initialize speech recognition
//   Future<void> init() async {
//     await _speech.initialize();
//   }
//
//   // Start listening to the user's voice
//   void startListening(BuildContext context) {
//     _speech.listen(
//       onResult: (result) {
//         String command = result.recognizedWords.toLowerCase();
//         _processCommand(command, context);
//       },
//     );
//     _isListening = true;
//   }
//
//   // Stop listening
//   void stopListening() {
//     _speech.stop();
//     _isListening = false;
//   }
//
//   // Process voice commands
//   void _processCommand(String command, BuildContext context) {
//     if (command.contains("show my pass")) {
//       _speak("Opening your pass");
//       Navigator.pushNamed(context, '/showPass');
//     } else if (command.contains("renew my pass")) {
//       _speak("Opening renew pass page");
//       Navigator.pushNamed(context, '/renewPass');
//     } else if (command.contains("track my bus")) {
//       _speak("Opening bus tracking");
//       Navigator.pushNamed(context, '/trackBus');
//     } else {
//       _speak("Sorry, I didn’t understand that.");
//     }
//   }
//
//   // Speak the given text
//   void _speak(String text) async {
//     await _tts.speak(text);
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// class VoiceAssistant {
//   final SpeechToText _speechToText = SpeechToText();
//
//   Future<void> init() async {
//     await _speechToText.initialize();
//   }
//
//   void startListening(BuildContext context) async {
//     if (!_speechToText.isListening) {
//       await _speechToText.listen(onResult: (result) {
//         final recognizedText = result.recognizedWords.toLowerCase();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Heard: $recognizedText")),
//         );
//         // Add your custom commands here
//       });
//     }
//   }
//
//   void stopListening() {
//     if (_speechToText.isListening) {
//       _speechToText.stop();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceAssistant {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  void init() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('Speech status: $status'),
      onError: (error) => debugPrint('Speech error: $error'),
    );

    if (!available) {
      debugPrint("Speech recognition not available.");
    }
  }

  void startListening(BuildContext context) async {
    if (!_isListening) {
      _isListening = true;
      await _speech.listen(
        onResult: (result) {
          String command = result.recognizedWords.toLowerCase();
          debugPrint("Recognized command: $command");

          // Example actions based on command
          if (command.contains("ticket")) {
            Navigator.pushNamed(context, '/viewTicket');
          } else if (command.contains("map")) {
            Navigator.pushNamed(context, '/map');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Command not recognized")),
            );
          }
        },
      );
    } else {
      _speech.stop();
      _isListening = false;
    }
  }
}
