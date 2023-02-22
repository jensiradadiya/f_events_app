import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:like2day/auth/model/eventmodel.dart';
import 'package:like2day/auth/services/firebase_firestore.dart';
import 'package:like2day/auth/servies.dart';
import 'package:like2day/utils/Contants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  DateTime _focusedDay = DateTime.now(), selectDay = DateTime.now();
  DateTime selected_day = DateTime.now();
  DateTime focused_Day = DateTime.now();
  List list = [];
  bool selectedtaskIsCurrent = true, todayIsSelected = true;
  DateFormat dateFormate = DateFormat('d MMM y');
  int? memoriecount;

  void OnDaySelected(
      DateTime selectedDay, DateTime focusedDay, BuildContext context) {
    if (!isSameDay(selected_day, selectedDay)) {
      selected_day = selectedDay;
      focused_day = focusedDay;
      focused_Day = focusedDay;
      selectDay = selected_day;

      if (selected_day.day == DateTime.now().day &&
          selected_day.month == DateTime.now().month &&
          selected_day.year == DateTime.now().year) {
        todayIsSelected = true;
      } else {
        todayIsSelected = false;
      }
    } else {}
  }

  List datelist = [];
  List memorycountlist = [];
  int memoriescount = 0;
  var _dateTime = DateTime.now().subtract(const Duration(minutes: 10));

  memoriescounts(day) {
    if (datelist.any((element) =>
        element.toString().split(" ").first.substring(5, 10) ==
        day.toString().split(" ").first.substring(5, 10))) {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primary,

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Memories')
                  .doc(auth.currentUser!.uid)
                  .collection('Events')
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  var docdata = snapshot.data!.docs;
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    var time = (docdata[i]['date'] as Timestamp).toDate();
                    datelist.add(time);
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TableCalendar(
                        calendarFormat: CalendarFormat.month,
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, events) {
                            return datelist.any((element) =>
                                    element
                                        .toString()
                                        .split(" ")
                                        .first
                                        .substring(5, 10) ==
                                    day
                                        .toString()
                                        .split(" ")
                                        .first
                                        .substring(5, 10))
                                ? Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 3.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 3,
                                      ),
                                    ),
                                  )
                                : SizedBox();
                          },
                        ),
                        dayHitTestBehavior: HitTestBehavior.translucent,
                        onDaySelected: (selectedDay, focusedDay) {
                          print("dwfregr");
                          OnDaySelected(selectedDay, focusedDay, context);
                          setState(() {
                            memorycountlist.clear();
                            memoriescount == 0;
                          });
                        },
                        pageJumpingEnabled: true,
                        onDisabledDayTapped: null,
                        selectedDayPredicate: (day) {
                          return isSameDay(selected_day, day);
                        },
                        headerStyle: HeaderStyle(
                          headerMargin: EdgeInsets.zero,
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: white,
                          ),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: white),
                          formatButtonPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.1),
                          headerPadding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.08),
                          titleCentered: true,
                          titleTextFormatter: (date, locale) =>
                              DateFormat.yMMM(locale).format(date),
                          titleTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                          formatButtonVisible: false,
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: secondary,
                            ),
                            // TextStyle(fontWeight: FontWeight.bold, color: fontcolor),
                            weekendStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: secondary,
                            ),
                            // dowTextFormatter: (date, locale) =>
                            //     DateFormat.E(locale).format(date)[0],
                            decoration: BoxDecoration(
                              border:
                                  Border(bottom: BorderSide(color: secondary)),
                              // borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            )),
                        daysOfWeekHeight: size.height * 0.03,
                        calendarStyle: CalendarStyle(
                          markersAnchor: 0.5,
                          tablePadding: EdgeInsets.all(10),
                          cellMargin: EdgeInsets.zero,
                          // outsideDaysVisible: false,
                          outsideTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondary,
                          ),
                          defaultTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                          weekendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                          markerSize: 3,
                          markerDecoration: BoxDecoration(),
                          markersAlignment: Alignment.bottomRight,

                          todayTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: todayIsSelected ? primary : white,
                          ),
                          todayDecoration: BoxDecoration(
                            color: todayIsSelected ? white : primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          outsideDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          selectedTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 18,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          defaultDecoration: BoxDecoration(
                            // color: backgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          weekendDecoration: BoxDecoration(
                            // color: backgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        focusedDay: focused_day,
                        firstDay: DateTime(1900, 15),
                        lastDay: DateTime.now().add(Duration(days: 365)),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text("${memoriescount} Memories Today",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: selectedtaskIsCurrent
                                          ? Colors.black
                                          : Color(0xffb8b7c5),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff7f6fb),
                                      // border: Border(
                                      //     bottom: BorderSide(color: Colors.black, width: 2)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:
                                        datelist.any((element) =>
                                                element
                                                    .toString()
                                                    .split(" ")
                                                    .first
                                                    .substring(5, 10) ==
                                                selectDay
                                                    .toString()
                                                    .split(" ")
                                                    .first
                                                    .substring(5, 10))
                                            ? ListView.builder(
                                                itemCount: docdata.length,
                                                itemBuilder: (context, index) {
                                                  if (selected_day
                                                          .toString()
                                                          .split(" ")
                                                          .first
                                                          .substring(5, 10) ==
                                                      (docdata[index]['date']
                                                              as Timestamp)
                                                          .toDate()
                                                          .toString()
                                                          .split(" ")
                                                          .first
                                                          .substring(5, 10)) {
                                                    memorycountlist.add(" ");
                                                    memoriescount =
                                                        memorycountlist.length;
                                                  }
                                                  print(
                                                      "lenght== ${docdata.length}");
                                                  var date = (docdata[index]
                                                          ['date'] as Timestamp)
                                                      .toDate();
                                                  return selected_day
                                                              .toString()
                                                              .split(" ")
                                                              .first
                                                              .substring(
                                                                  5, 10) ==
                                                          (docdata[index]
                                                                      ['date']
                                                                  as Timestamp)
                                                              .toDate()
                                                              .toString()
                                                              .split(" ")
                                                              .first
                                                              .substring(5, 10)
                                                      ? Container(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 28,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${Jiffy("$date").fromNow()}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade600),
                                                                  ),
                                                                  Spacer(),
                                                                  Container(
                                                                      width: size
                                                                              .width *
                                                                          0.22,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          color: Colors.red.withOpacity(
                                                                              0.3)),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 2.0),
                                                                        child:
                                                                            Text(
                                                                          dateFormate
                                                                              .format(date),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: primary),
                                                                        ),
                                                                      )),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                      width: size
                                                                              .width *
                                                                          0.2,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          color: primary.withOpacity(
                                                                              0.3)),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 2.0),
                                                                        child:
                                                                            Text(
                                                                          docdata[index]
                                                                              [
                                                                              'type'],
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: primary),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    flex: 9,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "${docdata[index]['title']}",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              4,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                "${docdata[index]['description']}",
                                                                                textAlign: TextAlign.start,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: docdata[index]['image'] ==
                                                                            ""
                                                                        ? false
                                                                        : true,
                                                                    child: Flexible(
                                                                        flex: 2,
                                                                        child: Column(
                                                                          children: [
                                                                            docdata[index]['image'] == ""
                                                                                ? Container(
                                                                                    height: 70,
                                                                                    width: 70,
                                                                                  )
                                                                                : Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Container(
                                                                                      height: size.height * 0.07,
                                                                                      width: size.width * 0.3,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black, image: DecorationImage(image: NetworkImage(docdata[index]['image']), fit: BoxFit.cover)),
                                                                                    ),
                                                                                  )
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider(
                                                                height: 1,
                                                                thickness: 1,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : SizedBox();
                                                },
                                              )
                                            : Container(
                                                height: 100,
                                                width: 200,
                                                child: Image(
                                                    image: AssetImage(
                                                        nodataImage)))),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AddEventePage(
      //             selected_day: selectDay,
      //           ),
      //         ));
      //   },
      //   backgroundColor: primary,
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
