import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo_app/shared/loading.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  login(String email, String password) async {
    Map data = {
      'username': email,
      'password': password,
    };
    try {
      var response = await http.post(Uri.parse('https://todo-app-csoc.herokuapp.com/auth/login/'), body: data);
      Map token = await jsonDecode(response.body);
      print(token);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home', arguments: token);
      }
      else {
        setState(() {
          error = "Invalid Credentials";
          loading = false;
        });

      }
    }
    catch (e) {
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return  loading ? const Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff23192d),
      appBar: AppBar(
        backgroundColor: const Color(0xfffd0a54),
        elevation: 0.0,
        title:const Text('Sign In to the App', style: TextStyle(fontFamily: 'josefin'),),
        actions: [
          FlatButton.icon(onPressed: (){
            Navigator.pushReplacementNamed(context, '/register');
          }, icon:const Icon(Icons.person, color: Colors.white,), label:const Text('Register', style: TextStyle(color: Colors.white,fontFamily: 'josefin'),))
        ],
      ),
      body: Container(
        padding:const  EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '\nWelcome to your ToDo App!',
                style: TextStyle(
                  fontSize: 31.0,
                  color: Colors.white,
                  fontFamily: 'josefin'
                ),
              ),
              const SizedBox(height: 30.0,),
              const Text(
                'Sign in to view your tasks\n\n',
                style: TextStyle(
                  fontSize: 23.0,
                  color: Colors.white,
                  fontFamily: 'josefin'
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                decoration: const InputDecoration(
                  
                  hintText: 'Username',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0)
                  ),
                ),
                validator: (val) => val!.isEmpty ? 'Enter a username' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                decoration:const  InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0)
                  ),
                ),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter at least 6 characters' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height:30.0,),
              Center(
                child: RaisedButton(onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await login(email, password);
                },
             color: const Color(0xfffd0a54), child: const Text('Sign In', style: TextStyle(color: Colors.white,fontFamily: 'josefin', fontSize: 16),),),
              ),
            const SizedBox(height: 12.0,),
            Center(
              child: Text(
              error,
              style:const  TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            )
            ],
          ),
        )
      ),
    );
  }
}