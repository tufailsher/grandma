import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class ContinuousSpeechRecognition extends StatefulWidget {
  const ContinuousSpeechRecognition({super.key});

  @override
  State<ContinuousSpeechRecognition> createState() => _ContinuousSpeechRecognitionState();
}

class _ContinuousSpeechRecognitionState extends State<ContinuousSpeechRecognition> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _recognizedText = '';
  String _currentListeningStatus = 'Not listening';
  List<String> _recognitionHistory = [];
  Timer? _restartTimer;
  
  @override
  void initState() {
    super.initState();
    _initSpeech();
  }
  
  @override
  void dispose() {
    _restartTimer?.cancel();
    super.dispose();
  }

  /// Initialize speech recognition
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: _onSpeechStatus,
      onError: (error) => _handleError(error),
    );
    
    if (_speechEnabled) {
      // Start listening immediately after initialization
      _startListening();
    } else {
      setState(() {
        _currentListeningStatus = 'Speech recognition not available';
      });
    }
  }

  /// Start continuous listening
  void _startListening() async {
    if (!_speechEnabled) {
      await _initSpeech();
      return;
    }
    
    setState(() {
      _currentListeningStatus = 'Listening...';
    });
    
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: 'ko_KR', // Korean language
      listenMode: ListenMode.dictation, // Use dictation mode for continuous listening
      partialResults: true, // Get results as they come
      listenFor: const Duration(hours: 1), // Set a very long duration
      pauseFor: const Duration(seconds: 3), // Short pause to restart listening
    );
    
    // Set up a timer to restart listening if it stops
    _setupRestartTimer();
  }
  
  void _setupRestartTimer() {
    _restartTimer?.cancel();
    _restartTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_speechToText.isListening) {
        debugPrint('Restarting speech recognition...');
        _startListening();
      }
    });
  }
  
  void _onSpeechStatus(String status) {
    debugPrint('Speech status: $status');
    setState(() {
      _currentListeningStatus = status;
    });
    
    // Restart listening if stopped
    if (status == 'done' || status == 'notListening') {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_speechToText.isListening) {
          _startListening();
        }
      });
    }
  }
  
  void _handleError(dynamic error) {
    debugPrint('Speech error: $error');
    // Attempt to restart on error
    if (!_speechToText.isListening) {
      Future.delayed(const Duration(seconds: 1), () {
        _startListening();
      });
    }
  }

  /// This is called when speech recognition returns a result
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _recognizedText = result.recognizedWords;
      
      // If the result is final, add it to history
      if (result.finalResult && _recognizedText.isNotEmpty) {
        _recognitionHistory.add(_recognizedText);
        // Keep only the last 10 entries for performance
        if (_recognitionHistory.length > 10) {
          _recognitionHistory.removeAt(0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Korean Speech Recognition'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Status indicator
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: _speechToText.isListening ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _currentListeningStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _speechToText.isListening ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
            ),
            
            // Current recognition text
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _recognizedText.isEmpty ? '말하세요...' : _recognizedText,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _recognizedText.isEmpty ? Colors.grey : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Recognition history title
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                '인식 기록',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // History list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _recognitionHistory.length,
                itemBuilder: (context, index) {
                  // Reverse the index to show newest items at the top
                  final reversedIndex = _recognitionHistory.length - 1 - index;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(_recognitionHistory[reversedIndex]),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('${reversedIndex + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _speechToText.stop : _startListening,
        tooltip: _speechToText.isListening ? 'Stop listening' : 'Start listening',
        child: Icon(_speechToText.isListening ? Icons.mic : Icons.mic_off),
      ),
    );
  }
}