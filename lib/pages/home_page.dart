import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hobit/constants/habit_list.dart';
import 'package:hobit/widgets/scroll_tile.dart';
import 'package:hobit/widgets/tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int flag = 5;
  HabitList hl = HabitList();
  // Controllers
  final TextEditingController _habitNameController = TextEditingController();

  void addHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 1.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 3,
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: ListView(
                          children: [
                            Center(
                              child: const Text(
                                'Add new habit',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextField(
                              controller: _habitNameController,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter habit name',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: Colors.deepOrange,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: const Text(
                                'Set Timer',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.arrow_forward_ios),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                  MediaQuery.of(context).size.height / 6,
                                  child: ListWheelScrollView.useDelegate(
                                    onSelectedItemChanged: (value) =>
                                    flag = (value + 1) * 5,
                                    itemExtent: 60,
                                    perspective: 0.007,
                                    physics: FixedExtentScrollPhysics(),
                                    childDelegate:
                                    ListWheelChildBuilderDelegate(
                                      childCount: 12,
                                      builder: (context, index) {
                                        return MyTile(
                                          text: ((index + 1) * 5).toString(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_back_ios),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width / 10,
                                        50),
                                  ),
                                  onPressed: () {
                                    _habitNameController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width /
                                              10,
                                          50),
                                    ),
                                    onPressed: () {
                                      setState(
                                            () {
                                          if (_habitNameController.text
                                              .trim() !=
                                              '') {
                                            hl.habitList.insert(0, [
                                              _habitNameController.text.trim(),
                                              false,
                                              0,
                                              flag,
                                            ]);
                                            _habitNameController.clear();
                                            Navigator.pop(context);
                                          } else {
                                            ;
                                          }
                                        },
                                      );
                                    },
                                    child: Text('Done')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void habitStarted(int index) {
    var currentTime;
    // Note the start time
    var startTime = DateTime.now();
    int elapsedTime = hl.habitList[index][2];
    // Habit Started or stoped
    setState(
          () {
        hl.habitList[index][1] = !hl.habitList[index][1];
      },
    );
    // keep the timer going
    if (hl.habitList[index][1] == true) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (hl.habitList[index][1] == false) {
            timer.cancel();
          }

          currentTime = DateTime.now();
          hl.habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
        if (hl.habitList[index][2] >= (hl.habitList[index][3] * 60)) {
          timer.cancel();
          elapsedTime = 0;
        }
      });
    }
  }

  void deleteIndex(int index) {
    setState(
          () {
        hl.habitList.remove(hl.habitList[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0.0,
          title: Text(
            'Consistency is key',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addHabit();
          },
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.add,
            size: 32,
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: const Icon(Icons.android, size: 100, color: Colors.grey),
            ),
            ListView.builder(
              itemCount: hl.habitList.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: hl.habitList[index][0],
                  onTap: () {
                    habitStarted(index);
                  },
                  deleteTapped: () {
                    deleteIndex(index);
                  },
                  habitStarted: hl.habitList[index][1],
                  timeSpent: hl.habitList[index][2],
                  timeGoal: hl.habitList[index][3],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
