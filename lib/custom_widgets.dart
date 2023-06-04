import 'package:appsehat/dataclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dbservices.dart';
import 'firebase_options.dart';


class Background extends StatelessWidget{
  final Widget child;
  final double opacity = 0.8;

  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:  AssetImage("assets/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromRGBO(225, 245, 254, opacity), Color.fromRGBO(21, 101, 192, opacity)],
          ),
        ),
        child: child
      ),
    );
  }
}

class BackgroundMain extends StatelessWidget{
  final Widget child;
  final double opacity = 0.5;

  const BackgroundMain({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:  AssetImage("assets/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color.fromRGBO(144, 202, 249, opacity), Color.fromRGBO(21, 101, 192, opacity)],
          ),
        ),
        child: child
      ),
    );
  }
}

class Iklan extends StatelessWidget{
  const Iklan({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        height: 50,
        child: const Text(
          "IKLAN", 
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
  }
}

class CustomFABLoc extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width * 0.5, ///customize here
      scaffoldGeometry.scaffoldSize.height - 55
    );
  }
}