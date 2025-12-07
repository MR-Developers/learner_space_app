import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;
  final String? title;
  const PdfViewerPage({Key? key, required this.url, this.title})
    : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PdfControllerPinch? _pdfController;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final resp = await http.get(Uri.parse(widget.url));
      if (resp.statusCode != 200)
        throw Exception('Failed to download PDF (${resp.statusCode})');

      final bytes = resp.bodyBytes;
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(bytes),
      );

      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'PDF Viewer'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Failed to load PDF: $_error'))
          : PdfViewPinch(controller: _pdfController!),
    );
  }
}
