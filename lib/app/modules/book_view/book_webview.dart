import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookDetailWebView extends StatefulWidget {
  final String bookId;

  BookDetailWebView({required this.bookId});

  @override
  _BookDetailWebViewState createState() => _BookDetailWebViewState();
}

class _BookDetailWebViewState extends State<BookDetailWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.google.co.id/books/edition/_/${widget.bookId}')); // Load URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eBook Preview", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF181919),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
