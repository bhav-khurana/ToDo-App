import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map data = {};
  Map profile = {};
  Future<void> getProfile() async {
    var response = await http.get(Uri.parse('https://todo-app-csoc.herokuapp.com/auth/profile/'), headers: {
      'Authorization': 'Token ${data['token']}',
    });
    profile = await jsonDecode(response.body);
    // print(profile);
  }

  Widget profileWidget() {
    return FutureBuilder (
      builder: ((context, snapshot) {
        print(profile);
        return profile.isEmpty ? const Center(child: CircularProgressIndicator(color: Color(0xfffd0a54),),) :  Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Center(
               child: CircleAvatar(
                  radius: 60,
                  foregroundImage: AssetImage('assets/profile.png'),
                  backgroundColor: Colors.white,
                ),
             ),
              const SizedBox(height: 40),
              const Text('Name', style: TextStyle(color:  Color.fromARGB(255, 249, 189, 99), fontSize: 25, fontFamily: 'josefin'),),
              const SizedBox(height: 10),
              Text(profile['name'],  style: const TextStyle(color:  Color.fromARGB(255, 241, 234, 197), fontSize: 16,fontFamily: 'josefin')),
              const SizedBox(height: 40,),
              const Text('Email', style: TextStyle(color:  Color.fromARGB(255, 249, 189, 99), fontSize: 25,fontFamily: 'josefin'),),
              const SizedBox(height: 10),
              Text(profile['email'],  style: const TextStyle(color:  Color.fromARGB(255, 241, 234, 197), fontSize: 16,fontFamily: 'josefin')),
              const SizedBox(height: 40,),
              const Text('Username', style: TextStyle(color:  Color.fromARGB(255, 249, 189, 99), fontSize: 25,fontFamily: 'josefin'),),
              const SizedBox(height: 10),
              Text(profile['username'],  style: const TextStyle(color:  Color.fromARGB(255, 241, 234, 197), fontSize: 16,fontFamily: 'josefin')),
              const SizedBox(height: 40,),
              const Text('ID', style: TextStyle(color:  Color.fromARGB(255, 249, 189, 99), fontSize: 25,fontFamily: 'josefin'),),
              const SizedBox(height: 10),
              Text('${profile['id']}',  style: const TextStyle(color:  Color.fromARGB(255, 241, 234, 197), fontSize: 16,fontFamily: 'josefin')),
              const SizedBox(height: 10,),
            ],
          ),
        );
      }),
      future: getProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    print(data);
    // getProfile();
    return Scaffold(
      backgroundColor: const Color(0xff23192d),
      appBar: AppBar(
        backgroundColor: const Color(0xfffd0a54),
        title:const Text('Your Profile', style: TextStyle(fontSize: 23.0, letterSpacing: 0.8, fontFamily: 'josefin'),),
        centerTitle: true,
      ),
      body: profileWidget(),
    );
  }
}