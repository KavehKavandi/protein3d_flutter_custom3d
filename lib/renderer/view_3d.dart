import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:protein3d_flutter_custom3d/utilities/constants.dart';
import 'package:protein3d_flutter_custom3d/renderer/object_3d_with_lines.dart';
import 'package:protein3d_flutter_custom3d/renderer/line_start_end_points.dart';
import 'package:protein3d_flutter_custom3d/renderer/thing_to_be_drawn.dart';
import 'package:protein3d_flutter_custom3d/renderer/project.dart';

class View3D extends StatefulWidget {
  final Object3DWithLines objectWithLines;
  final List<Map<String, dynamic>>? atoms;
  final bool playAnimation;

  const View3D({
    required this.objectWithLines,
    this.atoms,
    required this.playAnimation,
    super.key,
  });

  @override
  State<View3D> createState() => View3DState();
}

class View3DState extends State<View3D> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.objectWithLines.animationDuration),
    );
    if (widget.playAnimation) {
      _controller.repeat();
    }
  }

  void _stopStartAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _stopStartAnimation,
      child: CustomPaint(
        painter: _View3DPainter(
          objectWithLines: widget.objectWithLines,
          animation: _controller,
          atoms: widget.atoms,
        ),
      ),
    );
  }
}

class _View3DPainter extends CustomPainter {
  final Object3DWithLines objectWithLines;
  final Animation<double> animation;
  final List<Map<String, dynamic>>? atoms;

  _View3DPainter({
    required this.objectWithLines,
    required this.animation,
    this.atoms,
  }) : super(repaint: animation);

  final _paint = Paint();

  final double corner = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    var aspectRatio = size.width / size.height;

    double strokeWidth = objectWithLines.maxLineThickness;
    double gradientXs = kGradientInitValue;
    double gradientYs = kGradientInitValue;
    double gradientXe = -kGradientInitValue;
    double gradientYe = -kGradientInitValue;

    List<ThingToBeDrawn> thingsToBeDrawn = [];

    for (final (i, line) in objectWithLines.lineStartEndPoints.indexed) {
      final pointSize = objectWithLines.maxPointSize;

      final shrinkFactor = objectWithLines.shrinkFactor;

      var screenPoints = project(
        line.lineStartPoint,
        line.lineEndPoint,
        animation.value * math.pi * 2,
        aspectRatio,
        objectWithLines.yDirection,
      );

      var x1 = (1.0 + screenPoints[0].x) * size.width / 2;
      var y1 = (1.0 - screenPoints[0].y) * size.height / 2;
      var z1 = (1.0 - screenPoints[0].z) * size.height / 2;

      var x2 = (1.0 + screenPoints[1].x) * size.width / 2;
      var y2 = (1.0 - screenPoints[1].y) * size.height / 2;
      var z2 = (1.0 - screenPoints[1].z) * size.height / 2;

      gradientXe = x1 > gradientXe ? gradientXe = x1 : gradientXe;
      gradientXe = x2 > gradientXe ? gradientXe = x2 : gradientXe;
      gradientXs = x1 < gradientXs ? gradientXs = x1 : gradientXs;
      gradientXs = x2 < gradientXs ? gradientXs = x2 : gradientXs;

      gradientYe = y1 > gradientYe ? gradientYe = y1 : gradientYe;
      gradientYe = y2 > gradientYe ? gradientYe = y2 : gradientYe;
      gradientYs = y1 < gradientYs ? gradientYs = y1 : gradientYs;
      gradientYs = y2 < gradientYs ? gradientYs = y2 : gradientYs;

      if (line.hasPoints) {
        thingsToBeDrawn.add(
          ThingToBeDrawn(
            isLine: false,
            xStart: x1,
            yStart: y1,
            zStart: z1,
            startPointSize: (z1 * pointSize) / shrinkFactor,
            gradientStartColor: (atoms != null &&
                    ColorUtils.getColorForAtomName(atoms![i]['atomName']) !=
                        Colors.grey)
                ? ColorUtils.getColorForAtomName(atoms![i]['atomName'] + '_2')
                : objectWithLines.pointGradientStartColor,
            gradientEndColor: (atoms != null &&
                    ColorUtils.getColorForAtomName(atoms![i]['atomName']) !=
                        Colors.grey)
                ? ColorUtils.getColorForAtomName(atoms![i]['atomName'])
                : objectWithLines.pointGradientEndColor,
          ),
        );
      }

      thingsToBeDrawn.add(
        ThingToBeDrawn(
          isLine: true,
          xStart: x1,
          yStart: y1,
          zStart: z1,
          xEnd: x2,
          yEnd: y2,
          zEnd: z2,
          startPointSize: ((z1 * pointSize) / shrinkFactor) - 0.5,
          endPointSize: ((z2 * pointSize) / shrinkFactor) - 0.5,
          gradientStartColor: objectWithLines.lineGradientStartColor,
          gradientEndColor: objectWithLines.lineGradientEndColor,
          lineThickness: ((z1 * strokeWidth) / shrinkFactor) / 2,
        ),
      );
    }

    thingsToBeDrawn.sort((a, b) => a.zStart.compareTo(b.zStart));

    for (final thingToBeDrawn in thingsToBeDrawn) {
      if (thingToBeDrawn.isLine) {
        _paint.shader = ui.Gradient.linear(
          Offset(gradientXs, gradientYe),
          Offset(gradientXe + 50, gradientYs - 300),
          [
            thingToBeDrawn.gradientStartColor,
            thingToBeDrawn.gradientEndColor,
          ],
        );

        LineStartEndPoints? newLine = ThingToBeDrawn.calculatedLine(
          LineStartEndPoints(
            lineStartPoint:
                Vector3(thingToBeDrawn.xStart, thingToBeDrawn.yStart, 0),
            lineEndPoint:
                Vector3(thingToBeDrawn.xEnd!, thingToBeDrawn.yEnd!, 0),
          ),
          thingToBeDrawn.startPointSize,
          thingToBeDrawn.endPointSize!,
        );

        if (newLine != null) {
          _paint.strokeWidth = thingToBeDrawn.lineThickness!;

          canvas.drawLine(
            Offset(
              newLine.lineStartPoint.x,
              newLine.lineStartPoint.y,
            ),
            Offset(
              newLine.lineEndPoint.x,
              newLine.lineEndPoint.y,
            ),
            _paint,
          );
        }
      } else {
        _paint.shader = ui.Gradient.radial(
          Offset(
            thingToBeDrawn.xStart + thingToBeDrawn.startPointSize,
            thingToBeDrawn.yStart - thingToBeDrawn.startPointSize,
          ),
          thingToBeDrawn.startPointSize * 2,
          [
            thingToBeDrawn.gradientStartColor,
            thingToBeDrawn.gradientEndColor,
          ],
        );

        canvas.drawCircle(
          Offset(thingToBeDrawn.xStart, thingToBeDrawn.yStart),
          thingToBeDrawn.startPointSize,
          _paint,
        );
      }
      _paint.shader = null;
      _paint.strokeWidth = strokeWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
