import 'package:flutter/material.dart';

class StepperClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Steps',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Steps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentStep = 0;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Stepper(
        steps: _mySteps(),
        currentStep: this._currentStep,
        onStepTapped: (step){
          setState(() {
            this._currentStep = step;
          });
        },
        onStepContinue: (){
          setState(() {
            if(this._currentStep < this._mySteps().length - 1){
              this._currentStep = this._currentStep + 1;
            }else{
              //Logic to check if everything is completed
              print('Congratulations! You have successfully built a Rain Water Harvesting System.');
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if(this._currentStep > 0){
              this._currentStep = this._currentStep - 1;
            }else{
              this._currentStep = 0;
            }
          });
        },
      ),
    );
  }

  List<Step> _mySteps(){
    List<Step> _steps = [
      Step(
        title: Text('Step 1: Build a tank:',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 15),),
        content: Column(
          children: <Widget>[
            Text('Depending on the number of users and volume of water to be collected, decide the type of your tank (RCC, Cement, Plastic).'),
            Image.asset(
    'assets/images/image.png',fit: BoxFit.cover,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),

      Step(
        title: Text('Step 2: Connecting pipes:',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 15),),

        content:Column(
          children: <Widget>[
            Text('Depending on the size of the building decide the number of outlets from the roof to the ground level.'),
            Image.asset(
    'assets/images/image.png',fit: BoxFit.cover,
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Step 3: Filtration:',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 15),),
        content: Column(
          children: <Widget>[
            Text('Connect the RWH filter at the end of the pipe.'),
            Image.asset(
    'assets/images/image.png',fit: BoxFit.cover,
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Step 4: Storage: ',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 15),),
        content: Column(
          children: <Widget>[
            Text('Connect the other end of the filter to a pipe leading to the storage element/tank.'),
            Image.asset(
    'assets/images/image.png',fit: BoxFit.cover,
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
    ];
    return _steps;
  }
}
