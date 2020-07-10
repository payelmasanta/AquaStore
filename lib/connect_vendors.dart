import 'package:flutter/material.dart';

class ConnectVendors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                child: Text(
                  'Connect with vendors',
                  style: TextStyle(fontFamily: 'Open Sans', fontSize: 23),
                )),
            Container(
              margin: EdgeInsets.only(left: 25, right: 0),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
