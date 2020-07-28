import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rwh_assistant/Result.dart';
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
  Future<void> _initForm;
  final _stateList = <StateModel>[];
  final _cityList = <City>[];
  double resrain_dry, resrain_wet, demand;
  int people;
  StateModel selectedState;
  City selectedCity;
  Item selectedRegion, selectedCatchment;
  double catchValue,
      roofsize,
      result_dry,
      result_wet; //catchValue is the runn-off factor
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
    ];
  }

  Future<List<City>> _fetchCityList(String id) async {
    await Future.delayed(Duration(seconds: 1));
    if (id == "1")
      return [
        City("1", "Bangalore", 5, 150),
        City("2", "Mysore", 48, 160),
      ];
    if (id == "2")
      return [
        City("3", "Kolkata", 85, 180),
        City("4", "Kharagpur", 66, 270),
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

  void onCitySelected(City selectedCity) {
    setState(() {
      this.selectedCity = selectedCity;
      resrain_dry = selectedCity.dry_rain;
      resrain_wet = selectedCity.wet_rain;
      print(resrain_dry);
      print(resrain_wet);
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 20),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Text(
                  'Calculate Rainfall',
                  style: TextStyle(fontFamily: 'Open Sans'),
                )),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Text(
                  'Select State and City',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
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
                  "20 litres per day. In semi-arid areas people often use less than 20 liters per person per day"),
              Text(""),
              Text(''),
              Text(''),
              Container(
                //padding: EdgeInsets.only(left:10, right:0),
                child: Text(
                  'Select Catchment Type:',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
              RaisedButton(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  color: Colors.amber,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _formKey.currentState.save();
                    submitit(roofsize, catchValue, resrain_dry, resrain_wet);
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
          CupertinoActivityIndicator(animating: true),
          SizedBox(height: 25.0),
          Text(
            "Initilizing Form Data",
            style: TextStyle(fontSize: 15),
          ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 150,
          //padding: EdgeInsets.only(left:10, right:0),
          child: DropdownButtonFormField<StateModel>(
            hint: Text('Choose State'),
            items: _stateList
                .map((itm) => DropdownMenuItem(
                      value: itm,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            itm.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: selectedState,
            onChanged: _onStateSelected,
          ),
        ),
        Container(
          width: 150,
          //padding: EdgeInsets.only(left:10, right:0),
          child: DropdownButtonFormField<City>(
            hint: Text('Choose City'),
            items: _cityList
                .map((itm) => DropdownMenuItem(
                      child: Text(itm.name),
                      value: itm,
                    ))
                .toList(),
            value: selectedCity,
            onChanged: onCitySelected,
          ),
        )
      ],
    );
  }

  void submitit(double n, m, d, w) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String usr = user.uid.toString();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      result_dry = (n * m) * d;
      result_wet = (n * m) * w;
      print(result_dry);
      print(result_wet);
    }

    DatabaseService(uid: usr)
        .updateUserData(result_dry.toString(), result_wet.toString());
    getData();
  }

  Future<void> getData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var resul = await Firestore.instance
        .collection("result")
        .document(firebaseUser.uid)
        .get();
    print(resul.data);
    if (resul.data != null) {
      Column(
        children: <Widget>[
          Text("The rainfall varies from"),
          Text(resul.data.toString()),
        ],
      );
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(resul.data.toString()),
        ));
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
  final double dry_rain;
  final double wet_rain;

  City(this.id, this.name, this.dry_rain, this.wet_rain);
}
