import 'package:vector_math/vector_math_64.dart';

class LineStartEndPoints {
  final Vector3 lineStartPoint;
  final Vector3 lineEndPoint;
  final bool hasPoints;

  LineStartEndPoints({
    required this.lineStartPoint,
    required this.lineEndPoint,
    this.hasPoints = true,
  });
}
