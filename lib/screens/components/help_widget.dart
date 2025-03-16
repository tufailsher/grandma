import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'The plugin provides a number of options that can be set to control '
            'the behavior of the speech recognition. The option names shown '
            'correspond to the names of the fields in the SpeechListenOptions, '
            'or parameters of the listen or initialize methods. '),
        Text(''),
        Text('localeId:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('The language to use for speech recognition. This is '
            'based on the languages installed on the device. '),
        Text(''),
        Text('pauseFor:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('The number of seconds to pause after the last speech is '
            'detected before stopping the recognition. Note that this is '
            'ignored on Android devices which impose their own quite short '
            'pause duration. '),
        Text(''),
        Text('listenFor:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('The maximum number of seconds to listen for speech '
            'before stopping the recognition. Note that the actual time '
            'may be less if the device imposes a shorter maximum duration. '),
        Text(''),
        Text('partialResults:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('When true the plugin will return results as they are recognized. '
            'When false the plugin will only return the final result. Note '
            'that recognizers will change the recognized result as more '
            'speech is received. This means that the final result may be '
            'different from the last partial result. '),
        Text(''),
        Text('onDevice:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('When true all recognition will be done on device. '
            'Recognition will fail if the device does not support on device '
            'recognition for the selected language. '),
        Text(''),
        Text('cancelOnError:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('When true the plugin will automatically cancel recognition  '
            'when an error occurs. If false it will attempt to continue '
            'recognition until the stop or cancel method is called. '),
        Text(''),
        Text('debugLogging:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('When true the device specific implementation will log '
            'more detailed information during initialization and recognition. '),
        Text(''),
        Text('autoPunctuation:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('When true the plugin will attempt to add punctuation to the '
            'recognized text on supported devices. '),
        Text(''),
        Text('enableHapticFeedback:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('When true the plugin will provide haptic feedback during '
            'recognition. Some platforms disable haptics during recognition '
            'to improve accuracy. This option allows the user to override '
            'that behavior. '),
        Text(''),
        Text('logEvents:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Logs example app events to the console. '
            'This is not a plugin feature, purely a part of the example app. '),
      ],
    );
  }
}
