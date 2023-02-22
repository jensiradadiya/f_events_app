import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like2day/auth/model/eventmodel.dart';
import 'package:like2day/auth/services/firebase_firestore.dart';
import 'package:like2day/utils/Contants.dart';
import 'package:like2day/utils/colors.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_event.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  DateTime _focusedDay = DateTime.now(), selectDay = DateTime.now();
  DateTime? selected_day;
  DateTime? focused_Day;
  List list = [];
  bool selectedtaskIsCurrent = true, todayIsSelected = true;

  void OnDaySelected(
      DateTime selectedDay, DateTime focusedDay, BuildContext context) {
    if (!isSameDay(selected_day, selectedDay)) {
      selected_day = selectedDay;
      focused_day = focusedDay;
      focused_Day = focusedDay;
      selectDay = selected_day!;

      if (selected_day!.day == DateTime.now().day &&
          selected_day!.month == DateTime.now().month &&
          selected_day!.year == DateTime.now().year) {
        todayIsSelected = true;
      } else {
        todayIsSelected = false;
      }

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) =>  MainPage(
      //   index: 1,
      //   day: selectDay.value,
      //   hour: DateTime.now().hour,
      // ),
      //     ));
    } else {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => MainPage(
      //   index: 1,
      //   day: selected_day.value,
      //   hour: DateTime.now().hour,
      // ),
      //     ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primary,
      // body: StreamBuilder<List<EventeModel>>(
      //   // stream: userPost(month: '2'),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       log(snapshot.data![14].date.toString());
      //       return Container(
      //         child: Text("Data Mali Gayo"),
      //       );
      //     }
      //     if (snapshot.hasError) {
      //       log(snapshot.error.toString());
      //       return Container(
      //         child: Text("Error che Maro Bhai Jo Pela"),
      //       );
      //     }
      //     return Center(child: CircularProgressIndicator());
      //   },
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                int count = events.length;
                list = [];
                return count == 0
                    ? null
                    : CircleAvatar(
                        backgroundColor: primary,
                        radius: 10,
                        child: Text("${count}",
                            style: TextStyle(
                              color: Colors.black,
                            )));
              },
            ),
            // rowHeight: size.height * 0.08,
            dayHitTestBehavior: HitTestBehavior.translucent,
            onDaySelected: (selectedDay, focusedDay) {
              OnDaySelected(selectedDay, focusedDay, context);
              setState(() {});
            },
            pageJumpingEnabled: true,
            onDisabledDayTapped: null,
            selectedDayPredicate: (day) {
              return isSameDay(selected_day, day);
            },
            eventLoader: (day) {
              // if (snapshot.hasData) {
              //   for (int i = 0; i < snapshot.data!.length; i++) {
              //     if (snapshot.data![i].uid ==
              //         "${DateFormat("yyyy-MM-dd").format(day)}") {
              //       if (snapshot.data![i].taskName!.isNotEmpty &&
              //           snapshot.data![i].taskName! != "()") {
              //         list = snapshot.data![i].event!;
              //       }
              //     }
              //   }
              // }

              if (list.isNotEmpty) {
                return list;
              } else {
                return [];
              }
            },
            headerStyle: HeaderStyle(
              headerMargin: EdgeInsets.zero,
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: white,
              ),
              rightChevronIcon: Icon(Icons.chevron_right, color: white),
              formatButtonPadding:
                  EdgeInsets.symmetric(horizontal: size.width * 0.1),
              headerPadding:
                  EdgeInsets.symmetric(horizontal: size.width * 0.08),
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
                  border: Border(bottom: BorderSide(color: secondary)),
                  // borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                )),
            daysOfWeekHeight: size.height * 0.03,
            calendarStyle: CalendarStyle(
              markersAnchor: 0.5,
              tablePadding: EdgeInsets.all(10),
              cellMargin: EdgeInsets.zero,
              // outsideDaysVisible: false,
              outsideDecoration: BoxDecoration(),
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
              // tableBorder: TableBorder(
              //     borderRadius: BorderRadius.all(Radius.circular(10)),
              //     verticalInside: BorderSide(
              //         style: BorderStyle.solid,
              //         width: 2,
              //         color: darkMode ? whiteColor : calenderBorderColor),
              //     horizontalInside: BorderSide(
              //         width: 2,
              //         color: darkMode ? whiteColor : calenderBorderColor),
              //     right: BorderSide(
              //         width: 2,
              //         color: darkMode ? whiteColor : calenderBorderColor),
              //     left: BorderSide(
              //         width: 2,
              //         color: darkMode ? whiteColor : calenderBorderColor),
              //     top: BorderSide(
              //         width: 2,
              //         color: darkMode ? whiteColor : calenderBorderColor),
              //     bottom: BorderSide(
              //         width: 2,
              //         color: darkMode ? whiteColor : calenderBorderColor)),

              todayTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: todayIsSelected ? primary : white,
              ),
              todayDecoration: BoxDecoration(
                color: todayIsSelected ? white : primary,
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              selectedtaskIsCurrent = true;
                              setState(() {});
                            },
                            child: Text("On This Day",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedtaskIsCurrent
                                      ? Colors.black
                                      : Color(0xffb8b7c5),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              selectedtaskIsCurrent = false;
                              setState(() {});
                            },
                            child: Text(
                              "Upcoming",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedtaskIsCurrent
                                      ? Color(0xffb8b7c5)
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                      decoration: BoxDecoration(
                        color: Color(0xfff7f6fb),
                        // border: Border(
                        //     bottom: BorderSide(color: Colors.black, width: 2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        color: orange, shape: BoxShape.circle),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Task Title",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: black,
                                    ),
                                  ),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [

                                  //     SizedBox(
                                  //       height: 8,
                                  //     ),

                                  //   ],
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 28,
                                  ),
                                  Text(
                                    "${DateFormat.yMMMMd().format(DateTime.now())}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
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
