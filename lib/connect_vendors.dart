import 'package:flutter/material.dart';
import './Calculation.dart';

class ConnectVendors extends StatelessWidget {
  String v = CalculationsState().placeName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10),
                    //padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                    child: Text(
                      'Connect with vendors',
                      style: TextStyle(fontFamily: 'Open Sans', fontSize: 23),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  //margin: EdgeInsets.only(left: 25, right: 0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: Text(v),
      ),
    );
  }
}
