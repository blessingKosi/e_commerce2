import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting, _obscureText = true;
  String _username, _email, _password;

  Widget _showTitle() {
    // ignore: deprecated_member_use
    return Text('Register', style: Theme.of(context).textTheme.headline1);
  }

  Widget _showUsernameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _username = val,
            validator: (val) => val.length < 6 ? 'Username too short' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter username, min length 6',
                icon: Icon(Icons.face, color: Colors.grey))));
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _email = val,
            validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter a valid email',
                icon: Icon(Icons.mail, color: Colors.grey))));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _password = val,
            validator: (val) => val.length < 6 ? 'Username too short' : null,
            obscureText: _obscureText,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                    child: Icon(_obscureText
                        ? Icons.visibility
                        : Icons.visibility_off)),
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter password, min length 6',
                icon: Icon(Icons.lock, color: Colors.grey))));
  }

  Widget _showFormActions() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor))
              // ignore: deprecated_member_use
              : ElevatedButton(
                  child: Text('Submit',
                      style: Theme.of(context)
                          .textTheme
                          // ignore: deprecated_member_use
                          .bodyText1
                          .copyWith(color: Colors.black)),
                  // elevation: 8.0,
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  // color: Theme.of(context).primaryColor,
                  onPressed: _submit),
          // ignore: deprecated_member_use
          TextButton(
              child: Text('Existing user? Login'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'))
        ]));
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() => _isSubmitting = true);
    http.Response response = await http.post(
        'http://192.168.100.14:1337/auth/local/register',
        body: {"username": _username, "email": _email, "password": _password});
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    } else {
      setState(() => _isSubmitting = false);
      final String errorMsg = responseData['message'];
      _showErrorSnack(errorMsg);
    }
  }

  void _storeUserData(responseData) async {
    // geting an instance of shared preferences
    final prefs = await SharedPreferences.getInstance();
    // values are stored in shares preferences as a key value pair
    // taking our user data from the successful response for registreing
    Map<String, dynamic> user = responseData['user'];
    // combining that in a map with a json web token
    user.putIfAbsent('jwt', () => responseData['jwt']);
    // turning the map into a string to put as a key value pair into
    //shared preferences
    prefs.setString('user', json.encode(user));
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text('User $_username successfully created!',
            style: TextStyle(color: Colors.green)));
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar =
        SnackBar(content: Text(errorMsg, style: TextStyle(color: Colors.red)));
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    throw Exception('Error registering: $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Register')),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          _showTitle(),
                          _showUsernameInput(),
                          _showEmailInput(),
                          _showPasswordInput(),
                          _showFormActions()
                        ]))))));
  }
}
