import 'package:flutter/material.dart';
import './Calculation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
class ConnectVendors extends StatefulWidget {
  @override
  ConnectVendorsState createState() => ConnectVendorsState();
  }

  class ConnectVendorsState extends State<ConnectVendors> {
    var calculation = new CalculationsState();
    String locationMessage1 = "";
    String place = '';

    @override
    Future getCurrentLocation() async {
        bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
      if (isLocationEnabled) {
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        debugPrint('location: ${position.latitude}');
        final coordinates =
        new Coordinates(position.latitude, position.longitude);
        var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        print("${first.featureName} : ${first.addressLine}");
        setState(() {
          locationMessage1 = "${position.latitude}, ${position.longitude}";
          place = " ${first.subAdminArea}";
          print(place);
        });
        return place;
      } else {
        showDialog(
            context: context, builder: (BuildContext context) => errorDialog);
        AppSettings.openLocationSettings();
      }
    }
      Dialog errorDialog = Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          height: 200.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(""),
              Text(""),
              Container(
                padding: EdgeInsets.only(left: 20, right: 15),
                child: Text(
                  'To continue, turn on device location.',
                  style: TextStyle(fontSize: 22, color: Colors.grey),
                ),
              ),
              Text(""),
              Container(
                  padding: EdgeInsets.only(left: 40, top: 40),
                  margin: EdgeInsets.only(bottom: 10, right: 1),
                  child: FlatButton(
                    onPressed: () {
                      AppSettings.openLocationSettings();
                    },
                    child: Text(
                      'Go to Location settings >>',
                      style: TextStyle(color: Colors.blue, fontSize: 17.0),
                    ),
                  )),
            ],
          ),
        ),
      );

      String place1 = '';
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
        //var kar = "Mysuru";
        if (Response.statusCode == 200) {
          String responseBody = Response.body;
          var responseJSON = json.decode(responseBody);
          place1 = place;
          print('\"$place1\"');
          username = responseJSON["Karnataka"]['Bangalore'][0]["name"];
          phone = responseJSON["Karnataka"]['Bangalore'][0]["phone"];
          ratings = responseJSON["Karnataka"]['Bangalore'][0]["ratings"];
          website = responseJSON["Karnataka"]['Bangalore'][0]["website"];
          location = responseJSON["Karnataka"]['Bangalore'][0]["location"];


          username2 = responseJSON["$place"][1]["name"];
          phone2 = responseJSON["$place"][1]["phone"];
          ratings2 = responseJSON["$place"][1]["ratings"];
          website2 = responseJSON["$place"][1]["website"];
          location2 = responseJSON["$place"][1]["location"];

          username3 = responseJSON["$place"][2]["name"];
          phone3 = responseJSON["$place"][2]["phone"];
          ratings3 = responseJSON["$place"][2]["ratings"];
          website3 = responseJSON["$place"][2]["website"];
          location3 = responseJSON["$place"][2]["location"];


          print(username);
          print(phone);
          print(ratings);
          print(website);
          print(location);
          isData = true;
          setState(() {
            print('UI Updated');
          });
        } else {
          print(
              'Something went wrong. \nResponse Code : ${Response.statusCode}');
        }
      }
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

//  Widget MyUI() {
//  return new Container(
//  padding: new EdgeInsets.all(20.0),
//  child: new ListView(
//  children: <Widget>[
//  new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
//  new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
//  new Text(
//  'Name : $username',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Phone Number : $phone',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Ratings : $ratings',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Website : $website',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Location : $location',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  RaisedButton(
//  onPressed: _launchURL,
//  child: Text('Show Location'),
//  ),
//  new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
//  //2nd Vendor
//  new Text(
//  'Name : $username2',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Phone Number : $phone2',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Ratings : $ratings2',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Website : $website2',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Location : $location2',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  RaisedButton(
//  onPressed: _launchURL2,
//  child: Text('Show Location'),
//  ),
//  new Padding(padding: new EdgeInsets.symmetric(vertical: 6.0)),
//  //3rd Vendor
//  new Text(
//  'Name : $username3',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Phone Number : $phone3',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Ratings : $ratings3',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Website : $website3',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  new Text(
//  'Location : $location3',
//  style: Theme.of(context).textTheme.headline6,
//  ),
//  RaisedButton(
//  onPressed: _launchURL3,
//
//  child: Text('Show Flutter homepage'),
//  ),
//  ],
//  ),
//  );
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
                          style: TextStyle(
                              fontFamily: 'Open Sans', fontSize: 23),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.only(left: 25, right: 0),
                      child: Image.asset(
                        'asset/logo3.png',
                        fit: BoxFit.contain,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: FlatButton(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    color: Colors.green,
                    child: Text("Get Location"),
                  ),
                ),
                Text(place1),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(' Name : $username'),
                        subtitle: Text('Phone number : $phone \n '
                            'Ratings : $ratings \n Website : $website'
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Show location'),
                            onPressed: () {
                              _launchURL();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(''),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(' Name : $username2'),
                        subtitle: Text('Phone number : $phone2 \n '
                            'Ratings : $ratings2 \n Website : $website2'
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Show location'),
                            onPressed: () {
                              _launchURL2();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(''),

                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(' Name : $username3'),
                        subtitle: Text('Phone number : $phone3 \n '
                            'Ratings : $ratings \n Website : $website3'
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Show location'),
                            onPressed: () {
                              _launchURL3();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      }
  }
