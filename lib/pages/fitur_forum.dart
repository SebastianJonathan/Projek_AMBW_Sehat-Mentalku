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


class AddComment extends StatelessWidget {
  const AddComment({super.key});

  @override
  Widget build(BuildContext context) {
    final comment = TextEditingController();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Tambah Komentar"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewComment()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor:0.8,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text("Masukkan Komentar Anda"),
                SizedBox(height: 5.0,),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black87,
                    )
                  ),
                  child: TextField(
                    controller: comment,
                    decoration: InputDecoration(
                      hintText: "Masukkan comment disini..",
                      contentPadding: EdgeInsets.all(5),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none
                      )
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                SizedBox(
                  width: 130,
                  height: 35,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Colors.amber),
                      foregroundColor: const MaterialStatePropertyAll(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    onPressed: (){
                      CollectionReference users = FirebaseFirestore.instance.collection('commentForum');
                      Map<String, dynamic> data = {
                        'Username' : userComment,
                        'Isi' : isi,
                        'UserComment' : loggedIn,
                        'Comment' : comment.text
                      };
                    
                      users
                        .add(data)
                        .then((value) => print('Data inserted successfully.'))
                        .catchError((error) => print('Failed to insert data: $error'));
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewComment()),
                      );
                    },
                    child: Text("Add Comment")),
                )
              ],
            ),
          ),
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}


class AddForum extends StatelessWidget {
  const AddForum({super.key});

  @override
  Widget build(BuildContext context) {
    final curahan = TextEditingController();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Add Article"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HalamanForum()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor:0.8,
            child: Column(
              children: [
                SizedBox(height: 15.0,),
                Text("Masukkan Curahan Hati Anda"),
                SizedBox(height: 5.0,),
                TextField(
                  controller: curahan,
                  decoration: InputDecoration(
                    hintText: "Masukkan disini..",
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none
                    )
                  ),
                ),
                SizedBox(height: 15.0,),
                SizedBox(
                  width: 100,
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
                    onPressed: (){
                      CollectionReference users = FirebaseFirestore.instance.collection('listPostForum');
                      Map<String, dynamic> data = {
                        'Username' : loggedIn,
                        'Isi' : curahan.text,
                      };
                              
                      users
                        .add(data)
                        .then((value) => print('Data inserted successfully.'))
                        .catchError((error) => print('Failed to insert data: $error'));
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HalamanForum()),
                      );
                    },
                    child: Text("Add Post")),
                )
              ],
            ),
          ),
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}


class ViewComment extends StatelessWidget {
  const ViewComment({Key? key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Forum"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HalamanForum()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('commentForum').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return CircularProgressIndicator();
            }
    
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String users = data['Username'];
                String isi = data['Isi'];
                String userNow = data['UserComment'];
                String comment = data['Comment'];
                if (users == userComment && isi == isi) {
                  return Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userNow,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            comment,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddComment()),
            );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: CustomFABLoc(),
    
        bottomSheet: const Iklan(),
      ),
    );
  }
}


class HalamanForum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Forum'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Forum()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('listPostForum').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
    
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
    
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String username = data['Username'];
                String isi = data['Isi'];
    
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          isi,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            userComment = username;
                            isi = isi;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewComment()),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.comment),
                              SizedBox(width: 8),
                              Text('comment'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddForum()),
            );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: CustomFABLoc(),
    
        bottomSheet: const Iklan(),
      ),
    );
  }
}


class TambahArticle extends StatelessWidget {
  const TambahArticle({super.key});

  @override
  Widget build(BuildContext context) {
    final judul = TextEditingController();
    final ringkasan = TextEditingController();
    final isi = TextEditingController();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Add Article"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListArticle()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 10.0,),
              Text("Masukkan Judul Artikel"),
              SizedBox(height: 5.0,),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  controller: judul,
                  decoration: const InputDecoration(
                    hintText: "Masukkan judul artikel disini..",
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none
                    )
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Text("Masukkan Ringkasan Artikel"),
              SizedBox(height: 5.0,),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  controller: ringkasan,
                  decoration: InputDecoration(
                    hintText: "Masukkan ringkasan artikel disini..",
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none
                    )
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Text("Masukkan Isi Artikel"),
              SizedBox(height: 5.0,),
              FractionallySizedBox(
                widthFactor:0.8,
                child: TextField(
                  controller: isi,
                  decoration: InputDecoration(
                    hintText: "Masukkan isi artikel disini..",
                    filled: true,
                    fillColor: Colors.white,
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none
                    )
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              SizedBox(
                width: 120,
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
                  onPressed: (){
                    CollectionReference users = FirebaseFirestore.instance.collection('listArticle');
                    Map<String, dynamic> data = {
                      'Judul' : judul.text,
                      'Ringkasan' : ringkasan.text,
                      'Isi' : isi.text
                    };
                          
                    users
                      .add(data)
                      .then((value) => print('Data inserted successfully.'))
                      .catchError((error) => print('Failed to insert data: $error'));
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListArticle()),
                    );
                  },
                  child: Text("Add Article")),
              )
            ],
          ),
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}


