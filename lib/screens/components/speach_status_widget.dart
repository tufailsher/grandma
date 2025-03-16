import 'package:flutter/material.dart';

/// Display the current status of the listener
class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({
    super.key,
    required this.lastStatus,
  });

  final String lastStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Status',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: SelectableText(
            lastStatus,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
