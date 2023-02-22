import 'dart:developer';
// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:like2day/auth/services/firebase_firestore.dart';
import 'package:like2day/auth/servies.dart';
import 'package:like2day/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:like2day/utils/images.dart';

import '../utils/colors.dart';

class AllEventePage extends StatefulWidget {
  const AllEventePage({super.key});

  @override
  State<AllEventePage> createState() => _AllEventePageState();
}

class _AllEventePageState extends State<AllEventePage> {
  DateTime now = DateTime.now();
  DateFormat DateFormate = DateFormat('dd/MM/yyyy');
  DateFormat DayFormate = DateFormat('EEEE');
  String? Date;
  String? Day;
  bool chekevent = false;
  var data;
  List datelist = [];

  datecalculataion() {
    print("fgeg ${Jiffy().fromNow()}");
    print("fgeg ${Jiffy(DateTime(2023, 1, 25)).fromNow()}");
  }

  @override
  void initState() {
    DateTime dt2 = DateTime.parse("2018-09-12 10:57:00");

    // TODO: implement initState
    datecalculataion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: backGround,
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Memories')
                    .doc(auth.currentUser!.uid)
                    .collection('Events')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final docs = snapshot.data!.docs;
                    print("snapshort data  ${snapshot.data!.docs.length}");

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var time =(docs[index]['timestamp'] as Timestamp).toDate();
                        var date = (docs[index]['date'] as Timestamp).toDate();
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          elevation: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${docs[index]['title']}",
                                            style: TextStyle(
                                                color: grey, fontSize: 11),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          SizedBox(
                                            width: size.width * 0.65,
                                            child: Text(
                                                "${docs[index]['description']}",
                                                maxLines: 50,
                                                style: TextStyle(
                                                    color: primary,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.35 - 40,
                                      child: Text("${Jiffy("$date").fromNow()}",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 15)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.65,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date",
                                            style: TextStyle(
                                                color: grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  "${DateFormat("dd MMM").format(date)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: black,
                                                    fontSize: 15,
                                                  )),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                  "${DateFormat.jm().format(date).toLowerCase()}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: black,
                                                    fontSize: 15,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.35 - 40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Type",
                                            style: TextStyle(
                                                color: grey, fontSize: 11),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text("${docs[index]['type']}",
                                              maxLines: 50,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),

                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Container(
                            //               margin: EdgeInsets.only(left: 20),
                            //               child: Text(docs[index]['title'],
                            //                   style: TextStyle(fontSize: 20))),
                            //           Container(
                            //               margin: EdgeInsets.only(left: 20),
                            //               child: Text(docs[index]['description'],
                            //                   style: TextStyle(fontSize: 20))),
                            //           Container(
                            //               margin: EdgeInsets.only(left: 20),
                            //               child: Text(date.toString(),
                            //                   style: TextStyle(fontSize: 20))),
                            //           SizedBox(
                            //             height: 5,
                            //           ),
                            //           Container(
                            //               margin: EdgeInsets.only(left: 20),
                            //               child: Text(
                            //                   DateFormat.yMd().add_jm().format(time)))
                            //         ]),
                            //     Container(
                            //         child: IconButton(
                            //             icon: Icon(
                            //               Icons.delete,
                            //             ),
                            //             onPressed: () async {
                            //               await FirebaseFirestore.instance
                            //                   .collection('tasks')
                            //                   .doc(auth.currentUser!.uid)
                            //                   .collection('mytasks')
                            //                   .doc(docs[index]['time'])
                            //                   .delete();
                            //             }))
                            //   ],
                            // ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
