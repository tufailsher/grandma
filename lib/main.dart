import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:flutter_application_1/screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeController>(
              create: (_) => HomeController()),
        ],
        child: const GrandMa(),
      ),
    );

class GrandMa extends StatelessWidget {
  const GrandMa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.yellow,
      ),
      home: IntroScreen(),
      // home: ContinuousSpeechRecognition(),
    );
  }
}

class SpeechExampleConfig {
  final SpeechListenOptions options;
  final String localeId;
  final bool logEvents;
  final bool debugLogging;
  final int pauseFor;
  final int listenFor;

  SpeechExampleConfig(this.options, this.localeId, this.pauseFor,
      this.listenFor, this.logEvents, this.debugLogging);

  SpeechExampleConfig copyWith(
      {SpeechListenOptions? options,
      String? localeId,
      bool? logEvents,
      int? pauseFor,
      int? listenFor,
      bool? debugLogging}) {
    return SpeechExampleConfig(
        options ?? this.options,
        localeId ?? this.localeId,
        pauseFor ?? this.pauseFor,
        listenFor ?? this.listenFor,
        logEvents ?? this.logEvents,
        debugLogging ?? this.debugLogging);
  }
}

/// Show the setup dialog to allow the user to change the
/// configuration of the speech recognition session.
