import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rwh_assistant/database.dart';

class Item {
  const Item(this.name);
  final String name;
}

class Calculations extends StatefulWidget {
  @override
  _CalculationsState createState() => _CalculationsState();
}

class _CalculationsState extends State<Calculations> {
  Item selectedRegion, selectedCatchment;
  double catchValue, roofsize, result; //catchValue is the runn-off factor
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Item> region = <Item>[
    const Item('North'),
    const Item('East'),
    const Item('South'),
    const Item('West'),
  ];

  List<Item> catchment = <Item>[
    const Item('Tiles'),
    const Item('Corrugated Metal Sheets'),
    const Item('Concrete'),
    const Item('Brick Pavement'),
  ];

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
                  //margin: EdgeInsets.only(left: 40, right: 0),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 30,
            left: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Region',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(""),
              DropdownButton<Item>(
                hint: Text("Select Region"),
                value: selectedRegion,
                onChanged: (Item Value) {
                  setState(() {
                    selectedRegion = Value;
                  });
                },
                items: region.map((Item user) {
                  //print(user.name);
                  return DropdownMenuItem<Item>(
                    value: user,
                    child: Row(
                      children: <Widget>[
                        //user.icon,
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
              // Text(""),
              // Text(
              //   'Select City',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              // ),
              Text(""),
              Row(
                children: <Widget>[
                  Text(
                    'Enter the roof size (in m\u00B2):     ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 37,
                    width: 100,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Roofsize can not be blank';
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
                    ),
                  ),
                ],
              ),
              // catchment start
              Text(""),
              Text(
                'Select Catchment Type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              DropdownButton<Item>(
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
              //catchment end
              RaisedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    _formKey.currentState.save();
                    submitit(roofsize, catchValue);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void submitit(double n, m) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String usr = user.uid.toString();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      result = n * m;
    }
    print(result);
    DatabaseService(uid: usr).updateUserData(result.toString());
    getData();
  }

  Future<DocumentSnapshot> getData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var resul = await Firestore.instance
        .collection("result")
        .document(firebaseUser.uid)
        .get();
    print(resul.data);
  }
}

