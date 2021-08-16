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
        foregroundColor: Colors.black,
        backgroundColor: Color.fromARGB(0xAA, 0x00, 0x00, 0x00),
        elevation: 0,
        title: Text(
          _title,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        clipBehavior: Clip.none,
        child: SafeArea(
          child: Center(
            child: Hero(
              tag: 'personimage',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  _imageUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
