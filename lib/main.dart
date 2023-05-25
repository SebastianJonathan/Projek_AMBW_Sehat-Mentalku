import 'package:appsehat/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dbservices.dart';
import 'firebase_options.dart';

String loggedIn = "user";
String lawanChat = "user";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      title: "SEHAT MENTALKU",
      home: MyApp(),
    ),
  );
}

class ChatRoom extends StatelessWidget {
  const ChatRoom({Key? key});

  @override
  Widget build(BuildContext context) {
    final chat = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("chatCurhat").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return Text("No data available");
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    String namaPengirim = data['Sender'];
                    String namaPenerima = data['Reciever'];
                    String chat = data['message'];
                    if (namaPengirim == loggedIn && namaPenerima == lawanChat) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            chat,
                            style: TextStyle(fontSize: 24.0, color: Colors.white), 
                          ),
                        ),
                      );
                    } else if (namaPengirim == lawanChat && namaPenerima == loggedIn) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            chat,
                            style: TextStyle(fontSize: 24.0, color: Colors.white), 
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chat,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Text Disini...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    CollectionReference users = FirebaseFirestore.instance.collection('chatCurhat');
    
                    Map<String, dynamic> data = {
                      'Sender' : loggedIn,
                      'Reciever' : lawanChat,
                      'message' : chat.text
                    };

                    users
                        .add(data)
                        .then((value) => print('Data inserted successfully.'))
                        .catchError((error) => print('Failed to insert data: $error'));
                    chat.text = "";
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaitingRoom extends StatelessWidget {
  const WaitingRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting...'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("pairingCurhat").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Text("No data available");
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String namaPendengar = data['Pendengar'];
              String namaCurhat = data['Curhat'];
              bool firstTime = true;
              if(namaPendengar == loggedIn){
                lawanChat = namaCurhat;
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatRoom()),
                );
                return Text('Dapat Pencurhat, Namanya ' + namaCurhat);
              }else{
                if(firstTime == true){
                  firstTime = false;
                  return Text('Please Wait.....');
                }else{
                  return Text(' ');
                }
              }
            },
          );
        },
      )
    );
  }
}

class HomePage extends StatelessWidget {
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
    List<Widget> listWid2 = [];
    for (int i = 0; i < 10; i++) {
      listWid2.add(
        ListTile(
          title: Text('Appointment ' + i.toString()),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final Offset topLeft = Offset.zero; // Top left corner of the screen
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
                  child: Text('Curhat Anonim'),
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
              }
            });
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Logged In As : ' + loggedIn,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
          )),
          const SizedBox(height: 20.0),
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
          Container(
            height: 200,
            child: ListView(children: listWid2),
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
          Container(
            height: 200,
            child: ListView(children: listWid),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class listPendengar extends StatelessWidget {
  const listPendengar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Pendengar"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("listPendengar").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Text("No data available");
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String namaPendengar = data['User'];

              return GestureDetector(
                onTap: () {
                  CollectionReference users = FirebaseFirestore.instance.collection('pairingCurhat');
                  lawanChat = namaPendengar;
  
                  Map<String, dynamic> data = {
                    'Curhat' : loggedIn,
                    'Pendengar' : namaPendengar
                  };

                  users
                      .add(data)
                      .then((value) => print('Data inserted successfully.'))
                      .catchError((error) => print('Failed to insert data: $error'));
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatRoom()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    namaPendengar,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Curhat extends StatelessWidget {
  const Curhat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curhat'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final Offset topLeft = Offset.zero; // Top left corner of the screen
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
                  child: Text('Home'),
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
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              }
            });
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const listPendengar()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 60), 
                ),
                child: Text('Curhat'),
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () {
                  CollectionReference users = FirebaseFirestore.instance.collection('listPendengar');
  
                  // Example data
                  Map<String, dynamic> data = {
                    'User' : loggedIn
                  };

                  users
                      .add(data)
                      .then((value) => print('Data inserted successfully.'))
                      .catchError((error) => print('Failed to insert data: $error'));
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WaitingRoom()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 60), 
                ),
                child: Text('Menjadi Pendengar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sehat Mentalku"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 80.0),
          const Center(
            child: Text(
              'SEHAT MENTALKU',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 120.0),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
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
              ElevatedButton(
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
                  // Handle the login result
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
            ],
          ),
          const SizedBox(
              height: 8.0), // Add appropriate spacing between content
        ],
      ),
    );
  }
}
