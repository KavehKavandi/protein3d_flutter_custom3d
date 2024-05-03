import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart';

import 'package:protein3d_flutter_custom3d/utilities/constants.dart';

List<Vector3> project(Vector3 lineStartPoint, Vector3 lineEndPoint,
    double rotation, double aspectRatio, YDirection yDirection) {
  final viewMatrix = makeViewMatrix(
    Vector3(
          0.25,
          math.cos(rotation),
          math.sin(rotation),
        ) *
        2,
    Vector3.all(0.5),
    Vector3(1, 0, 0),
  );

  const near = 1.0;
  const fov = 60.0;
  const zoom = 1;
  final double top = near * math.tan(radians(fov) / 2.0) / zoom;
  final double bottom = -top;
  final double right = top * aspectRatio;
  final double left = -right;
  const double far = 1000.0;

  final projectionMatrix = makeFrustumMatrix(
    left,
    right,
    bottom,
    top,
    near,
    far,
  );

  final transformationMatrix = projectionMatrix * viewMatrix;

  final projectiveCoords1 =
      Vector4(lineStartPoint.x, lineStartPoint.y, lineStartPoint.z, 1.0);
  projectiveCoords1.applyMatrix4(transformationMatrix);

  final projectiveCoords2 =
      Vector4(lineEndPoint.x, lineEndPoint.y, lineEndPoint.z, 1.0);
  projectiveCoords2.applyMatrix4(transformationMatrix);

  var x1 = projectiveCoords1.x / projectiveCoords1.w;
  var y1 = projectiveCoords1.y / projectiveCoords1.w;
  var z1 = projectiveCoords1.z / projectiveCoords1.w;

  var x2 = projectiveCoords2.x / projectiveCoords2.w;
  var y2 = projectiveCoords2.y / projectiveCoords2.w;
  var z2 = projectiveCoords2.z / projectiveCoords2.w;

  if (yDirection == YDirection.bottomUp) {
    y1 = -y1;
    y2 = -y2;
  }
  return [Vector3(x1, y1, z1), Vector3(x2, y2, z2)];
}
