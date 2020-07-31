import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rwh_assistant/Result.dart';
import 'package:rwh_assistant/database.dart';
import './database1.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Item {
  const Item(this.name);
  final String name;
}

class Calculations extends StatefulWidget {
  @override
  CalculationsState createState() => CalculationsState();
}

class CalculationsState extends State<Calculations> {
  String mondry, monwet;
  double raindry, rainwet;
  var use = new List();
  bool isData = false;
  String locationMessage = "", place;
  String placeName = '';
  double resrain_dry = 7, resrain_wet = 8, demand;
  double result_dry, result_wet;
  int people;
  Item selectedRegion, selectedCatchment;
  double catchValue, roofsize; //catchValue is the runn-off factor
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Item> catchment = <Item>[
    const Item('Tiles'),
    const Item('Corrugated Metal Sheets'),
    const Item('Concrete'),
    const Item('Brick Pavement'),
  ];

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
        locationMessage = "${position.latitude}, ${position.longitude}";
        placeName = " ${first.subAdminArea}";
        print(placeName);
      });
      return placeName;
    } else {
      showDialog(
          context: context, builder: (BuildContext context) => errorDialog);
      // AppSettings.openLocationSettings();
    }
  }

  FetchJSON() async {
    var Response = await http.get(
      "https://gist.githubusercontent.com/payelmasanta/51322f0c991e57011ca3456cbe153d3d/raw/3a7149640cc02de19489f0bb18f586057ec4a006/kuchbhi.json",
      headers: {"Accept": "application/json"},
    );
    //var kar = "Mysuru";
    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      place = "$placeName";

      mondry = responseJSON["$place"]["month_dry"];
      raindry = responseJSON["$place"]["rain_dry"];
      monwet = responseJSON["$place"]["month_wet"];
      rainwet = responseJSON["$place"]["rain_wet"];

      print(mondry);
      print(raindry);
      print(monwet);
      print(rainwet);
      isData = true;
      setState(() {
        print('UI Updated');
      });
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Stack(
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(left: 40.0, right: 8.0),
                    child: Text(
                      'Calculate Rainfall',
                      style: TextStyle(fontFamily: 'Open Sans', fontSize: 23),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  //margin: EdgeInsets.only(left: 83, right: 0),
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
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 00),
          padding: EdgeInsets.only(
            top: 30,
            left: 5,
          ),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    color: Colors.blue[300],
                    child: Text(
                      "Get Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text(placeName),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(""),
                  Text(''),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Enter the roof size (in m\u00B2):     ',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (input) {
                              if (input.isEmpty) {
                                return ('Roofsize can not be blank');
                              }
                            },
                            onSaved: (input) {
                              roofsize = double.parse(input);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Text(''),
                          Text(''),
                          Text(
                            'Number of People using the water:',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (input) {
                              if (input.isEmpty) {
                                return ('This field can not be blank');
                              }
                            },
                            onSaved: (input) {
                              people = int.parse(input);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          Text(''),
                          Text(''),
                          Text(
                            'Water demand per person:',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (input) {
                              if (input.isEmpty) {
                                return ('This field  can not be blank');
                              }
                            },
                            onSaved: (input) {
                              demand = double.parse(input);
                              //print(demand);
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                                hintText: "(Eg: 20 liters per day per person)"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // catchment start
                  Text(
                      "The minimum water demand according to the World Health Organization (WHO) is "
                      "20 litres per day. In semi-arid areas people often use less than 20 liters per person per day."),
                  Text(""),
                  Text(''),
                  Text(''),
                  Container(
                    //padding: EdgeInsets.only(left:10, right:0),
                    child: Text(
                      'Select Catchment Type:',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(left:10, right:0),
                    child: DropdownButton<Item>(
                      hint: Text("Select Catchment Type"),
                      value: selectedCatchment,
                      onChanged: (Item Value) {
                        setState(() {
                          selectedCatchment = Value;
                          if (selectedCatchment.name == "Tiles") {
                            catchValue = 0.85;
                            //print(catchValue);
                          } else if (selectedCatchment.name ==
                              "Corrugated Metal Sheets") {
                            catchValue = 0.8;
                            //print(catchValue);
                          } else if (selectedCatchment.name == "Concrete") {
                            catchValue = 0.7;
                            //print(catchValue);
                          } else {
                            catchValue = 0.55;
                            //print(catchValue);
                          }
                          FetchJSON();
                        });
                      },
                      items: catchment.map((Item user) {
                        return DropdownMenuItem<Item>(
                          value: user,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                user.name,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  //catchment end
                  Text(""),
                  Container(
                    padding: EdgeInsets.only(right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.only(left: 0, right: 0),
                          color: Colors.blue[300],
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          onPressed: () {
                            _formKey.currentState.save();
                            submitit(roofsize, catchValue, raindry, rainwet);
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
      ),
    );
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

  void submitit(double roofsize, catvalue, resrd, resrw) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String usr = user.uid.toString();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      result_dry = (roofsize * catvalue) * resrd;
      result_wet = (roofsize * catvalue) * resrw;
      print(result_dry);
      print(result_wet);
    }

    DatabaseService(uid: usr).updateUserData(result_dry.toString());
    getData();
    DatabaseServicee(uid: usr).updateUserDataa(result_wet.toString());
    getData();
  }

  Future<void> getData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var resul = await Firestore.instance
        .collection("result_dry")
        .document(firebaseUser.uid)
        .get();

    var resul1 = await Firestore.instance
        .collection("result_wet")
        .document(firebaseUser.uid)
        .get();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
            resul.data.values.toString(),
            resul1.data.values.toString(),
            demand,
            people,
            mondry,
            monwet,
            selectedCatchment.name.toString(),
            raindry,
            rainwet,
            roofsize,
            catchValue),
      ),
    );
  }
}
