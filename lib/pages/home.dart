import 'package:appsehat/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../dbservices.dart';
import '../firebase_options.dart';
import 'custom_widgets.dart';
import '../global_data.dart';
import 'fitur_curhat.dart';
import 'fitur_konsultasi.dart';
import 'fitur_forum.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    return Scaffold(
      body: BackgroundMain(
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60.0),

                Image.asset(
                  'assets/logo.png', 
                  height: 280,
                  width: 280,
                ),

                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Username',
                      fillColor: Colors.white,
                      floatingLabelStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none
                      )
                    ),
                  ),
                ),
                
                const SizedBox(height: 12.0),
                
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Password',
                      fillColor: Colors.white,
                      floatingLabelStyle: TextStyle(
                        color: Colors.black45,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none
                      )
                    ),
                    obscureText: true,
                  ),
                ),
                
                const SizedBox(height: 15.0),
                
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(Colors.amber),
                          foregroundColor: const MaterialStatePropertyAll(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              // side: BorderSide(color: Colors.black)
                            ),
                          ),
                        ),
                        child: const Text('Register'),
                        onPressed: () {
                          final newUser = user(
                            username: _usernameController.text,
                            password: _passwordController.text,
                            status: "Active",
                          );
                          Database.addData(users: newUser);
                          _usernameController.text = "";
                          _passwordController.text = "";
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyApp()),
                          );
                        },
                      ),
                    ),
        
                    const SizedBox(width: 20.0),
        
                    SizedBox(
                      width: 90,
                      height: 35,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(Colors.amber),
                          foregroundColor: const MaterialStatePropertyAll(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              side: BorderSide.none,
                            ),
                          ),
                        ),
                        child: const Text('Login'),
                        onPressed: () async {
                          final enteredUsername = _usernameController.text;
                          final enteredPassword = _passwordController.text;
                                  
                          final snapshot = await FirebaseFirestore.instance
                              .collection('userTable')
                              .get();
                                  
                          bool foundUser = false;
                          for (final doc in snapshot.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            final username = data['username'] as String;
                            final password = data['password'] as String;
                            final status = data['status'] as String;
                                  
                            if (enteredUsername == username &&
                                enteredPassword == password &&
                                status == "Active") {
                              foundUser = true;
                              break;
                            }
                          }
                          if (foundUser) {
                            loggedIn = enteredUsername;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          } else {
                            print("Invalid username or password");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 8.0),
              ],
            ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  Stream<List<Map<String, dynamic>>> getDatas(String collectionName) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map<Map<String, dynamic>>((doc) {
        return doc.data();
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWid = [];
    for (int i = 0; i < 10; i++) {
      listWid.add(
        ListTile(
          title: Text('History ' + i.toString()),
        ),
      );
    }
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              leading: IconButton(
                color: Colors.black,
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.menu,
                  semanticLabel: 'menu',
                ), 
            onPressed: () {
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset topLeft = Offset.zero;
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  topLeft.dx,
                  topLeft.dy,
                  overlay.size.width - topLeft.dx,
                  overlay.size.height - topLeft.dy,
                ),
                items: [
                  const PopupMenuItem(
                    child: Text('Curhat'),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text('Konsultasi Psikolog'),
                    value: 2,
                  ),
                  const PopupMenuItem(
                    child: Text('Forum'),
                    value: 3,
                  ),
                  const PopupMenuItem(
                    child: Text('Edit Profile'),
                    value: 4,
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if (value != null) {
                  if (value == 1) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Curhat()),
                    );
                  }
                  if (value == 2) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ListPsikolog()),
                    );
                  }
                  if (value == 3) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Forum()),
                    );
                  }
                }
              });
            },
          ),
                    
              title: IconButton(
                color: Colors.black,
                padding: EdgeInsets.all(3),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                }, 
                icon: const Icon(
                  Icons.logout_outlined,
                    
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text(
                'Hello,\n$loggedIn  ',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              thickness: 3.5,
              color: Colors.black87,
            ),
            const SizedBox(height: 10.0),
            const Center(
              child: Text(
                'Appointment',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), //color of shadow
                      spreadRadius: 3, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 1), // changes position of shadow
                    )
                  ],
                  border: Border.all(
                    color: Colors.black38,
            
                  )
            
                ),
                alignment: Alignment.centerLeft,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getDatas("listKonsultasi"),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      List<Map<String, dynamic>> dataList = snapshot.data!;
                      List<Widget> appointmentWidgets = [];
                      for (var data in dataList) {
                        String namaPsikolog = data['Psikolog'];
                        String jamMulai = data['JamMulai'];
                        String jamAkhir = data['JamBerakhir'];
                        String user = data['User'];
                        if (user == loggedIn) {
                          appointmentWidgets.add(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    "Psikolog: " + namaPsikolog,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    "Akan Mulai Pada " + jamMulai,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    "Berakhir pada " + jamAkhir,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Container(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: appointmentWidgets,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Text("No data available");
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                'History',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                height: 200,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), //color of shadow
                      spreadRadius: 3, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 1), // changes position of shadow
                    )
                  ],
                  border: Border.all(
                    color: Colors.black38,
            
                  )
            
                ),
                child: ListView(children: listWid),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      
      bottomSheet: const Iklan()

      ),
    );
  }
}
