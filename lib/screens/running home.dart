import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/screens/components/error_widget.dart';
import 'package:flutter_application_1/screens/components/help_widget.dart';
import 'package:flutter_application_1/screens/components/init_speach_widget.dart';
import 'package:flutter_application_1/screens/components/microphone_widget.dart';
import 'package:flutter_application_1/screens/components/recongnition_result_widget.dart';
import 'package:flutter_application_1/screens/components/session_option_widget.dart';
import 'package:flutter_application_1/screens/components/speach_status_widget.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/util/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  List<LocaleName> _localeNames = [];
  List<String> recognizedPhrases = [];
  final SpeechToText speech = SpeechToText();
  // final VolumeController volumeController = VolumeController();
  final SpeechToText _speechToText = SpeechToText();

  Future<void> initialize() async {
    // Initialize audio session

    // Initialize speech recognition
    await _speechToText.initialize();
  }

  void checkPermissionAndStartListening() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      startListening();
    } else {
      print('Permission denied');
    }
  }

  SpeechExampleConfig currentOptions = SpeechExampleConfig(
      SpeechListenOptions(
          listenMode: ListenMode.confirmation,
          onDevice: false,
          cancelOnError: false,
          partialResults: false,
          autoPunctuation: false,
          enableHapticFeedback: false),
      "",
      3,
      30,
      false,
      false);

  @override
  void initState() {
    super.initState();
    initSpeechState();
    checkPermissionAndStartListening();
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: currentOptions.debugLogging,
      );
      if (hasSpeech) {
        _localeNames = await speech.locales();
        currentOptions =
            currentOptions = currentOptions.copyWith(localeId: 'ko_KR');
      }
      initialize();
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  String _punctAggregator(List<String> phrases) {
    return phrases.join('. ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          header(),
          body(context),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    final controller = context.watch<HomeController>();
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          gradient: LinearGradient(
            colors: [controller.currentColor, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Builder(
          builder: (ctx) => SingleChildScrollView(
            child: Column(children: [
              // menuOptions(ctx),
              // SpeechControlWidget(_hasSpeech, speech.isListening,
              //     startListening, stopListening, cancelListening),

              // SpeechStatusWidget(lastStatus: lastStatus),
              // CustomErrorWidget(
              //   lastError: lastError,
              // ),
              SizedBox(height: 200),
              VoiceRecordButton(
                  level: level,
                  hasSpeech: _hasSpeech,
                  isListening: speech.isListening,
                  startListening: startListening,
                  stopListening: stopListening,
                  cancelListening: cancelListening),
              // Text(lastWords),
              RecognitionResultsWidget(
                lastWords: recognizedPhrases,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget menuOptions(BuildContext ctx) {
    return Row(
      children: [
        Expanded(child: InitSpeechWidget(_hasSpeech, initSpeechState)),
        TextButton.icon(
          // key: ,
          onPressed: () async {
            currentOptions = await showSetUp(ctx, currentOptions, _localeNames);
          },
          icon: const Icon(Icons.settings),
          label: const Text('Session Options'),
        ),
      ],
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          // padding: const EdgeInsets.all(20),
          child: Image.asset(AppImages.grandma),
        ),
        Text(
          'No more shouting!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  void startListening() async {
    initialize();
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    // Note that `listenFor` is the maximum, not the minimum, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
      onResult: resultListener,
      // listenFor: Duration(seconds: currentOptions.listenFor),
      listenFor: const Duration(minutes: 5), // Set a very long duration
      pauseFor: const Duration(seconds: 3),
      localeId: 'ko_KR',
      onSoundLevelChange: soundLevelListener,
      listenOptions: currentOptions.options,
    );
    setState(() {});
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      // lastWords += '${result.recognizedWords} - ${result.finalResult}';
      // lastWords += result.recognizedWords;
      recognizedPhrases.add(result.recognizedWords);
      // lastWords = _punctAggregator([lastWords, result.recognizedWords]);
    });
    if (result.finalResult) {
      // Restart listening if the result is final
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!speech.isListening) {
          startListening();
        }
      });
    }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // Control the sound level to ensure beeps are not audible
    if (level < 0.1) {
      setState(() {
        this.level = 0.0;
      });
    } else {
      setState(() {
        this.level = level;
      });
    }
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });

    startListening();
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = status;
    });
  }

  void _logEvent(String eventDescription) {
    if (currentOptions.logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  Future<SpeechExampleConfig> showSetUp(BuildContext context,
      SpeechExampleConfig currentOptions, List<LocaleName> localeNames) async {
    var updatedOptions = currentOptions;
    var listenController = TextEditingController()
      ..text = updatedOptions.listenFor.toString();
    var pauseController = TextEditingController()
      ..text = updatedOptions.pauseFor.toString();
    var showHelp = false;
    await showModalBottomSheet(
        elevation: 0,
        context: context,
        isScrollControlled: true,
        builder: (
          context,
        ) {
          return Material(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).copyWith().size.height * 0.75,
                minHeight: MediaQuery.of(context).copyWith().size.height * 0.5,
                maxWidth: double.infinity,
              ),
              child: StatefulBuilder(
                builder: (context, setState) => Stack(
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Session Options",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                          child: showHelp
                              ? const HelpWidget()
                              : SessionOptionsWidget(
                                  onChange: (newOptions) {
                                    setState(() {
                                      updatedOptions = newOptions;
                                    });
                                  },
                                  listenForController: listenController,
                                  pauseForController: pauseController,
                                  options: updatedOptions,
                                  localeNames: localeNames,
                                ),
                        ),
                      ),
                    ]),
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: IconButton(
                          onPressed: () => setState(
                                () => showHelp = !showHelp,
                              ),
                          icon: Icon(
                              showHelp ? Icons.settings : Icons.question_mark)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    updatedOptions = updatedOptions.copyWith(
        listenFor:
            int.tryParse(listenController.text) ?? updatedOptions.listenFor,
        pauseFor:
            int.tryParse(pauseController.text) ?? updatedOptions.pauseFor);
    return updatedOptions;
  }
}
