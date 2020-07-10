import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './home_page.dart';

class StepperClass extends StatefulWidget {
  StepperClass({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StepperClassState createState() => new _StepperClassState();
}

class _StepperClassState extends State<StepperClass> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 40.0, right: 8.0),
                child: Text(
                  'Start Building',
                  style: TextStyle(fontFamily: 'Open Sans', fontSize: 23),
                )),
            Container(
              margin: EdgeInsets.only(left: 83, right: 0),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 50,
              ),
            ),
          ],
        ),
      ),
      body: Stepper(
        steps: _mySteps(),
        currentStep: this._currentStep,
        onStepTapped: (step) {
          setState(() {
            this._currentStep = step;
          });
        },
        onStepContinue: () {
          setState(() {
            if (this._currentStep < this._mySteps().length - 1) {
              this._currentStep = this._currentStep + 1;
            } else {
              //Logic to check if everything is completed
              _showToast();
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (this._currentStep > 0) {
              this._currentStep = this._currentStep - 1;
            } else {
              this._currentStep = 0;
            }
          });
        },
      ),
    );
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: Text(
          'Step 1: Build a tank:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: Column(
          children: <Widget>[
            Text(
                'Depending on the number of users and volume of water to be collected, decide the type of your tank (RCC, Cement, Plastic).\n'),
            //Image.asset('assets/images/image.png',fit: BoxFit.cover,),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text(
          'Step 2: Connecting pipes:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: Column(
          children: <Widget>[
            Text(
                'Depending on the size of the building decide the number of outlets from the roof to the ground level.\n'),
            //Image.asset('assets/images/image.png', fit: BoxFit.cover,),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text(
          'Step 3: Filtration:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: Column(
          children: <Widget>[
            Text('Connect the RWH filter at the end of the pipe.\n'),
            //Image.asset('assets/images/image.png', fit: BoxFit.cover,),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text(
          'Step 4: Storage: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: Column(
          children: <Widget>[
            Text(
                'Connect the other end of the filter to a pipe leading to the storage element/tank.\n'),
            //Image.asset('assets/images/image.png',fit: BoxFit.cover,),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
    return _steps;
  }

  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  _showToast() {
    Widget toast = Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black87,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
            width: 30.0,
          ),
          Text(
            "Congratulations!\nYou've successfully built a RWH system.",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }
}
