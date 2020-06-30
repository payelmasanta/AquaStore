import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(fontFamily: 'Open Sans'),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text("Hey there.."),
            ],
          ),
        ),
      ),
    );
  }
}
