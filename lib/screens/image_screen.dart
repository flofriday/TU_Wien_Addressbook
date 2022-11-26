import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageScreen extends StatelessWidget {
  final String _imageUrl;
  final String _title;

  ImageScreen(this._imageUrl, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        title: Text(
          _title,
        ),

        // FIXME: this shouldn't be necessary but I couldn't get the color
        // to work any other way.
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
