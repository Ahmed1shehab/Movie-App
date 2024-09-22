
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView'),
        backgroundColor: Colors.black,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url), // Use WebUri instead of Uri
        ),
      ),
    );
  }
}
