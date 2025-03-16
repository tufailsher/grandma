import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

class VoiceRecordButton extends StatefulWidget {
  final double level; // Sound level from 0.0 to 1.0
  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;
  final void Function()? stopListening;
  final void Function() cancelListening;

  const VoiceRecordButton({
    super.key,
    required this.level,
    required this.hasSpeech,
    required this.isListening,
    required this.startListening,
    this.stopListening,
    required this.cancelListening,
  });

  @override
  _VoiceRecordButtonState createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton> {
  bool _showMicIcon = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        _showMicIcon = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // padding: EdgeInsets.all(20),
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            // gradient: RadialGradient(
            //   colors: [
            //     AppColors.primary.withAlpha(100),
            //     AppColors.secondary.withAlpha(100),
            //   ],
            //   stops: const [0.4, 1.0],
            // ),
            ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer circles - size and opacity based on sound level
            _buildLevelCircle(240, 1, widget.level * 0.2),
            _buildLevelCircle(200, 1, widget.level * 0.3),

            // Inner button

            Container(
              // padding: EdgeInsets.all(20),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(100),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(100),
                    blurRadius: 10,
                    spreadRadius:
                        widget.level * 5, // Spread radius based on level
                  ),
                ],
              ),
              child: _showMicIcon
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 60,
                        ),
                        onPressed: () {
                          print('===');
                          if (!widget.hasSpeech || widget.isListening) {
                            widget.stopListening!();
                          } else {
                            widget.startListening();
                          }
                          // Add recording logic here
                        },
                      ),
                    )
                  : IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      print('===');
                      if (!widget.hasSpeech || widget.isListening) {
                        widget.stopListening!();
                      } else {
                        widget.startListening();
                      }
                      // Add recording logic here
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCircle(double size, double width, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(opacity.clamp(0.0, 1.0)),
          width: width,
        ),
      ),
    );
  }
}
