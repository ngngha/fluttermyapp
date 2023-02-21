import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:job_manager/presentation/widgets/app_bar_container.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);
  static const String routeName = '/attendance_sreen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String _month = DateFormat('MMMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AppBarContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'My Attendance',
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.notifications,
            color: Colors.transparent,
          ),
        ],
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _month,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        final month = await showMonthYearPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2099),
                            builder: (context, child) {
                              return Theme(
                                data: theme.copyWith(),
                                child: child!,
                              );
                            });

                        if (month != null) {
                          setState(() {
                            _month = DateFormat('MMMM yyyy').format(month);
                          });
                        }
                      },
                      child: Text(
                        "Pick a Month",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: screenHeight / 1.45,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(auth.currentUser!.uid)
                        .collection("Attend")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final snap = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: snap.length,
                          itemBuilder: (context, index) {
                            final getMonth = snap[index].id.split(' ')[1];
                            final getYear = snap[index].id.split(' ')[2];
                            final getDay = snap[index].id.split(' ')[0];
                            final getMY = '$getMonth $getYear';
                            return getMY == _month
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: 12, left: 6, right: 6),
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                            ),
                                            child: Center(
                                              child: Text('Day $getDay',
                                                  style: theme
                                                      .textTheme.bodyLarge),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("Check In",
                                                  style: theme
                                                      .textTheme.labelLarge),
                                              Text(
                                                snap[index]['checkIn'],
                                                style:
                                                    theme.textTheme.bodyLarge,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("Check Out",
                                                  style: theme
                                                      .textTheme.bodyLarge),
                                              Text(snap[index]['checkOut'],
                                                  style: theme
                                                      .textTheme.bodyLarge),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    // child: Text('Does not have data yet'),
                                    );
                          },
                        );
                      }
                      return SizedBox();
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