class ViewArticle extends StatelessWidget {
  const ViewArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(judulArticle),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListArticle()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('listArticle').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return CircularProgressIndicator();
            }
    
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String judul = data['Judul'];
                String isi = data['Isi'];
                if(judul == judulArticle){
                  return Column(
                    children: [
                      // Text(
                      //   judul,
                      //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      // ),
                      SizedBox(height: 15.0,),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          isi,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     backgroundColor: const MaterialStatePropertyAll(Colors.amber),
                      //     foregroundColor: const MaterialStatePropertyAll(Colors.black),
                      //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      //       const RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.all(Radius.circular(30)),
                      //         side: BorderSide.none,
                      //       ),
                      //     ),
                      //   ),
                      //   onPressed: (){
                      //     Navigator.pop(context);
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => ListArticle()),
                      //     );
                      //   }, 
                      //   child: Text("Done Reading")
                      // ),
                      const SizedBox(height: 55.0),
                    ],
                  );
                }else{
                  return SizedBox();
                }
              }
            );
          }
        ),

      bottomSheet: const Iklan(),

      );
  }
}


class ListArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Artikel'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Forum()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('listArticle').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return CircularProgressIndicator();
            }
    
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String judul = data['Judul'];
                String ringkasan = data['Ringkasan'];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          judul,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          ringkasan,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Read'),
                            onPressed: () {
                              judulArticle = judul;
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewArticle()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TambahArticle()),
            );
          },
          child: Icon(Icons.add),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonLocation: CustomFABLoc(),

      bottomSheet: const Iklan(),

      ),
    );
  }
}


class TambahGroup extends StatelessWidget {
  const TambahGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final nama = TextEditingController();
    final deskripsi = TextEditingController();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Add Group"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListGroupPage()),
                );
              }, 
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                  
              ),
            ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Text("Masukkan Nama Group"),
              SizedBox(height: 5.0,),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
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
                  child: TextField(
                    controller: nama,
                    decoration: InputDecoration(
                      hintText: "Masukkan nama group disini.."
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Text("Masukkan Deskripsi Group"),
              SizedBox(height: 5.0,),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
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
                  child: TextField(
                    controller: deskripsi,
                    decoration: InputDecoration(
                      hintText: "Masukkan deskripsi group disini.."),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              SizedBox(
                width: 100,
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
                  onPressed: (){
                    CollectionReference users = FirebaseFirestore.instance.collection('listGroupForum');
                    Map<String, dynamic> data = {
                      'Nama' : nama.text,
                      'Deskripsi' : deskripsi.text
                    };
                  
                    users
                      .add(data)
                      .then((value) => print('Data inserted successfully.'))
                      .catchError((error) => print('Failed to insert data: $error'));
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListGroupPage()),
                    );
                  },
                  child: Text("Add Group")),
              )
            ],
          ),
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}


class ChatGroupRoom extends StatelessWidget {
  const ChatGroupRoom({Key? key});

  @override
  Widget build(BuildContext context) {
    final chat = TextEditingController();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Chat Room"),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("chatGroup").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String namaPengirim = data['Sender'];
                      String namaGroup = data['Group'];
                      String chat = data['message'];
    
                      if (namaGroup == namaGrup && namaPengirim == loggedIn) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loggedIn,
                                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    chat,
                                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (namaGroup == namaGrup && namaPengirim != loggedIn) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    namaPengirim,
                                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    chat,
                                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                                  ),
                                ],
                              ),
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
            Container(
              decoration: BoxDecoration(color: Colors.white),
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
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        DateTime currentTime = DateTime.now();
                        CollectionReference users = FirebaseFirestore.instance.collection('chatGroup');
                        DocumentReference doc = users.doc(currentTime.toString());
                
                        Map<String, dynamic> data = {
                          'Sender': loggedIn,
                          'Group': namaGrup,
                          'message': chat.text
                        };
                
                        doc.set(data);
                        chat.text = "";
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ListGroupPage()),
                        );
                      },
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const Iklan()
          ],
        ),

      // bottomSheet: const Iklan(),

      ),
    );
  }
}


class ListGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('List Group'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Forum()),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('listGroupForum').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return CircularProgressIndicator();
            }
    
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String nama = data['Nama'];
                String info = data['Deskripsi'];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          nama,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          info,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Join'),
                            onPressed: () {
                              namaGrup = nama;
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatGroupRoom()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TambahGroup()),
            );
          },
          child: Icon(Icons.add),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonLocation: CustomFABLoc(),
      
      bottomSheet: const Iklan(),
      
      ),
    );
  }
}


class Forum extends StatelessWidget {
  const Forum({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Forum'),
          backgroundColor: Colors.blue,
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
                        MaterialPageRoute(builder: (context) => ListGroupPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 60), 
                    ),
                    child: Text('Group Chat'),
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HalamanForum()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 60), 
                    ),
                    child: Text('Forum'),
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListArticle()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 60), 
                    ),
                    child: Text('Artikel'),
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
