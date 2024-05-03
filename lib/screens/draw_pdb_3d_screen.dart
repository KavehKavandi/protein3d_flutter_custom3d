import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'package:protein3d_flutter_custom3d/utilities/constants.dart';
import 'package:protein3d_flutter_custom3d/renderer/view_3d.dart';
import 'package:protein3d_flutter_custom3d/renderer/object_3d_with_lines.dart';
import 'package:protein3d_flutter_custom3d/renderer/line_start_end_points.dart';

class DrawPDB3DScreen extends StatefulWidget {
  final String pdbId;
  final int animationDuration;

  const DrawPDB3DScreen({
    super.key,
    required this.pdbId,
    this.animationDuration = 20,
  });

  @override
  State<DrawPDB3DScreen> createState() => _DrawPDB3DScreenState();
}

class _DrawPDB3DScreenState extends State<DrawPDB3DScreen> {
  late Object3DWithLines objectOfPDB;
  late List<Map<String, dynamic>> atoms = [];
  // List<List<int>> connections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndConvertPDB();
  }

  void _fetchAndConvertPDB() async {
    String pdbUrl = 'https://files.rcsb.org/download/${widget.pdbId}.pdb';
    try {
      /// fetch the PDB file from rcsb.org
      var response = await http.get(Uri.parse(pdbUrl));
      String pdbContent = response.body;
      List<String> textLines = const LineSplitter().convert(pdbContent);
      if (textLines[3].trim() == '<title>404 Not Found</title>') {
        throw Exception('PDB Not Found!');
      }

      /// Process atom coordinates and connections
      for (String textLine in textLines) {
        if (textLine.startsWith('ATOM')) {
          String atomName = textLine.substring(12, 16).trim();
          double x = double.parse(textLine.substring(30, 38).trim());
          double y = double.parse(textLine.substring(38, 46).trim());
          double z = double.parse(textLine.substring(46, 54).trim());
          atoms.add(
              {'atomName': atomName, 'x': x, 'y': y, 'z': z, 'isTER': false});
        } else if (textLine.startsWith('TER')) {
          atoms.add(
              {'atomName': '', 'x': 0.0, 'y': 0.0, 'z': 0.0, 'isTER': true});
        }
        // else if (textLine.startsWith('CONECT')) {
        //   List<int> connectedAtoms =
        //       textLine.substring(7).trim().split(' ').map(int.parse).toList();
        //   connections.add(connectedAtoms);
        // }
      }
      atoms.add({'atomName': '', 'x': 0.0, 'y': 0.0, 'z': 0.0, 'isTER': true});

      // /// Create JSON object
      // Map<String, dynamic> pdbData = {
      //   'atoms': atoms,
      //   'connections': connections,
      // };
      // String jsonContent = json.encode(pdbData);

      List<LineStartEndPoints> tempLineStartEndPoints = [];

      for (int i = 0; i < atoms.length - 1; i++) {
        double x1 = atoms[i]['x'] / 30;
        double y1 = atoms[i]['y'] / 30;
        double z1 = atoms[i]['z'] / 30;

        if (!atoms[i]['isTER']) {
          double x2 = atoms[i + 1]['x'] / 30;
          double y2 = atoms[i + 1]['y'] / 30;
          double z2 = atoms[i + 1]['z'] / 30;

          final double d = math.sqrt(
              math.pow((atoms[i + 1]['x'] - atoms[i]['x']), 2) +
                  math.pow((atoms[i + 1]['y'] - atoms[i]['y']), 2) +
                  math.pow((atoms[i + 1]['z'] - atoms[i]['z']), 2));

          if (!atoms[i + 1]['isTER'] && d < 2.0) {
            tempLineStartEndPoints.add(
              LineStartEndPoints(
                lineStartPoint: Vector3(x1, y1, z1),
                lineEndPoint: Vector3(x2, y2, z2),
              ),
            );
          } else {
            tempLineStartEndPoints.add(
              LineStartEndPoints(
                lineStartPoint: Vector3(x1, y1, z1),
                lineEndPoint: Vector3(x1, y1, z1),
              ),
            );
          }
        }
      }

      objectOfPDB = Object3DWithLines(
        lineStartEndPoints: tempLineStartEndPoints,
        maxPointSize: 3.0,
        maxLineThickness: 2.0,
        shrinkFactor: 200.0,
        yDirection: YDirection.bottomUp,
        animationDuration: widget.animationDuration,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: Text(
          'Draw PDB - ${widget.pdbId.toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: SizedBox.expand(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : View3D(
                    objectWithLines: objectOfPDB,
                    atoms: atoms,
                    playAnimation: true,
                  ),
          ),
        ),
      ),
    );
  }
}
