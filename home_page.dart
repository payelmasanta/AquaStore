import 'package:flutter/material.dart';
import './main_drawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
  final List<String> entries = <String>['Rainfall Calculator', 'Start Building your RWH system', 'Connect'];
  final List<int> colorCodes = <int>[600, 300, 100];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RWH Assistant',
          style: TextStyle(fontFamily: 'Open Sans'),
        ),
      ),
      drawer: MainDrawer(),
      body:  return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [
       Container(
       height: 70,width: double.infinity,
       padding: EdgeInsets.symmetric(vertical: 10, horizontal:10),
         child:
           RaisedButton(
              child: Text('Calculate Rainfall', style: TextStyle(fontWeight:FontWeight.bold ),),
             color:Colors.blue[500],
               elevation: 5,


              onPressed: (){},

          ),
           ),
           //const SizedBox(width:100,),
      Container(
          height: 70,width: double.infinity,
        padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
           child:
           RaisedButton(
               child: Text('Start Building your RWH system', style: TextStyle(fontWeight:FontWeight.bold ),),
               onPressed: (){},
               color:Colors.blue[300],


           ),
      ),
           //const SizedBox( width:100,),
           Container(
             height: 70,width: double.infinity,
             padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
           child:
           RaisedButton(
               child: Text('Connect', style: TextStyle(fontWeight:FontWeight.bold ),),
               onPressed: (){},
               color:Colors.blue[100],


           ),
           ),

    ]

      ),
    );
  }
}
