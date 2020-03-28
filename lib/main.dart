import 'package:flutter/material.dart';
import 'network.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Quiz App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class LoginData {
  String username = "";
  String password = "";
}

class _MyHomePageState extends State<MyHomePage> {
  LoginData _loginData = new LoginData();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container (
        padding: EdgeInsets.all(50.0),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType : TextInputType.text,
                validator : (String inValue){
                  if (inValue.length == 0){
                    return "Please enter username";
                  }
                  return null;
                },
                onSaved: (String inValue){
                  this._loginData.username = inValue;
                },
                decoration: InputDecoration(
                  // hintText: "guest",
                  labelText: "Username"
                ),
              ),
              TextFormField(
                obscureText: true,
                validator: (String inValue){

                },
                onSaved : (String inValue){
                  this._loginData.password = inValue;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password"
                ),
              ),
              RaisedButton(
                child: Text("Log in!"),
                onPressed: (){
                  if(_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    //connectionhere
                    Future<dynamic> connectedF = getBank(_loginData.username, _loginData.password);
                    dynamic conn = "";
                    connectedF.then((conn){
                      //if(conn["response"] == "false"){

                      //}
                    });
                    print("Username: ${_loginData.username}");
                    print("Password: ${_loginData.password}");
                  }
                }
              )
            ]
          )
        )
      )
    );
  }
}

