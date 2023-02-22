import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:like2day/auth/model/alleventModel.dart';
import 'package:like2day/auth/model/eventmodel.dart';
import 'package:like2day/auth/servies.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

Future<void> CreateUser(
    {required String uid,
    required String email,
    String? username,
    String? profileUrl}) async {
  firebaseFirestore.collection("User").doc(uid).set({
    "email": email,
    "uid": uid,
    "username": username,
    "profileUrl": profileUrl
  });
}

Stream<List<EventeModel>> getMemories(
    {required String month, required String day}) {
  return FirebaseFirestore.instance
      .collection('Memories')
      .doc(auth.currentUser!.uid)
      .collection(month)
      .doc(auth.currentUser!.uid)
      .collection(day)
      .snapshots()
      .map(memories);
}

List<EventeModel> memories(QuerySnapshot data) {
  return data.docs.map((e) => EventeModel.fromSnapshort(e)).toList();
}

var time = DateTime.now();
// Future<void> AddEvent(
//     {required String type,
//     required String title,
//     required String discreption,
//     required DateTime date,
//     required String uid,
//     required String month,
//     required String day,
//     String? image,
//     String? index}) async {
//   print("time==$date");
//   firebaseFirestore
//       .collection('Memories')
//       .doc(uid)
//       .collection('Events')
//       .doc('${DateTime.now()}')
//       .set({
//     "type": type,
//     "title": title,
//     "discreption": discreption,
//     "date": date,
//     "image": image,
//   });
// }

addtasktofirebase(
    {String? title,
    DateTime? date,
    String? discription,
    String? image,
    String? type}) async {
  print("imageaa $image");
  var time = DateTime.now();
  await FirebaseFirestore.instance
      .collection('Memories')
      .doc(auth.currentUser!.uid)
      .collection('Events')
      .doc(time.toString())
      .set({
    'title': title,
    'description': discription,
    'date': date,
    'image': image,
    'type': type,
    'time': time.toString(),
    'timestamp': time
  });
  // Fluttertoast.showToast(msg: 'Data Added');
}

Stream<List<AllEventeModel>> allgetMemories() {
  return FirebaseFirestore.instance
      .collection('Memories')
      .doc(auth.currentUser!.uid)
      .collection('Events')
      .snapshots()
      .map(allmemories);
}

List<AllEventeModel> allmemories(QuerySnapshot data) {
  return data.docs.map((e) => AllEventeModel.fromSnapshort(e)).toList();
}
