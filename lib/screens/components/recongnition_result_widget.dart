import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_application_1/screens/components/text_control_widget.dart';

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatefulWidget {
  final List<String> lastWords;
  const RecognitionResultsWidget({
    super.key,
    required this.lastWords,
  });

  @override
  State<RecognitionResultsWidget> createState() =>
      _RecognitionResultsWidgetState();
}

class _RecognitionResultsWidgetState extends State<RecognitionResultsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              constraints: const BoxConstraints(
                minHeight: 200,
              ),
              // color: Theme.of(context).secondaryHeaderColor,
              child: Center(
                child: Text(
                  widget.lastWords.join('. ').replaceAll('.', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.watch<HomeController>().currentFontSize,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10.0),
        //         ),
        //         backgroundColor: Colors.white,
        //         // side: BorderSide(),
        //         minimumSize: const Size(200, 50),
        //       ),
        //       onPressed: () => _showTextControlModal(context),
        //       child: const Text(
        //         'Font size & Background',
        //         style: TextStyle(
        //           color: AppColors.primary,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class TextControlWidget extends StatefulWidget {
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<Color> onColorChanged;

  const TextControlWidget({
    super.key,
    required this.onFontSizeChanged,
    required this.onColorChanged,
  });

  @override
  State<TextControlWidget> createState() => _TextControlWidgetState();
}

class _TextControlWidgetState extends State<TextControlWidget> {
  double _currentFontSize = 24.0;
  Color _currentColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Font Size',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
        Slider(
          value: _currentFontSize,
          min: 10.0,
          max: 50.0,
          divisions: 40,
          label: _currentFontSize.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentFontSize = value;
            });
            context.read<HomeController>().updateFontSize(value);
            widget.onFontSizeChanged(value);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColorOption(Colors.white, context),
            _buildColorOption(Colors.red, context),
            _buildColorOption(Colors.green, context),
            _buildColorOption(Colors.blue, context),
          ],
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color, BuildContext context) {
    final controller = context.watch<HomeController>();
    return GestureDetector(
      onTap: () {
        controller.updateColor(color);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: controller.currentColor == color
                ? Colors.black
                : Colors.transparent,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
