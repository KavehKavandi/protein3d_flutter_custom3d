import 'package:flutter/material.dart';

import 'package:model_viewer_plus/model_viewer_plus.dart';

class View3DScreen extends StatelessWidget {
  const View3DScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: const Text(
          '3D Model Viewer - GLB',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const ModelViewer(
        backgroundColor: Colors.black,
        src: 'assets/8J32.glb',
        alt: '3D model of 8J32',
        ar: true,
        autoRotate: true,
        disableZoom: false,
      ),
    );
  }
}
