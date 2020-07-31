import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/gestures.dart';

class ConnectVendors extends StatefulWidget {
  @override
  ConnectVendorsState createState() => ConnectVendorsState();
}

class ConnectVendorsState extends State<ConnectVendors> {
  String place1 = '';
  String name, username, avatar, phone, ratings, website, location, srt;
  String username2, phone2, ratings2, website2, location2;
  String username3, phone3, ratings3, website3, location3;

  var use = new List();
  bool isData = false;
  String locationMessage1 = "";
  String place = '';

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
        place1 = " ${first.adminArea}";
        print(place1);
      });
      return place1;
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

  FetchJSON() async {
    var Response = await http.get(
      "https://gist.githubusercontent.com/thenickrj/905104869932fad8ba23986cca627aa3/raw/4bf0cb384ab97631a3721486abe66acb5d4cdb91/vendors.json",
      headers: {"Accept": "application/json"},
    );
    //var kar = "Mysuru";
    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      place = "$place1";
      print(place);
      username = responseJSON[" Karnataka"]['Bangalore'][0]["name"];
      phone = responseJSON[" Karnataka"]['Bangalore'][0]["phone"];
      ratings = responseJSON[" Karnataka"]['Bangalore'][0]["ratings"];
      website = responseJSON[" Karnataka"]['Bangalore'][0]["website"];
      location = responseJSON[" Karnataka"]['Bangalore'][0]["location"];

      print(username);
      print(phone);
      print(ratings);
      print(website);
      print(location);

      username2 = responseJSON["$place"]['Bangalore'][1]["name"];
      phone2 = responseJSON["$place"]['Bangalore'][1]["phone"];
      ratings2 = responseJSON["$place"]['Bangalore'][1]["ratings"];
      website2 = responseJSON["$place"]['Bangalore'][1]["website"];
      location2 = responseJSON["$place"]['Bangalore'][1]["location"];

      print(username2);
      print(phone2);
      print(ratings2);
      print(website2);
      print(location2);

      // username3 = responseJSON["$place"][2]["name"];
      // phone3 = responseJSON["$place"][2]["phone"];
      // ratings3 = responseJSON["$place"][2]["ratings"];
      // website3 = responseJSON["$place"][2]["website"];
      // location3 = responseJSON["$place"][2]["location"];

      isData = true;
      setState(() {
        print('UI Updated');
      });
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }

  //void initState() {FetchJSON();}

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
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
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  //margin: EdgeInsets.only(left: 25, right: 0),
                  child: Image.asset(
                    'assets/images/logo1.jpeg',
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
            FlatButton(
              onPressed: () {
                getCurrentLocation();
                setState(() {
                  FetchJSON();
                });
              },
              color: Colors.blue[300],
              child: Text(
                "Get Location",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.location_on),
                Text(place),
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: Card(
                color: Colors.blue[100],
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(""),
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Text(
                            ' Name :  $username',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.phone),
                              Text(
                                ' Phone :  $phone',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[900]),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star),
                              Text(
                                ' Ratings :  $ratings',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[900]),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.public),
                              RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: ' Website :   ',
                                      style: new TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    new TextSpan(
                                      text: 'Click on this',
                                      style: new TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue[900],
                                          fontSize: 15),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          launch('$website');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text(
                            'Show location',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _launchURL();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Text(''),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: Card(
                color: Colors.blue[100],
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(""),
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Text(
                            ' Name :  $username2',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.phone),
                              Text(
                                ' Phone :  $phone2',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[900]),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star),
                              Text(
                                ' Ratings :  $ratings2',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[900]),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.public),
                              RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: ' Website :   ',
                                      style: new TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    new TextSpan(
                                      text: 'Click on this',
                                      style: new TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue[900],
                                          fontSize: 15),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          launch('$website2');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text(
                            'Show location',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _launchURL2();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Text(''),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: Card(
                color: Colors.blue[100],
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(""),
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Text(
                            ' Name :  $username3',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.phone),
                              Text(
                                ' Phone :  $phone3',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[900]),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star),
                              Text(
                                ' Ratings :  $ratings3',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[900]),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.public),
                              RichText(
                                text: new TextSpan(
                                  children: [
                                    new TextSpan(
                                      text: ' Website :   ',
                                      style: new TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    new TextSpan(
                                      text: 'Click on this',
                                      style: new TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue[900],
                                          fontSize: 15),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          launch('$website3');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text(
                            'Show location',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _launchURL3();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
