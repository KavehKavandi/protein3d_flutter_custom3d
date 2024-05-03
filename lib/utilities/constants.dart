import 'package:flutter/material.dart';

enum YDirection { topDown, bottomUp }

const double kGradientInitValue = 9999999999.0;

const kTextFieldDecoration = InputDecoration(
  counterText: '',
  labelText: 'Label Text',
  labelStyle: TextStyle(
    fontSize: 12.0,
    color: Colors.grey,
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      width: 1.0,
    ),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      width: 2.0,
    ),
  ),
);

class ColorUtils {
  static Color getColorForAtomName(String atomName) {
    Map<String, Color> atomColors = {
      'H': Colors.white,
      'H_2': Colors.white,
      'O': const Color(0xFF450000),
      'O_2': const Color(0xFFFD1A1A),
      'N': const Color(0xFF000068),
      'N_2': const Color(0xFF1212FA),
      'C': Colors.cyan[900]!,
      'C_2': Colors.cyan[100]!,
      'S': Colors.yellow[900]!,
      'S_2': Colors.yellow[100]!,
      'P': const Color(0xFF808033),
      'P_2': const Color(0xFF808033),
      'Z': const Color(0xFF999999),
      'Z_2': const Color(0xFF999999),
      'LP': Colors.green[900]!,
      'LP_2': Colors.green[100]!,
      'LPA': Colors.green[900]!,
      'LPA_2': Colors.green[100]!,
      'LPB': Colors.green[900]!,
      'LPB_2': Colors.green[100]!,
      'DRUD': Colors.pink[900]!,
      'DRUD_2': Colors.pink[100]!,
      'CD1': const Color(0xFF656500),
      'CD1_2': const Color(0xFFFDFD30),

      // Add more atom names and their corresponding colors as needed
    };

    Color defaultColor = Colors.grey; // Default color if atomName is not found

    return atomColors[atomName] ?? defaultColor;
  }
}
