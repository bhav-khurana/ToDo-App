import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List tasks = [];
  Map data = {};
  bool val = false;
  final Map<int,dynamic> completed = {};
  late List dtasks = List.from(tasks);

  //getting tasks
  Future<void> getTasks() async {
    var response = await http.get(Uri.parse('https://todo-app-csoc.herokuapp.com/todo/'), headers: {
      'Authorization': 'Token ${data['token']}'
    });
    tasks = await jsonDecode(response.body);
    for (int i = 0; i < tasks.length; i++) {
      if (completed[tasks[i]['id']] == true) continue;
      completed[tasks[i]['id']] = false;
    }
  }

  //creating a task
  Future<void> createTask(String title) async {
    await http.post(Uri.parse('https://todo-app-csoc.herokuapp.com/todo/create/'), body: {
      'title': title
    }, headers: {
      'Authorization': 'Token ${data['token']}'
    });
    await getTasks();
  }

  //deleting a task
  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('https://todo-app-csoc.herokuapp.com/todo/$id/'), headers: {
      'Authorization': 'Token ${data['token']}'
    });
  }

  //modifying a task
  Future<void> modifyTask(String newtitle, int id) async {
    await http.put(Uri.parse('https://todo-app-csoc.herokuapp.com/todo/$id/'), headers: {
      'Authorization': 'Token ${data['token']}'
    }, body: {
      'title': newtitle
    });
  }

   void updateList(String value) {
    setState(() {
      dtasks = tasks.where((element) => element['title']!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  Widget taskWidget() {
    return FutureBuilder(
      builder: (context, asyncSnapshot) {
        return tasks.isEmpty ? const Center(child: Text('Tap the button on the bottom right to start adding tasks!', style: TextStyle(fontSize: 20.0, color: Colors.white),textAlign: TextAlign.center,),) : Padding(
        padding: const EdgeInsets.fromLTRB(7, 0, 7, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // height: 80,
              color: const Color(0xff23192d),
              child: Padding(
                padding:  const EdgeInsets.fromLTRB(8, 30, 8, 0),
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tasks', style: TextStyle(fontFamily: 'josefin',fontSize: 30.0, color: Color.fromARGB(255, 255, 54, 114), fontWeight: FontWeight.bold, letterSpacing: 1.4),),
                        
                        const SizedBox(height: 10,),
                        IconButton(onPressed: () {
                        Navigator.pushNamed(context, '/profile', arguments: data);
                      }, icon: const Icon(Icons.account_circle, color: Color.fromARGB(255, 241, 234, 197),),)
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                     Container(
                      alignment: Alignment.center,
                       width: double.infinity,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: const Color.fromARGB(255, 241, 234, 197),
                        ),
                       child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Padding(
                              padding: EdgeInsets.only(left: 14),
                              child: Icon(Icons.search, color: Colors.black,),
                            ),
                            hintText: 'Search for Tasks',
                          ),
                          onChanged: (val) => updateList(val),
                        ),
                     ),
                     const SizedBox(height: 15,)
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dtasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: const Color(0xfffebf97),
                        color: const Color.fromARGB(255, 241, 234, 197),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      
                      child: ExpansionTile(
                        textColor:  Colors.black,
                        iconColor:  Colors.black,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 13.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton.icon(onPressed: () async {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context, builder: (context) {
                                    return Center(child:LoadingAnimationWidget.newtonCradle(
                                      color: const Color(0xfffd0a54),
                                      size: 150,
                                    ),);
                                  });
                                  await deleteTask(tasks[index]['id']);
                                  await getTasks();
                                  
                                  setState(() {dtasks = tasks;});
                                  Navigator.pop(context);
                                  
                                }, icon: const Icon(Icons.delete, size: 18,color: Color(0xfffd0a54),), label: const Text('Delete', style: TextStyle(color: Colors.black),),),
                                OutlinedButton.icon(onPressed: () async {
                                  String newtitle = '';
                                  bool load = false;
                                  await showDialog(
                                    barrierDismissible: false,
                                    context: context, builder: (context) {
                                    return Dialog(
                                      insetPadding: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 15,
                                      child: Container(
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                          return load ? Center(child: LoadingAnimationWidget.newtonCradle(
                                          color: const Color(0xfffd0a54),
                                          size: 150,
                                        ),): Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    hintText: 'Enter new title',
                                                  ),
                                                  onChanged: (val) => newtitle = val,
                                                ),
                                                const SizedBox(height: 20.0,),
                                                OutlinedButton.icon(onPressed: () async {
                                                  setState(() {
                                                    load = true;
                                                  });
                                                  await modifyTask(newtitle, tasks[index]['id']);
                                                  await getTasks();
                                                  
                                                  Navigator.pop(context);
                                                }, icon: const Icon(Icons.done_rounded, color: Color(0xfffd0a54),), label: const Text('Modify', style: TextStyle(color: Colors.black, fontFamily: 'josefin', fontSize: 15) ))
                                              ],
                                            ),
                                          );}
                                        ),
                                      ),
                                    );
                                  });
                                  setState(() {dtasks = tasks;});
                                }, icon: const Icon(Icons.change_circle, size: 18, color: Color(0xfffd0a54),),label: const Text('Modify', style: TextStyle(color: Colors.black)),),
                                // const SizedBox(height: 40,)
                              ],
                            ),
                          )
                        ],
                        title: Container(
                          width: 57,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 234, 197),
                    
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: CheckboxListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: Row(
                                children: [
                                  Flexible(child: Text(dtasks[index]['title'], style: TextStyle(fontSize: 18,decoration: completed[dtasks[index]['id']] ? TextDecoration.lineThrough : null))),
                                ],
                              ),
                              value: completed[dtasks[index]['id']],
                              onChanged: (bool? b) {
                                setState(() {
                                  completed[dtasks[index]['id']] = !completed[dtasks[index]['id']];
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },),
            ),
          ],
        ),
      );
      },
      future: getTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
            backgroundColor: const Color(0xff23192d),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacementNamed(context, '/login');
          }, icon: const Icon(Icons.logout, size: 20,))
        ],
        backgroundColor: const Color(0xfffd0a54),
        title:const Text('Your To-Do List', style: TextStyle(fontSize: 23.0, letterSpacing: 0.8, fontFamily: 'josefin'),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        String title = '';
        bool loading = false;
        await showDialog(
          barrierDismissible: false,
          context: context, builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 15,
            child: Container(
              height: 150,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                return loading ? Center(child:LoadingAnimationWidget.newtonCradle( color: const Color(0xfffd0a54),size: 150,),) : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                        ),
                        onChanged: (val) => title = val,
                      ),
                      const SizedBox(height: 20.0,),
                      OutlinedButton.icon(onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await createTask(title);
                        await getTasks();
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.done_rounded, color: Color(0xfffd0a54),), label: const Text('Add', style: TextStyle(fontFamily: 'josefin', color: Colors.black),))
                    ],
                  ),
                );}
              ),
            ),
          );
        });
        setState(() {dtasks = tasks;});
      },
      backgroundColor: const Color(0xfffd0a54),
      child: const Icon(Icons.add_task, size: 25.0,), ),
      body: taskWidget(),
    );
  }
}