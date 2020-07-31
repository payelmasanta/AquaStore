import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rwh_assistant/database.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import './login_page.dart';
import 'http_exception.dart';
import './loading.dart';
import './database1.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white70,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.bold,
  fontSize: 17,
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 20,
  fontFamily: 'OpenSans',
);

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  bool loading = false;
  String username, confirmpass;
  String password, email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF73AEF5),
                        Color(0xFF61A4F1),
                        Color(0xFF478DE0),
                        Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 80,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 380,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Username:", style: kLabelStyle),
                                    TextFormField(
                                      validator: (input) {
                                        if (input.isEmpty) {
                                          return 'Username can not be blank';
                                        }
                                      },
                                      onSaved: (input) => username = input,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 13),
                                        prefixIcon: Icon(Icons.account_circle,
                                            color: Colors.white),
                                        hintText: 'Enter your name',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                    Text(""),
                                    Text("Email:", style: kLabelStyle),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      validator: validateEmail,
                                      onSaved: (input) => email = input,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 13),
                                        prefixIcon: Icon(Icons.email,
                                            color: Colors.white),
                                        hintText: 'Enter your Email',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                    Text(""),
                                    Text("Password:", style: kLabelStyle),
                                    TextFormField(
                                      obscureText: true,
                                      validator: (input) {
                                        if (input.length < 6) {
                                          return 'Please type an password with atleast 6 characters';
                                        }
                                      },
                                      onSaved: (input) => password = input,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 13),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        hintText: 'Enter Password',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                    Text(""),
                                    Text("Confirm Password:",
                                        style: kLabelStyle),
                                    TextFormField(
                                      obscureText: true,
                                      onSaved: (input) {
                                        confirmpass = input;
                                      },
                                      validator: (input) {
                                        _formKey.currentState.save();
                                        if (confirmpass != password) {
                                          return 'Password do not match';
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 13),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        hintText: 'Confirm Password',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              margin: EdgeInsets.all(20),
                              child: RaisedButton(
                                elevation: 10,
                                padding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Color(0xFF527DAA),
                                      letterSpacing: 1.5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans'),
                                ),
                                onPressed: signUp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
  }

  _showToast() {
    Widget toast = Container(
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
            "Verification email has been sent.\nPlease check your email.",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      setState(() {
        loading = true;
      });

      FirebaseUser user =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
              .user;

      await DatabaseService(uid: user.uid).updateUserData('0');
      await DatabaseServicee(uid: user.uid).updateUserDataa('0');

      //user.sendEmailVerification(); // display for user that we sent an email
      try {
        await user.sendEmailVerification();
        _showToast();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));

        return user.uid;
      } on HttpException catch (error) {
        print(error.toString());
        var errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use.';
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        print(e.toString());
        const errorMessage =
            'Could not authenticate you. Please try again later.';
        _showErrorDialog(errorMessage);
      }
    }
  }
}
