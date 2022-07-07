import 'package:flutter/material.dart';
import 'package:hobit/main.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback deleteTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTile({
    Key? key,
    required this.habitName,
    required this.onTap,
    required this.deleteTapped,
    required this.timeSpent,
    required this.timeGoal,
    required this.habitStarted,
  }) : super(key: key);

  // Convert Second into minute and second => eg. 65 sec = 1:05
  String covertSecToMin(int second) {
    String sec = (second % 60).toString();
    if (sec.length == 1) sec = '0' + sec;
    String min = (second / 60).toStringAsFixed(5);
    if (min[1] == '.') min = min.substring(0, 1);
    String mid = " : ";
    return min + mid + sec;
  }

  // Calculate progress
  double percentCompleted() {
    return timeSpent / (timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 30.0,
                          percent:
                          percentCompleted() > 1 ? 1.0 : percentCompleted(),
                          progressColor: percentCompleted() > 0.5
                              ? (percentCompleted() > 0.75
                              ? Colors.green
                              : Colors.deepOrange)
                              : Colors.red,
                        ),
                        Icon(
                          habitStarted
                              ? (percentCompleted() >= 1
                              ? Icons.done
                              : Icons.pause)
                              : Icons.play_arrow,
                          size: 28,
                          color: percentCompleted() > 0.5
                              ? (percentCompleted() > 0.75
                              ? Colors.green
                              : Colors.deepOrange)
                              : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      percentCompleted() >= 1
                          ? 'Completed'
                          : covertSecToMin(timeSpent) +
                          ' / ' +
                          timeGoal.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: percentCompleted() >= 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: percentCompleted() >= 1
                            ? Colors.green
                            : Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: deleteTapped,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red,
                      width: 3.0,
                    )),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
