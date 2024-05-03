import 'package:flutter/material.dart' show Color;

import 'package:protein3d_flutter_custom3d/utilities/constants.dart';
import 'package:protein3d_flutter_custom3d/renderer/line_start_end_points.dart';

class Object3DWithLines {
  final List<LineStartEndPoints> lineStartEndPoints;
  final double maxPointSize;
  final double maxLineThickness;
  final double shrinkFactor;
  final Color pointGradientStartColor;
  final Color pointGradientEndColor;
  final Color lineGradientStartColor;
  final Color lineGradientEndColor;
  final YDirection yDirection;
  final int animationDuration;

  Object3DWithLines({
    required this.lineStartEndPoints,
    this.maxPointSize = 2.0,
    this.maxLineThickness = 2.0,
    this.shrinkFactor = 100,
    this.pointGradientStartColor = const Color(0xFF6CE5E5),
    this.pointGradientEndColor = const Color(0xFF133838),
    this.lineGradientStartColor = const Color(0xFF133838),
    this.lineGradientEndColor = const Color(0xFF6CE5E5),
    this.yDirection = YDirection.topDown,
    this.animationDuration = 10,
  });
}
