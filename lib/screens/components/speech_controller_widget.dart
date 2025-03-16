import 'package:flutter/material.dart';

class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(this.hasSpeech, this.isListening,
      this.startListening, this.stopListening, this.cancelListening,
      {super.key});

  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;
  final void Function() stopListening;
  final void Function() cancelListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          child: const Text(
            'Start',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        TextButton(
          onPressed: isListening ? stopListening : null,
          child: Text(
            'Stop',
            style: TextStyle(
              color: isListening ? Colors.white : Colors.grey,
              fontSize: 20.0,
            ),
          ),
        ),
        TextButton(
          onPressed: isListening ? cancelListening : null,
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isListening ? Colors.white : Colors.grey,
              fontSize: 20.0,
            ),
          ),
        )
      ],
    );
  }
}
