import 'package:appsehat/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dbservices.dart';
import 'firebase_options.dart';
import 'custom_widgets.dart';

String loggedIn = "user";
String lawanChat = "user";
String psikologPilihan = "user";
String namaGrup = "";
int harga = 0;
String jamMulaii = "";
String jamAkhirr = "";
String masalahKu = "";
String pesanKu = "";
String judulArticle = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SEHAT MENTALKU",
      home: MyApp(),
    ),
  );
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
        ),
        body: Column(
          children: [
            Text("Masukkan Judul Artikel"),
            SizedBox(height: 5.0,),
            TextField(
              controller: judul,
              decoration: InputDecoration(
                hintText: "Masukkan judul artikel disini.."),
            ),
            SizedBox(height: 15.0,),
            Text("Masukkan Ringkasan Artikel"),
            SizedBox(height: 5.0,),
            TextField(
              controller: ringkasan,
              decoration: InputDecoration(
                hintText: "Masukkan ringkasan artikel disini.."),
            ),
            SizedBox(height: 15.0,),
            Text("Masukkan Isi Artikel"),
            SizedBox(height: 5.0,),
            TextField(
              controller: isi,
              decoration: InputDecoration(
                hintText: "Masukkan isi artikel disini.."),
            ),
            SizedBox(height: 15.0,),
            ElevatedButton(
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
              child: Text("Add Article"))
          ],
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
              return Text("No data available");
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
                      Text(
                        judul,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15.0,),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          isi,
                          style: TextStyle(fontSize: 15),
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
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ListArticle()),
                          );
                        }, 
                        child: Text("Done Reading")
                      ),
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
              return Text("No data available");
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
        body: Column(
          children: [
            Text("Masukkan Nama Group"),
            SizedBox(height: 5.0,),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
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
                    return Text("No data available");
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
                                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (namaGroup == namaGrup && namaPengirim != loggedIn) {
                        return Align(
                          alignment: Alignment.centerRight,
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
                                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                                ),
                              ],
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
              return Text("No data available");
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
                    child: Text('Home'),
                    value: 1,
                  ),
                  const PopupMenuItem(
                    child: Text('Curhat'),
                    value: 2,
                  ),
                  const PopupMenuItem(
                    child: Text('Konsultasi Psikolog'),
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
                  if(value == 2){
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Curhat()),
                    );
                  }
                  if(value == 3){
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListPsikolog()),
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

class PaymentPage extends StatelessWidget {
  Future<List<Map<String, dynamic>>> getDatas(String collectionName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .get();

      List<Map<String, dynamic>> data = querySnapshot.docs.map<Map<String, dynamic>>((doc) {
        return doc.data();
      }).toList();
      
      return data;
    } catch (e) {
      print('Error fetching data from Firebase: $e');
      return [];
    }
  }

  void pesanPsikolog(BuildContext context,String paymentMode) async{
    bool ada = false;
    List<Map<String, dynamic>> data = await getDatas("listKonsultasi");
    if(data.isNotEmpty){
      for(var datas in data){
        if(datas['Psikolog'] == psikologPilihan){
          print('a');
          if(int.parse(datas['JamMulai'].substring(0,2)) <= int.parse(jamMulaii.substring(0,2)) && int.parse(datas['JamBerakhir'].substring(0,2)) > int.parse(jamMulaii.substring(0,2))){
            ada = true;
            if(int.parse(datas['JamMulai'].substring(0,2)) <= int.parse(jamAkhirr.substring(0,2)) && int.parse(datas['JamBerakhir'].substring(0,2)) > int.parse(jamAkhirr.substring(0,2))){
              ada = true;
            }
          }
        }
      }
      if(ada == false){
        CollectionReference users = FirebaseFirestore.instance.collection('listKonsultasi');
        Map<String, dynamic> data = {
          'User' : loggedIn,
          'Psikolog' : psikologPilihan,
          'JamMulai' : jamMulaii,
          'JamBerakhir' : jamAkhirr,
          'Masalah' : masalahKu,
          'Pesan' : pesanKu,
          'PaymentMode' : paymentMode
        };

        users
          .add(data)
          .then((value) => print('Data inserted successfully.'))
          .catchError((error) => print('Failed to insert data: $error'));
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }else{
        AlertDialog(
          title: Text('Alert'),
          content: Text('Sudah ada yang booking jam segitu'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Pembayaran'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormKonsultasi()),
                );
              }, 
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                  
              ),
            ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Rincian Transaksi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Psikolog : ' + psikologPilihan,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jam Mulai : ' + jamMulaii,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jam Berakhir : ' + jamAkhirr,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Total Harga : ' + harga.toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    pesanPsikolog(context, "Gopay");
                  },
                  child: Text('GoPay'),
                ),
                ElevatedButton(
                  onPressed: () {
                    pesanPsikolog(context, "Visa");
                  },
                  child: Text('Visa'),
                ),
                ElevatedButton(
                  onPressed: () {
                    pesanPsikolog(context, "Mastercard");
                  },
                  child: Text('Mastercard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    pesanPsikolog(context, "Ovo");
                  },
                  child: Text('OVO'),
                ),
                ElevatedButton(
                  onPressed: () {
                    pesanPsikolog(context, "Shopeepay");
                  },
                  child: Text('ShopeePay'),
                ),
              ],
            ),
          ],
        ),

      bottomSheet: const Iklan(),

      ),
    );
  }
}

