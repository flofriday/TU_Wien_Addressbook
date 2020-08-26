import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String _imageUrl;
  final String _title;

  ImageScreen(this._imageUrl, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(_title),
      ),
      body: SafeArea(
        child: Center(
          child: Image.network(
            _imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
