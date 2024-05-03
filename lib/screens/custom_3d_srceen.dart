import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:protein3d_flutter_custom3d/utilities/constants.dart';
import 'package:protein3d_flutter_custom3d/renderer/view_3d.dart';
import 'package:protein3d_flutter_custom3d/renderer/object_3d_with_lines.dart';
import 'package:protein3d_flutter_custom3d/renderer/line_start_end_points.dart';

class Custom3DScreen extends StatefulWidget {
  const Custom3DScreen({super.key});

  @override
  State<Custom3DScreen> createState() => _Custom3DScreenState();
}

class _Custom3DScreenState extends State<Custom3DScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: const Text(
          'Custom 3D (Faking 3D)',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: SizedBox.expand(
            child: View3D(
              objectWithLines: objectWithLines,
              playAnimation: true,
            ),
          ),
        ),
      ),
    );
  }
}

final objectWithLines = Object3DWithLines(
  lineStartEndPoints: [
    LineStartEndPoints(
        lineStartPoint: Vector3(-0.5, 0.5, 0.5),
        lineEndPoint: Vector3(0, 0, 0)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 0, 1),
        lineEndPoint: Vector3(-0.5, 0.5, 0.5)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 1, 1),
        lineEndPoint: Vector3(-0.5, 0.5, 0.5)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 1, 0),
        lineEndPoint: Vector3(-0.5, 0.5, 0.5)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 0, 0), lineEndPoint: Vector3(0, 0, 1)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 0, 1), lineEndPoint: Vector3(0, 1, 1)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 1, 1), lineEndPoint: Vector3(0, 1, 0)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 1, 0), lineEndPoint: Vector3(0, 0, 0)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1, 0.4, 0.4),
        lineEndPoint: Vector3(1, 0.6, 0.4)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1, 0.6, 0.4),
        lineEndPoint: Vector3(1, 0.6, 0.6)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1, 0.6, 0.6),
        lineEndPoint: Vector3(1, 0.4, 0.6)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1, 0.4, 0.6),
        lineEndPoint: Vector3(1, 0.4, 0.4)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 0, 0), lineEndPoint: Vector3(1, 0.4, 0.4)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 0, 1), lineEndPoint: Vector3(1, 0.4, 0.6)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 1, 1), lineEndPoint: Vector3(1, 0.6, 0.6)),
    LineStartEndPoints(
        lineStartPoint: Vector3(0, 1, 0), lineEndPoint: Vector3(1, 0.6, 0.4)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1, 0.6, 0.4),
        lineEndPoint: Vector3(1.1, 0.5, 0.5)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1, 0.6, 0.6),
        lineEndPoint: Vector3(1.1, 0.5, 0.5)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1, 0.4, 0.6),
        lineEndPoint: Vector3(1.1, 0.5, 0.5)),
    LineStartEndPoints(
        lineStartPoint: Vector3(1.1, 0.5, 0.5),
        lineEndPoint: Vector3(1, 0.4, 0.4)),
  ],
  maxPointSize: 2,
  maxLineThickness: 2.0,
  shrinkFactor: 100,
  yDirection: YDirection.topDown,
  animationDuration: 10,
  lineGradientStartColor: const Color(0xFF830606),
  lineGradientEndColor: const Color(0xFFFF8888),
  pointGradientStartColor: const Color(0xFF7B80F3),
  pointGradientEndColor: const Color(0xFF000068),
);