class FormKonsultasi extends StatelessWidget {
  const FormKonsultasi({super.key});
  
  SizedBox hitungJam(String jamAwal, TextEditingController text){
    int jamAkhir = int.parse(jamAwal.substring(0,2));
    jamAkhir += 1;
    text.text = jamAkhir.toString() + ".00";
    return SizedBox(height: 0,);
  }

  @override
  Widget build(BuildContext context) {
    final jamMulai = TextEditingController();
    final jamAkhir = TextEditingController();
    final masalah = TextEditingController();
    final pesanTambahan = TextEditingController();
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Form Konsultasi"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListPsikolog()),
                );
              }, 
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                  
              ),
            ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10.0),
            Text("Masukkan Jam Mulai(Format 24 Jam berakhiran .00)"),
            const SizedBox(height: 5.0,),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                color: Colors.white,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black87,
                  )
                ),
                child: TextField(
                  controller: jamMulai,
                  decoration: InputDecoration(
                    hintText: "Masukkan jam mulai disini.."),
                  onChanged: (value) {
                    if(value.length == 5){
                      hitungJam(jamMulai.text, jamAkhir);
                    }else{
                      jamAkhir.text = "";
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Text("Jam Berakhir"),
            const SizedBox(height: 5.0,),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                color: Colors.white,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black87,
                  )
                ),
                child: TextField(
                  controller: jamAkhir,
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Text("Masukkan Masalah Anda"),
            const SizedBox(height: 5.0,),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                color: Colors.white,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black87,
                  )
                ),
                child: TextField(
                  controller: masalah,
                  decoration: InputDecoration(
                    hintText: "Masukkan Masalah Anda Disini.."),
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Text("Masukkan Pesan Tambahan Anda"),
            const SizedBox(height: 5.0,),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                color: Colors.white,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black87,
                  )
                ),
                child: TextField(
                  controller: pesanTambahan,
                  decoration: InputDecoration(
                    hintText: "Masukkan Pesan Anda Disini.."),
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
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
                onPressed: () async{
                  harga = (int.parse(jamAkhir.text.substring(0,2)) - int.parse(jamMulai.text.substring(0,2))) * 100000;
                  jamMulaii = jamMulai.text;
                  jamAkhirr = jamAkhir.text;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentPage()),
                  );
                }, 
                child: Text("Submit")),
            )
          ]),
      
      bottomSheet: const Iklan()
      
      ),
    );
  }
}

class ListPsikolog extends StatelessWidget {
  const ListPsikolog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> jamList = ['09.00 - 10.00', '10.00 - 11.00', '11.00 - 12.00'];
    String jam = "";
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('List Psikolog'),
              leading: IconButton(

                padding: EdgeInsets.all(3),
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
                        child: Text('Home'),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text('Curhat Anonim'),
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
                      } else if (value == 2) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Curhat()),
                        );
                      } else if(value == 3){
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

        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("listPsikolog").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return Text("No data available");
            }
            return Column(
              children: [
                ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    String namaPsikolog = data['Nama'];
                    String deskripsi = data['Deskripsi'];
    
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person,
                            size: 100,
                          ),
                          SizedBox(height: 10),
                          Text(
                            namaPsikolog,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(deskripsi),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: (){
                              psikologPilihan = namaPsikolog;
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FormKonsultasi()),
                              );
                                      }, 
                            child: Text("Pesan")),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 55),
              ],
            );
          },
          
        

        ),
    
      bottomSheet: const Iklan()
    
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
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 370,
                            ),
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
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          heightFactor: 0.5,
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black87,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "IKLAN",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 50,
                        ),
                      ],

                    );
                  } else {
                    return const Text(' ');
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
                      padding: const EdgeInsets.all(5),
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
                          fontWeight: FontWeight.bold,
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


