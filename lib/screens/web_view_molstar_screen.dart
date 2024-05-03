import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:protein3d_flutter_custom3d/components/web_view_stack.dart';
import 'package:protein3d_flutter_custom3d/components/navigation_controls.dart';

class WebViewMolstarScreen extends StatefulWidget {
  const WebViewMolstarScreen({super.key});

  @override
  State<WebViewMolstarScreen> createState() => _WebViewMolstarScreenState();
}

class _WebViewMolstarScreenState extends State<WebViewMolstarScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
            'https://molstar.org/viewer/?mvs-url=https%3A%2F%2Fmolstar.org%2Fmol-view-spec%2Fexamples%2Fbasic%2Fstate.mvsj&mvs-format=mvsj&hide-controls=1'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: const Text(
          'Mol* - WebView',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: WebViewStack(controller: controller),
    );
  }
}
