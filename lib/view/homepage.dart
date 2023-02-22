import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:like2day/utils/images.dart';
import 'package:like2day/view/CalenderView.dart';
import 'package:like2day/view/add_event.dart';
import 'package:like2day/view/all_event.dart';
import 'package:like2day/view/dashboard.dart';
import 'package:like2day/view/setting.dart';
import '../auth/services/firebase_firestore.dart';
import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pagelist = [DashBoard(), AddEventePage(), AllEventePage()];
  int selectindex = 0;
  List titlelist = ["DashBoard", "Add Event", "All Events"];

  DateTime now = DateTime.now();
  DateFormat DateFormate = DateFormat('dd/MM/yyyy');
  DateFormat DayFormate = DateFormat('EEEE');
  String? Date;
  String? Day;
  @override
  void initState() {
    super.initState();
    Date = DateFormate.format(now);
    Day = DayFormate.format(now);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: Text(titlelist[selectindex]),
          actions: <Widget>[
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      Text(" My Profile"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      Text(" Settings"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  onTap: () {
                    Future.delayed(
                        const Duration(seconds: 0),
                        () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), //this right here
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    height: size.height * 0.26,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 3)),
                                          child: Icon(
                                            Icons.question_mark_rounded,
                                            color: black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Are you sure want to Logout?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: size.height * 0.06,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                          height: size.height,
                                                          width: size.width,
                                                          decoration: BoxDecoration(
                                                              color: primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                          child: Center(
                                                              child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ))),
                                                    ),
                                                  )),
                                              Flexible(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                          height: size.height,
                                                          width: size.width,
                                                          decoration: BoxDecoration(
                                                              color: primary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                          child: Center(
                                                              child: Text(
                                                            "No",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ))),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }));
                  },
                  value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      Text(" Logout"),
                    ],
                  ),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                print("My account menu is selected.");
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                print("Logout menu is selected.");
              }
            }),
          ],
        ),
        body: pagelist[selectindex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: primary,
          currentIndex: selectindex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.view_comfy_alt_sharp), label: "Dashboard"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box), label: "Add Event"),
            BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox), label: "All Events"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.settings), label: "setting")
          ],
          onTap: (value) {
            setState(() {
              selectindex = value;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white38,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   log(index.toString());
  //   return SafeArea(
  //     child: Scaffold(
  //       drawer: Drawer(
  //         child: ListView(
  //           // Important: Remove any padding from the ListView.
  //           padding: EdgeInsets.zero,
  //           children: [
  //             DrawerHeader(
  //               decoration: BoxDecoration(
  //                 color: primary,
  //               ),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                       width: size.width,
  //                       child: Text(
  //                         'Like2Day ',
  //                         style: TextStyle(
  //                             fontSize: 30,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.bold),
  //                       )),
  //                   Image.network(
  //                     "https://play-lh.googleusercontent.com/92xIZAW-mdwucFX1v8kyTXlLVgZfLczHv8XCVOH1tFc0M3cTRI4q9qJLUM96PqCrgWjc=w240-h480-rw",
  //                     height: size.height * 0.1,
  //                   )
  //                 ],
  //               ),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   title = "DashBoard";
  //                   index = 0;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   children: [
  //                     Icon(
  //                       Icons.widgets,
  //                       color: primary,
  //                     ),
  //                     SizedBox(
  //                       width: 10,
  //                     ),
  //                     Text("Deshboard")
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Divider(),
  //             InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   title = "Add Events";
  //                   index = 1;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   children: [
  //                     Icon(
  //                       Icons.edit,
  //                       color: primary,
  //                     ),
  //                     SizedBox(
  //                       width: 10,
  //                     ),
  //                     Text("Add Event")
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Divider(),
  //             InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   index = 2;
  //                   title = "DashBoard";
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   children: [
  //                     Icon(
  //                       Icons.menu,
  //                       color: primary,
  //                     ),
  //                     SizedBox(
  //                       width: 10,
  //                     ),
  //                     Text("All Evente")
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Divider(),
  //             // InkWell(
  //             //   onTap: () {
  //             //     setState(() {
  //             //       index = 3;
  //             //       title = "CalenderView";
  //             //     });
  //             //     Navigator.pop(context);
  //             //   },
  //             //   child: Padding(
  //             //     padding: const EdgeInsets.all(8.0),
  //             //     child: Row(
  //             //       children: [
  //             //         Icon(
  //             //           Icons.calendar_month,
  //             //           color: primary,
  //             //         ),
  //             //         SizedBox(
  //             //           width: 10,
  //             //         ),
  //             //         Text("CalenderView")
  //             //       ],
  //             //     ),
  //             //   ),
  //             // ),
  //             // Divider(),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     Icons.share,
  //                     color: primary,
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text("share")
  //                 ],
  //               ),
  //             ),
  //             Divider(),
  //           ],
  //         ),
  //       ),
  //       appBar: AppBar(
  //         elevation: 0,
  //         leading: Builder(
  //           builder: (BuildContext context) {
  //             return IconButton(
  //               icon: const Icon(
  //                 Icons.menu,
  //                 color: Colors.white, // Change Custom Drawer Icon Color
  //               ),
  //               onPressed: () {
  //                 Scaffold.of(context).openDrawer();
  //               },
  //               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
  //             );
  //           },
  //         ),
  //         backgroundColor: primary,
  //         title: Text(
  //           title.toString(),
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //       body: pagelist[index],
  //     ),
  //   );
  // }
}
