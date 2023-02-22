import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';



class EventeModel {
  String? type;
  String? title;
  String? discreption;
  DateTime date = DateTime.now();
  String? uid;
  String? month;
  String? day;
  String? image;
  String? reminder;

  EventeModel.fromSnapshort(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map;
    log(data.toString());
    Timestamp time = data['date'];
    type = data['type'];
    title = data['title'];
    discreption = data['discreption'];
    date = time.toDate();
    uid = data['uid'];
    month = data['month'];
    day = data['day'];
    image = data['image'];
    reminder = data['reminder'];
  }
}
