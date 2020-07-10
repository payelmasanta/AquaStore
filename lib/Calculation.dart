import 'package:flutter/material.dart';

class Item {
  const Item(this.name);
  final String name;
}

class Calculations extends StatefulWidget {
  @override
  _CalculationsState createState() => _CalculationsState();
}

class _CalculationsState extends State<Calculations> {
  Item selectedUser;
  final myController = TextEditingController();
  List<Item> users = <Item>[
    const Item('North'),
    const Item('East'),
    const Item('South'),
    const Item('West'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculate Rainfall',
          style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
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
              value: selectedUser,
              onChanged: (Item Value) {
                setState(() {
                  selectedUser = Value;
                });
              },
              items: users.map((Item user) {
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
            Text(""),
            Text(
              'Select City',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      //labelText: 'Roof size'),
                    ),
                    controller: myController,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
