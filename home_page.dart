import 'package:flutter/material.dart';
import './main_drawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RWH Assistant',
          style: TextStyle(fontFamily: 'Open Sans'),
        ),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Calculate Rain',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color),
              RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Start Building',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color),
              RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Connect',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color)
            ],
          ),
        ),
      ),
    );
  }
}
