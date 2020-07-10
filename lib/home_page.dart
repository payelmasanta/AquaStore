import 'package:flutter/material.dart';
import './Calculation.dart';
import './about_screen.dart';
import './connect_vendors.dart';
import './login_page.dart';
import './start_building.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class Constants {
  static const String AboutUs = 'About Us';
  static const String SignOut = 'Sign out';

  static const List<String> choices = <String>[AboutUs, SignOut];
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0, right: 50),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 35.0, right: 8.0),
                child: Text(
                  'AquaStore',
                  style: TextStyle(fontFamily: 'Open Sans'),
                )),

            //actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 69.0),
              margin: EdgeInsets.only(right: 0),
              child: PopupMenuButton<String>(
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 40,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: RaisedButton(
                    child: Text(
                      'Calculate Rainfall',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    color: Colors.blue[500],
                    elevation: 5,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Calculations(),
                          ));
                    },
                  ),
                ),
                //const SizedBox(width:100,),
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: RaisedButton(
                    child: Text(
                      'Start Building your RWH system',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StepperClass(),
                          ));
                    },
                    color: Colors.blue[300],
                  ),
                ),
                //const SizedBox( width:100,),
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: RaisedButton(
                    child: Text(
                      'Connect',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectVendors(),
                          ));
                    },
                    color: Colors.blue[100],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Steps to build an RWH system",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text("Step 1: Building a storage tank",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  margin: EdgeInsets.only(top: 30, bottom: 10, left: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Step1.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'A storage tank is built to collect the harvested rainwater,'
                    ' the capacity of storage tank is determined by size of the roof, rainfall depth'
                    ' (mm) and number of people living at a resident.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text("Step 2: Building a storage tank",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  margin: EdgeInsets.only(top: 30, bottom: 10, left: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Step2.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'Number of outlets on the roof is provided depending upon the size of the roof for the flow of rainwater, '
                    'where each outlet is covered by a mesh to stop the flow of dirt along with the rainwater.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text("Step 3:",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  margin: EdgeInsets.only(top: 30, bottom: 10, left: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Step3.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'The outlet pipes are connected to a filter, '
                    'the rainwater flows through it to remove the remaining dirt and the filtered water is stored in a tank.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text("Step 4:",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  margin: EdgeInsets.only(top: 30, bottom: 10, left: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Step4.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'A percolation pit is built to recharge the underground water for maximum usage of rainwater.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.AboutUs) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AboutScreen(),
          ));
    } else if (choice == Constants.SignOut) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    }
  }
}
