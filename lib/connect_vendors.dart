import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name, username, avatar, phone, ratings, website, location, srt;
  String username2, phone2, ratings2, website2, location2;
  String username3, phone3, ratings3, website3, location3;

  var use = new List();
  bool isData = false;

  FetchJSON() async {
    var Response = await http.get(
      "https://gist.githubusercontent.com/thenickrj/905104869932fad8ba23986cca627aa3/raw/b0124c019e2f88ea7d9889246ab1a4667e53ef49/vendors.json",
      headers: {"Accept": "application/json"},
    );
    var kar = "Karnataka";
    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);

      username = responseJSON["Karnataka"]['Bangalore'][0]["name"];
      phone = responseJSON["Karnataka"]['Bangalore'][0]["phone"];
      ratings = responseJSON["Karnataka"]['Bangalore'][0]["ratings"];
      website = responseJSON["Karnataka"]['Bangalore'][0]["website"];
      location = responseJSON["Karnataka"]['Bangalore'][0]["location"];

      username2 = responseJSON["Karnataka"]['Bangalore'][1]["name"];
      phone2 = responseJSON["Karnataka"]['Bangalore'][1]["phone"];
      ratings2 = responseJSON["Karnataka"]['Bangalore'][1]["ratings"];
      website2 = responseJSON["Karnataka"]['Bangalore'][1]["website"];
      location2 = responseJSON["Karnataka"]['Bangalore'][1]["location"];


      username3 = responseJSON["Karnataka"]['Bangalore'][2]["name"];
      phone3 = responseJSON["Karnataka"]['Bangalore'][2]["phone"];
      ratings3 = responseJSON["Karnataka"]['Bangalore'][2]["ratings"];
      website3 = responseJSON["Karnataka"]['Bangalore'][2]["website"];
      location3 = responseJSON["Karnataka"]['Bangalore'][2]["location"];

      print(username2);
      isData = true;
      setState(() {
        print('UI Updated');
      });
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }

  @override
  void initState() {
    FetchJSON();
  }

_launchURL() async {
  var url = location;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL2() async {
  var url = location2;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL3() async {
    var url = location3;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  Widget MyUI() {
    return new Container(
      padding: new EdgeInsets.all(20.0),
      child: new ListView(
        children: <Widget>[
          new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
          new Text(
            'Name : $username',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Phone Number : $phone',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Ratings : $ratings',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Website : $website',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Location : $location',
            style: Theme.of(context).textTheme.headline6,
          ),
            RaisedButton(
              onPressed: _launchURL,
              child: Text('Show Location'),
      ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
          //2nd Vendor
          new Text(
            'Name : $username2',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Phone Number : $phone2',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Ratings : $ratings2',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Website : $website2',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Location : $location2',
            style: Theme.of(context).textTheme.headline6,
          ),
          RaisedButton(
              onPressed: _launchURL2,
              child: Text('Show Location'),
      ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
          //3rd Vendor
           new Text(
            'Name : $username3',
            style: Theme.of(context).textTheme.ccheadline6,
          ),
          new Text(
            'Phone Number : $phone3',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Ratings : $ratings3',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Website : $website3',
            style: Theme.of(context).textTheme.headline6,
          ),
          new Text(
            'Location : $location3',
            style: Theme.of(context).textTheme.headline6,
          ),
          RaisedButton(
                    onPressed: _launchURL3,

        child: Text('Show Flutter homepage'),
      ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Fetch JSON'),
        ),
        body: MyUI(),
      ),
    );
  }
}
