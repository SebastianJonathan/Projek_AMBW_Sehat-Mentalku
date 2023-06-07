import 'package:appsehat/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../dbservices.dart';
import '../firebase_options.dart';
import '../global_data.dart';
import 'custom_widgets.dart';
import 'home.dart';


class listPendengar extends StatelessWidget {
  const listPendengar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("List Pendengar"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Curhat()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
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
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black87,
                        )
                      ),
                      child: Text(
                        namaPendengar,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}


class Curhat extends StatelessWidget {
  const Curhat({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Fitur Curhat"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),

        ),
        body: Container(
          alignment: Alignment.center,
          child: Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              widthFactor: 0.8,
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
                      fixedSize: const Size(200, 60), 
                    ),
                    child: const Text('Curhat'),
                  ),
                  const SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () {
                      CollectionReference users = FirebaseFirestore.instance.collection('listPendengar');
                  
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
                    child: const Text('Menjadi Pendengar'),
                  ),
                ],
              ),
            ),
          ),
        ),

        bottomSheet: const Iklan(),

      ),
    );
  }
}


class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  void deleteChat() async {
    final collection = FirebaseFirestore.instance.collection('chatCurhat');
    final snapshot = await collection.where("Sender", isEqualTo: loggedIn).get();
    for(final document in snapshot.docs){
      await document.reference.delete();
    }
  }

  void deletePairCurhat() async{
    final collection = FirebaseFirestore.instance.collection('pairingCurhat');
    final snapshot = await collection.where("Curhat", isEqualTo: loggedIn).get();
    for(final document in snapshot.docs){
      await document.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedback = TextEditingController();
    final report = TextEditingController();
    deleteChat();
    deletePairCurhat();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Feedback"),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Text(
                "Feedback :"
              ),
              SizedBox(height: 10.0,),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: TextField(
                  controller: feedback,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    hintText: "Masukkan Feedback Disini(Jika Ada)"),
                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                "Report :"
              ),
              SizedBox(height: 10.0,),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: TextField(
                  controller: report,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    hintText: "Masukkan Report Disini(Jika Ada)"),
                ),
              ),
              SizedBox(height: 10.0,),
              ElevatedButton(
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
                onPressed: (){
                  CollectionReference users = FirebaseFirestore.instance.collection('tableFeedback');
                  Map<String, dynamic> data = {
                    'User' : loggedIn,
                    'Feedback' : feedback.text
                  };
                  users.add(data);
                  CollectionReference users2 = FirebaseFirestore.instance.collection('tableReport');
                  Map<String, dynamic> data2 = {
                    'User' : loggedIn,
                    'Report' : report.text
                  };
                  users2.add(data2);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text(
                  "Submit"
                )),
            ],
          ),
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}


class ChatRoom extends StatelessWidget {
  const ChatRoom({Key? key});

  @override
  Widget build(BuildContext context) {
    final chat = TextEditingController();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Chat Room"),
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
                        if(chat == loggedIn + " Sudah Selesai" || chat == lawanChat + " Sudah Selesai"){
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FeedbackPage()),
                            );
                          });
                          return const SizedBox();
                        }
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 370,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              chat,
                              style: TextStyle(fontSize: 16.0, color: Colors.white), 
                            ),
                          ),
                        );
                      } else if (namaPengirim == lawanChat && namaPenerima == loggedIn) {
                        if(chat == loggedIn + " Sudah Selesai" || chat == lawanChat + " Sudah Selesai"){
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FeedbackPage()),
                            );
                          });
                          return const SizedBox();
                        }
                        return Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 0.75,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                chat,
                                style: TextStyle(fontSize: 16.0, color: Colors.white), 
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
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
                    IconButton (
                      icon: Icon(Icons.send),
                      onPressed: () {
                        DateTime currentTime = DateTime.now();
                        CollectionReference users = FirebaseFirestore.instance.collection('chatCurhat');
                        DocumentReference doc = users.doc(currentTime.toString());
                  
                        Map<String, dynamic> data = {
                          'Sender' : loggedIn,
                          'Reciever' : lawanChat,
                          'message' : chat.text
                        };
                
                        doc.set(data);
                        chat.text = "";
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: (){
                        DateTime currentTime = DateTime.now();
                        CollectionReference users = FirebaseFirestore.instance.collection('chatCurhat');
                        DocumentReference doc = users.doc(currentTime.toString());
                  
                        Map<String, dynamic> data = {
                          'Sender' : loggedIn,
                          'Reciever' : lawanChat,
                          'message' : loggedIn + " Sudah Selesai"
                        };
                        doc.set(data);
                      },
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const Iklan(),
          ],
        ),
      ),
    );
  }
}


class WaitingRoom extends StatelessWidget {
  const WaitingRoom({Key? key}) : super(key: key);

  void roomChat(BuildContext context, String namaCurhat) {
    lawanChat = namaCurhat;
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatRoom()),
    );
  }
  void deletePendengar() async{
    final collection = FirebaseFirestore.instance.collection('listPendengar');
    final snapshot = await collection.where("User", isEqualTo: loggedIn).get();
    for(final document in snapshot.docs){
      await document.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool firstTime = true;
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Menunggu Curhat'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Curhat()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
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
    
                if (namaPendengar == loggedIn) {
                  deletePendengar();
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    roomChat(context, namaCurhat);
                  });
                  return const SizedBox();
                } else {
                  if (index == 0 && firstTime) {
                    firstTime = false;
                    return Column(
                      children: [
                        const SizedBox(height: 30.0),
                        const Text(
                          'Please Wait.....', 
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          alignment: Alignment.topCenter,
                          // child: FractionallySizedBox(
                          //   widthFactor: 0.8,
                          //   heightFactor: 0.4,
                          //   child: 
                            child: Container(
                              width: 350,
                              height: 470,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black87,
                                ),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: const Text(
                                "IKLAN",
                                style: TextStyle(
                                  fontSize: 24,
                                )
                              )
                            )
                        ),
                        // ),
                        const SizedBox(height: 10.0),
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 50,
                        ),
                      ],

                    );
                  } else {
                    return const Text(' . ');
                  }
                }
              },
            );
          },
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}

