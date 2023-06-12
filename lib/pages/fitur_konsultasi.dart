import 'package:appsehat/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../dbservices.dart';
import '../firebase_options.dart';
import 'custom_widgets.dart';
import '../global_data.dart';
import 'home.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


String namaPsikolog = "";
String mulai = "";
String akhir = "";
String dateTime = "";
final dateTimeController = TextEditingController();

class MyDatePicker extends StatelessWidget {

  Future<DateTime?> showMyDatePicker(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2023),
    lastDate: DateTime(2100),
  );

  dateTime = picked.toString().substring(0,10);
  return picked;
}
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMyDatePicker(context);

    if (picked != null) {
      dateTimeController.text = dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Pilih Tanggal Konsultasi"),
        SizedBox(height: 5.0),
        FractionallySizedBox(
          widthFactor: 0.8,
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.black87,
                          )
                        ),
                        child: TextField(
                          controller: dateTimeController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5.0),
                            hintText: "Pilih Tanggal Konsultasi",
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            )
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 5),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            _selectDate(context);
          }
        ),



            ],
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}

class FeedbackPagePsikolog extends StatelessWidget {
  const FeedbackPagePsikolog({super.key});

  void deleteChat() async {
    final collection = FirebaseFirestore.instance.collection('chatPsikolog');
    final snapshot = await collection.where("Sender", isEqualTo: loggedIn).get();
    for(final document in snapshot.docs){
      await document.reference.delete();
    }
  }
  void deletePsikolog() async {
    final collection = FirebaseFirestore.instance.collection('listKonsultasi');
    final snapshot = await collection
    .where("User", isEqualTo: loggedIn)
    .where("Psikolog", isEqualTo: namaPsikolog)
    .where("JamMulai", isEqualTo: mulai)
    .where("JamBerakhir", isEqualTo: akhir)
    .get();
    for(final document in snapshot.docs){
      await document.reference.delete();
    }
    CollectionReference users = FirebaseFirestore.instance.collection('listHistory');
    Map<String, dynamic> data = {
      'User' : loggedIn,
      'Psikolog' : namaPsikolog,
      'Tanggal' : dateTime,
    };

    users
      .add(data)
      .then((value) => print('Data inserted successfully.'))
      .catchError((error) => print('Failed to insert data: $error'));
  }

  @override
  Widget build(BuildContext context) {
    final feedback = TextEditingController();
    deleteChat();
    deletePsikolog();
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
                  CollectionReference users = FirebaseFirestore.instance.collection('feedbackPsikolog');
                  Map<String, dynamic> data = {
                    'User' : loggedIn,
                    'Psikolog' : namaPsikolog,
                    'Feedback' : feedback.text
                  };
                  users.add(data);
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

class ChatRoomPsikolog extends StatelessWidget {
  const ChatRoomPsikolog({Key? key});

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
                stream: FirebaseFirestore.instance.collection("chatPsikolog").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String namaPengirim = data['Sender'];
                      String namaPenerima = data['Reciever'];
                      String chat = data['message'];
                      if (namaPengirim == loggedIn && namaPenerima == namaPsikolog) {
                        if(chat == loggedIn + " Sudah Selesai" || chat == namaPsikolog + " Sudah Selesai"){
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FeedbackPagePsikolog()),
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
                      } else if (namaPengirim == namaPsikolog && namaPenerima == loggedIn) {
                        if(chat == loggedIn + " Sudah Selesai" || chat == namaPsikolog + " Sudah Selesai"){
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FeedbackPagePsikolog()),
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
                        if(chat.text != ""){
                          DateTime currentTime = DateTime.now();
                          CollectionReference users = FirebaseFirestore.instance.collection('chatPsikolog');
                          DocumentReference doc = users.doc(currentTime.toString());
                    
                          Map<String, dynamic> data = {
                            'Sender' : loggedIn,
                            'Reciever' : namaPsikolog,
                            'message' : chat.text
                          };
                  
                          doc.set(data);
                          chat.text = "";
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: (){
                        DateTime currentTime = DateTime.now();
                        CollectionReference users = FirebaseFirestore.instance.collection('chatPsikolog');
                        DocumentReference doc = users.doc(currentTime.toString());
                  
                        Map<String, dynamic> data = {
                          'Sender' : loggedIn,
                          'Reciever' : namaPsikolog,
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

class HalamanHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Daftar History'),
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('listHistory').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Terjadi kesalahan');
            }
    
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String namaPsi = data['Psikolog'];
                String userNows = data['User'];
                String tanggal = data['Tanggal'];
                if (userNows == loggedIn){
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaPsi,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Tanggal: ' + tanggal),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                }else{
                  return SizedBox();
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

class HalamanKonsultasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Daftar Konsultasi'),
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('listKonsultasi').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Terjadi kesalahan');
            }
    
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String namaPsi = data['Psikolog'];
                String jamMulai = data['JamMulai'];
                String jamBerakhir = data['JamBerakhir'];
                String userNows = data['User'];
                String tanggal = data['Tanggal'];
                if (userNows == loggedIn){
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaPsi,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Tanggal: ' + tanggal),
                          SizedBox(height: 10),
                          Text('Jam Konsultasi: ' + jamMulai + ' - ' + jamBerakhir),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              namaPsikolog = namaPsi;
                              mulai = jamMulai;
                              akhir = jamBerakhir;
                              dateTime = tanggal;
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ChatRoomPsikolog()),
                              );
                            },
                            child: Text('Start Konsultasi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }else{
                  return SizedBox();
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
          'Tanggal' : dateTime,
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
                  'Tanggal : ' + dateTime,
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
            Container(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // alignment: Alignment.,
                alignment: WrapAlignment.spaceEvenly,
                // runAlignment: WrapAlignment.spaceEvenly,
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
    if (jamAkhir.toString().length == 1){
      text.text = "0" + jamAkhir.toString() + ".00";
    }else{
      text.text = jamAkhir.toString() + ".00";
    }
    return SizedBox();
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
            MyDatePicker(),
            Text("Masukkan Jam Mulai(Format 24 Jam berakhiran .00)"),
            const SizedBox(height: 5.0,),
            Container(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.black87,
                    )
                  ),
                  child: TextField(
                    controller: jamMulai,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none
                    ),
                      hintText: "Masukkan jam mulai disini.."
                    ),
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
            ),
            const SizedBox(height: 20.0,),
            Text("Jam Berakhir"),
            const SizedBox(height: 5.0,),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black87,
                  )
                ),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none
                    ),
                    hintText: "Masukkan jam selesai disini.."
                  ),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black87,
                  )
                ),
                child: TextField(
                  controller: masalah,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none
                    ),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black87,
                  )
                ),
                child: TextField(
                  controller: pesanTambahan,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none
                    ),
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("listPsikolog").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
              return Center(child: CircularProgressIndicator());
            }
            return 
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 55),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String namaPsikolog = data['Nama'];
                      String deskripsi = data['Deskripsi'];
                    
                      return FractionallySizedBox(
                        widthFactor:0.8,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color:Colors.black54)
                              ),
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
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                        ),
                      );
                    },
                  // ),
                              //   const SizedBox(height: 55),
                              // ],
                            ),
                );
          },
          
        

        ),
    
      bottomSheet: const Iklan()
    
      ),
    );
  }
}

