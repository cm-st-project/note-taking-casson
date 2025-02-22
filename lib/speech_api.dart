
import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording({

    required Function(String text) onResult,
    required ValueChanged<bool> onListening,
  }) async {

    if (_speech.isListening) {
      print('stop');
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      onError: (e) => print('Error: $e'),
    );

    print('===========${isAvailable}====================');
    if (isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    return isAvailable;
  }
}