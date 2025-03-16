// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/controllers/home_controller.dart';
// import 'package:provider/provider.dart';

// class TextControlWidget extends StatefulWidget {
//   final ValueChanged<double> onFontSizeChanged;
//   final ValueChanged<Color> onColorChanged;

//   const TextControlWidget({
//     super.key,
//     required this.onFontSizeChanged,
//     required this.onColorChanged,
//   });

//   @override
//   State<TextControlWidget> createState() => _TextControlWidgetState();
// }

// class _TextControlWidgetState extends State<TextControlWidget> {
//   double _currentFontSize = 24.0;
//   Color _currentColor = Colors.white;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: const Text(
//             'Font Size',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20.0,
//             ),
//           ),
//         ),
//         Slider(
//           value: _currentFontSize,
//           min: 10.0,
//           max: 50.0,
//           divisions: 40,
//           label: _currentFontSize.round().toString(),
//           onChanged: (double value) {
//             setState(() {
//               _currentFontSize = value;
//             });
//             widget.onFontSizeChanged(value);
//           },
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildColorOption(Colors.white, context),
//             _buildColorOption(Colors.red, context),
//             _buildColorOption(Colors.green, context),
//             _buildColorOption(Colors.blue, context),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildColorOption(Color color, BuildContext context) {
//     final controller = context.watch<HomeController>();
//     return GestureDetector(
//       onTap: () {
//         controller.updateColor(color);
//         setState(() {});
//       },
//       // onTap: () {
//       //   setState(() {
//       //     _currentColor = color;
//       //   });
//       //   widget.onColorChanged(color);
//       // },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: controller.currentColor == color
//                 ? Colors.black
//                 : Colors.transparent,
//             width: 2.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
