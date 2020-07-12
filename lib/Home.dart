import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.reference().child("value");


  bool isLedOn = false;
  bool isLedBlink = false;
  double rangeValue = 512.0;

  void updateIsLedOn() {
    setState(() {
      isLedOn = !isLedOn;
    });
    if(isLedOn){
      setState(() {
        rangeValue = 512;
      });
      firebaseDatabase.update({
        'value' : 512
      });
    }
    else{
      setState(() {
        rangeValue = 0;
        isLedBlink = false;
      });
      firebaseDatabase.update({
        'value' : 0
      });
    }
  }

  void updateIsLedBlink() {
    setState(() {
      isLedBlink = !isLedBlink;
    });
    if(isLedBlink){
      setState(() {
        isLedOn = true;
      });
      firebaseDatabase.update({
        'value' : 1024
      });
    }
    else{
      setState(() {
        isLedOn = true;
        rangeValue = 512;

      });
      firebaseDatabase.update({
        'value' : 512
      });
    }
  }

  @override
  void initState() {
    firebaseDatabase.once().then((value) {
      print(value.value['value']);
      int firebaseValue =  value.value['value'];
      if(firebaseValue > 0 ){
        setState(() {
          isLedOn = true;
          rangeValue = firebaseValue.toDouble();
        });
      }
      else{
        isLedOn = false;
        rangeValue = firebaseValue.toDouble();
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    Widget controlContainer(
        {@required String name,
        @required String description,
        Function handleChangeValue,
        bool valueStateSwitch}) {
      return FittedBox(
        fit: BoxFit.cover,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20,),
                  CupertinoSwitch(
                    onChanged: (_) {
                      handleChangeValue();
                    },
                    value: valueStateSwitch,
                  )
                ],
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                media.orientation == Orientation.landscape
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/bich_light.jpg"),
                          maxRadius: 25,
                        ),
                      )
                    : Offstage(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Text(
                    "BICH'S LIGHT",
                    style: TextStyle(
                        shadows: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: firebaseDatabase.onValue,
        builder: (context,snapshot){
          if(snapshot.hasData){
            firebaseDatabase.once().then((value) {setState(() {
//              print(value.value['value'].runtimeType);
              int v = value.value['value'];
              if(v > 0){
                rangeValue = v.toDouble();
                isLedOn = true;
              }
              if(v == 0){
                rangeValue = v.toDouble();
                isLedOn = false;
              }


            });});
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                media.orientation == Orientation.portrait
                    ? Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: CircleAvatar(
                    backgroundImage:
                    AssetImage("assets/images/bich_light.jpg"),
                    maxRadius: media.size.width /3,
                  ),
                )
                    : Offstage(),
                media.orientation == Orientation.portrait
                    ? Offstage()
                    : SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(

                      child: controlContainer(
                          name: "Bật/Tắt",
                          description: "Bật tắt đèn cơ bản",
                          handleChangeValue: updateIsLedOn,
                          valueStateSwitch: isLedOn),
                    ),
                    Flexible(

                      child: controlContainer(
                          name: "Nhấp nháy",
                          description: "Nhấp nhảy 7 màu",
                          handleChangeValue: updateIsLedBlink,
                          valueStateSwitch: isLedBlink),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Điều chỉnh độ sáng",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              CupertinoSlider(
                                value: rangeValue > 1000 ? 1000 : rangeValue,
                                onChanged: (value) {
                                  int roundValue = value.round();
                                  setState(() {
                                    if(roundValue > 1){
                                      isLedOn = true;
                                      isLedBlink = false;
                                    }
                                    else{
                                      isLedOn = false;
                                    }

                                    rangeValue = value;
                                    firebaseDatabase.update({
                                      "value" : roundValue
                                    });
                                  });

                                },
                                max: 1000,
                                min: 0,
                              ),
                              Text(
                                "Trượt để điều chỉnh độ sáng đèn",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5,)
                            ],
                          )),
                    )
                  ],
                )
              ],
            ),
          );
        },
      )
    );
  }
}
