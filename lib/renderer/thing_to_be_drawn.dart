import 'dart:math' as math;
import 'package:flutter/material.dart' show Color;

import 'package:protein3d_flutter_custom3d/renderer/line_start_end_points.dart';

class ThingToBeDrawn {
  final bool isLine;
  final double xStart;
  final double yStart;
  final double zStart;
  final double? xEnd;
  final double? yEnd;
  final double? zEnd;
  final double startPointSize;
  final double? endPointSize;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double? lineThickness;

  ThingToBeDrawn({
    this.isLine = false,
    required this.xStart,
    required this.yStart,
    required this.zStart,
    this.xEnd,
    this.yEnd,
    this.zEnd,
    required this.startPointSize,
    this.endPointSize,
    required this.gradientStartColor,
    required this.gradientEndColor,
    this.lineThickness,
  });

  static LineStartEndPoints? calculatedLine(
      LineStartEndPoints line, double r1, double r2) {
    LineStartEndPoints newLine = line;

    final double x1 = line.lineStartPoint.x;
    final double y1 = line.lineStartPoint.y;
    final double x2 = line.lineEndPoint.x;
    final double y2 = line.lineEndPoint.y;

    if (x1 == x2 || x1.toStringAsFixed(5) == x2.toStringAsFixed(5)) {
      return null;
    }
    if (y1 == y2 || y1.toStringAsFixed(5) == y2.toStringAsFixed(5)) {
      return null;
    }

    final double centersDistance =
        math.sqrt(math.pow((x2 - x1), 2) + math.pow((y2 - y1), 2));
    if (centersDistance < r1 + r2) {
      return null;
    }

    final double m = (y2 - y1) / (x2 - x1);

    final theta = math.atan(m);

    final double x3a = x1 + (r1 * math.cos(theta));
    final double y3a = y1 + (r1 * math.sin(theta));
    final double x3b = x1 - (r1 * math.cos(theta));
    final double y3b = y1 - (r1 * math.sin(theta));

    final double x4a = x2 + (r2 * math.cos(theta));
    final double y4a = y2 + (r2 * math.sin(theta));
    final double x4b = x2 - (r2 * math.cos(theta));
    final double y4b = y2 - (r2 * math.sin(theta));

    final List<double> d = [];
    d.add(math.sqrt(math.pow((x3a - x4a), 2) + math.pow((y3a - y4a), 2)));
    d.add(math.sqrt(math.pow((x3a - x4b), 2) + math.pow((y3a - y4b), 2)));
    d.add(math.sqrt(math.pow((x3b - x4a), 2) + math.pow((y3b - y4a), 2)));
    d.add(math.sqrt(math.pow((x3b - x4b), 2) + math.pow((y3b - y4b), 2)));

    final double minD = d.reduce(math.min);

    if (minD == d[0]) {
      newLine.lineStartPoint.x = x3a;
      newLine.lineStartPoint.y = y3a;
      newLine.lineEndPoint.x = x4a;
      newLine.lineEndPoint.y = y4a;
    } else if (minD == d[1]) {
      newLine.lineStartPoint.x = x3a;
      newLine.lineStartPoint.y = y3a;
      newLine.lineEndPoint.x = x4b;
      newLine.lineEndPoint.y = y4b;
    } else if (minD == d[2]) {
      newLine.lineStartPoint.x = x3b;
      newLine.lineStartPoint.y = y3b;
      newLine.lineEndPoint.x = x4a;
      newLine.lineEndPoint.y = y4a;
    } else if (minD == d[3]) {
      newLine.lineStartPoint.x = x3b;
      newLine.lineStartPoint.y = y3b;
      newLine.lineEndPoint.x = x4b;
      newLine.lineEndPoint.y = y4b;
    }

    return newLine;
  }
}
