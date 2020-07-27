import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  double resrain;
  Future<void> _initForm;
  final _stateList = <StateModel>[];
  final _cityList = <City>[];

  StateModel selectedState;
  City selectedCity;
  Item selectedRegion, selectedCatchment;
  double catchValue, roofsize, result; //catchValue is the runn-off factor
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Item> catchment = <Item>[
    const Item('Tiles'),
    const Item('Corrugated Metal Sheets'),
    const Item('Concrete'),
    const Item('Brick Pavement'),
  ];

  @override
  void initState() {
    super.initState();
    _initForm = _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    _stateList.clear();
    _stateList.addAll(await _fetchStateList());
  }

  Future<List<StateModel>> _fetchStateList() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      StateModel("1", "Karnataka"),
      StateModel("2", "West Bengal"),
      StateModel("3", "Maharashtra"),
      StateModel("4", "Assam"),
    ];
  }

  Future<List<City>> _fetchCityList(String id) async {
    await Future.delayed(Duration(seconds: 1));
    if (id == "1")
      return [
        City("1", "Bangalore", 150.2),
        City("2", "Mysore", 148.1),
      ];
    if (id == "2")
      return [
        City("3", "Kolkata", 160.8),
        City("4", "Kharagpur", 166.5),
      ];
    if (id == "3")
      return [
        City("3", "Mumbai", 160.8),
        City("4", "Pune", 166.5),
      ];
    if (id == "4")
      return [
        City("3", "Guwahati", 160.8),
        City("4", "Silchar", 166.5),
      ];
    return Iterable.empty();
  }

  void _onStateSelected(StateModel selectedState) async {
    try {
      _showLoadingDialog();
      final cityList = await _fetchCityList(selectedState.id);
      setState(() {
        this.selectedState = selectedState;
        selectedCity = null;
        _cityList.clear();
        _cityList.addAll(cityList);
      });
      Navigator.pop(context);
    } catch (e) {
      //TODO: handle error
      rethrow;
    }
  }

  void _onCitySelected(City selectedCity) {
    setState(() {
      this.selectedCity = selectedCity;
      resrain = selectedCity.rain;
      print(resrain);
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: SpinKitCircle(
              color: Colors.white,
              size: 50,
            ),
          ),
        );
      },
    );
  }

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
                'Select State and City',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SafeArea(
                child: FutureBuilder<void>(
                  future: _initForm,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return _buildLoading();
                    else if (snapshot.hasError)
                      return _buildError(snapshot.error);
                    else
                      return _buildBody();
                  },
                ),
              ),
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
                  color: Colors.amber,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _formKey.currentState.save();
                    submitit(roofsize, catchValue, resrain);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitCircle(
            color: Colors.blue,
            size: 50,
          ),
          SizedBox(height: 50.0),
          Text("Initilizing Form Data"),
        ],
      ),
    );
  }

  Widget _buildError(dynamic error) {
    return Center(
      child: Text("Error occured: $error"),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        DropdownButtonFormField<StateModel>(
          hint: Text('Choose State'),
          items: _stateList
              .map((itm) => DropdownMenuItem(
                    child: Text(itm.name),
                    value: itm,
                  ))
              .toList(),
          value: selectedState,
          onChanged: _onStateSelected,
        ),
        DropdownButtonFormField<City>(
          hint: Text('Choose City'),
          items: _cityList
              .map((itm) => DropdownMenuItem(
                    child: Text(itm.name),
                    value: itm,
                  ))
              .toList(),
          value: selectedCity,
          onChanged: _onCitySelected,
        ),
      ],
    );
  }

  void submitit(double n, m, o) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String usr = user.uid.toString();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      result = n * m * o;
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

class StateModel {
  final String id;
  final String name;

  StateModel(this.id, this.name);
}

class City {
  final String id;
  final String name;
  final double rain;

  City(this.id, this.name, this.rain);
}
