import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:primo_ng/categories.dart';
import 'package:primo_ng/sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/primonigeria.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.withOpacity(0.2), Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Hero(
                      //   tag: 'logo',
                      //   child: FlutterLogo(size: 150),
                      // ),
                      SizedBox(height: 50),
                      _signInButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signInButton() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    return Hero(
      tag: 'logo',
      child: OutlineButton(
        splashColor: Colors.orange,
        color: Colors.deepOrangeAccent,
        onPressed: () {
          signInWithGoogle().then((result) {
            if (result != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Categories();
                  },
                ),
              );
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("images/primologo.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
