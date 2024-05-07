import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInputFormatter, FilteringTextInputFormatter;

import 'package:protein3d_flutter_custom3d/utilities/constants.dart';
import 'package:protein3d_flutter_custom3d/screens/view_3d_screen.dart';
import 'package:protein3d_flutter_custom3d/screens/web_view_molstar_screen.dart';
import 'package:protein3d_flutter_custom3d/screens/custom_3d_srceen.dart';
import 'package:protein3d_flutter_custom3d/screens/draw_pdb_3d_screen.dart';

String _pdbId = '';
int _animationDuration = 20;

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: const Text('3D Model Viewer - GLB'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const View3DScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Mol* Viewer - WebView'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewMolstarScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Custom 3D (Faking 3D)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Custom3DScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'PDB ID (Protein Data Bank Identifier)',
                  ),
                  onChanged: (value) {
                    _pdbId = value;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 3,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  cursorErrorColor: Colors.red,
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Animation speed (smaller number is faster)',
                  ),
                  onChanged: (value) {
                    _animationDuration = int.parse(value);
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Drawing PDB - Custom 3D'),
                onPressed: () {
                  if (_pdbId != '' && _pdbId.length == 4) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrawPDB3DScreen(
                          pdbId: _pdbId,
                          animationDuration: _animationDuration,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Error: PDB ID is not specified or is less than 4 characters long!'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
