import 'dart:async';
// import 'dart:ffi';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

late TabController tb;
int hour = 0;
int min = 0;
int sec = 0;
bool started = true;
bool stopped = true;
int timeForTimer = 0;
String timetodisplay = '';
bool checktimer = true;
bool startispressed = true;
bool stopispressed = true;
bool resetispressed = true;
int sseconds = 0;
int sminutes = 0;
int shours = 0;
bool sstarted = false;
List laps = [];
String digitSeconds = "00", digitMinutes = "00", digitHours = "00";

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  Timer? stimer;
  void sstop() {
    stimer!.cancel();
    setState(() {
      sstarted = false;
    });
  }

  void sreset() {
    setState(() {
      sseconds = 0;
      sminutes = 0;
      shours = 0;
      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";
      sstarted = false;
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  void sstart() {
    sstarted = true;
    stimer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = sseconds + 1;
      int localMinutes = sminutes;
      int localHours = shours;
      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        sseconds = localSeconds;
        sminutes = localMinutes;
        shours = localHours;
        digitSeconds = (sseconds >= 10) ? "$sseconds" : "0$sseconds";
        digitMinutes = (sminutes >= 10) ? "$sminutes" : "0$sminutes";
        digitHours = (shours >= 10) ? "$shours" : "0$shours";
      });
    });
  }

  @override
  void initState() {
    tb = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  void start() {
    setState(() {
      started = false;
      stopped = false;
    });
    timeForTimer = ((hour * 60 * 60) + (min * 60) + sec);
    debugPrint(timeForTimer.toString());
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeForTimer < 1 || checktimer == false) {
          t.cancel();
          checktimer = true;
          timetodisplay = '';
          started = true;
          stopped = true;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Homepage()));
        } else if (timeForTimer < 60) {
          timetodisplay = timeForTimer.toString();
          timeForTimer = timeForTimer - 1;
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timetodisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timetodisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        }
      });
    });
  }

  void stop() {
    setState(() {
      started = true;
      stopped = true;
      checktimer = false;
    });
  }

  Widget timer() {
    return Center(
      child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(45.0),
                      child: Center(
                        child: Row(children: [
                          Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text("HH",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700))),
                                  NumberPicker(
                                    value: hour,
                                    minValue: 0,
                                    maxValue: 23,
                                    onChanged: (val) {
                                      setState(() {
                                        hour = val;
                                      });
                                    },
                                  )
                                ]),
                          ),
                          Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text("MM",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700))),
                                  NumberPicker(
                                    value: min,
                                    minValue: 0,
                                    maxValue: 23,
                                    onChanged: (val) {
                                      setState(() {
                                        min = val;
                                      });
                                    },
                                  )
                                ]),
                          ),
                          Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text("SS",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700))),
                                  NumberPicker(
                                    value: sec,
                                    minValue: 0,
                                    maxValue: 23,
                                    onChanged: (val) {
                                      setState(() {
                                        sec = val;
                                      });
                                    },
                                  )
                                ]),
                          )
                        ]),
                      ),
                    ),
                    flex: 6,
                  ),
                  Expanded(
                      child: Text(timetodisplay,
                          style: TextStyle(
                              fontSize: 35.0, fontWeight: FontWeight.w600)),
                      flex: 1),
                  Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                              onPressed: started ? start : null,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 30.0,
                              ),
                              color: Colors.green,
                              child: Text("Start",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  )),
                              shape: CircleBorder()
                              // RoundedRectangleBorder(
                              // borderRadius: BorderRadius.circular(1000.0))
                              ),
                          RaisedButton(
                              onPressed: stopped ? null : stop,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 30.0,
                              ),
                              color: Colors.red,
                              child: Text("Stop",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  )),
                              shape: CircleBorder()),
                        ],
                      )),
                ]),
          )),
    );
  }

  Widget stopwatch() {
    return Container(
        child: Column(children: [
      Container(
          height: 718,
          width: 600,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Text("${digitHours}:${digitMinutes}:${digitSeconds}",
                    style: TextStyle(fontSize: 40.0, color: Colors.blue)),
              ),
              Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        width: 100,
                        child: Column(children: [
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () {
                                  (!sstarted) ? sstart() : sstop();
                                },
                                child: Center(
                                  child: Text(((!sstarted) ? "Start" : "Stop"),
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white)),
                                ),
                              ),
                            ],
                          )
                        ])),
                    // Container(
                    //     height: 65,
                    //     width: 100,
                    //     color: Colors.red,
                    //     child: Column(children: [
                    //       ButtonBar(
                    //         alignment: MainAxisAlignment.spaceAround,
                    //         children: <Widget>[
                    //           RaisedButton(
                    //             color: Colors.red,
                    //             onPressed: () {
                    //               stopispressed ? null : stopit();
                    //             },
                    //             child: Center(
                    //               child: const Text("STOP",
                    //                   style: TextStyle(
                    //                       fontSize: 20.0, color: Colors.white)),
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     ])),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        height: 65,
                        width: 100,
                        child: Column(children: [
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  sreset();
                                },
                                child: Center(
                                  child: const Text("Reset",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                ),
                              ),
                            ],
                          )
                        ])),
                  ]))
            ],
          ))
    ]));
  }

  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 60, 170, 221),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(132, 0, 0, 0),
          title: Text('Stopwatch & Timer'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [Tab(text: 'Timer'), Tab(text: 'Stopwatch')],
            controller: tb,
          ),
        ),
        body: TabBarView(
          children: [
            timer(),
            // Center(
            //     child: Text('Timer',
            //         style: TextStyle(fontSize: 20.0, color: Colors.white))),
            Center(
              child: stopwatch(),
            )
          ],
          controller: tb,
        ),
      ));
}
