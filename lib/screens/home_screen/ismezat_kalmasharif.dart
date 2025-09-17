import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../History/ismezat_history.dart';
import '../../provider/ismezat_kalmasharif_provider.dart';

class IsmezatAndkalmaSarif extends StatefulWidget {
  final String title;
  final String subtitle;
  final String collectionName;
  final String historyCollection;

  const IsmezatAndkalmaSarif({
    super.key,
    required this.title,
    required this.subtitle,
    required this.collectionName,
    required this.historyCollection,
  });

  @override
  State<IsmezatAndkalmaSarif> createState() => _IsmezatAndkalmaSharifState();
}

class _IsmezatAndkalmaSharifState extends State<IsmezatAndkalmaSarif> {
  final TextEditingController mondayController = TextEditingController();
  final TextEditingController tuesdayController = TextEditingController();
  final TextEditingController wednesdayController = TextEditingController();
  final TextEditingController thursdayController = TextEditingController();
  final TextEditingController fridayController = TextEditingController();
  final TextEditingController saturdayController = TextEditingController();
  final TextEditingController sundayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<IsmezatProvider>(context, listen: false);
      provider.loadData(widget.collectionName, widget.historyCollection);
    });
  }

  void updateDailyZikar() {
    final provider = Provider.of<IsmezatProvider>(context, listen: false);
    final now = DateTime.now();
    final today = DateFormat('EEEE').format(now);

    if (!provider.isMondayAdded && mondayController.text.isNotEmpty) {
      provider.mondayZikar = int.parse(mondayController.text);
      provider.isMondayAdded = true;
      provider.updateDailyZikar(
        value: provider.mondayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isTuesdayAdded && tuesdayController.text.isNotEmpty) {
      provider.tuesdayZikar = int.parse(tuesdayController.text);
      provider.isTuesdayAdded = true;
      provider.updateDailyZikar(
        value: provider.tuesdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isWednesdayAdded && wednesdayController.text.isNotEmpty) {
      provider.wednesdayZikar = int.parse(wednesdayController.text);
      provider.isWednesdayAdded = true;
      provider.updateDailyZikar(
        value: provider.wednesdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isThursdayAdded && thursdayController.text.isNotEmpty) {
      provider.thursdayZikar = int.parse(thursdayController.text);
      provider.isThursdayAdded = true;
      provider.updateDailyZikar(
        value: provider.thursdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isFridayAdded && fridayController.text.isNotEmpty) {
      provider.fridayZikar = int.parse(fridayController.text);
      provider.isFridayAdded = true;
      provider.updateDailyZikar(
        value: provider.fridayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isSaturdayAdded && saturdayController.text.isNotEmpty) {
      provider.saturdayZikar = int.parse(saturdayController.text);
      provider.isSaturdayAdded = true;
      provider.updateDailyZikar(
        value: provider.saturdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isSundayAdded && sundayController.text.isNotEmpty) {
      provider.sundayZikar = int.parse(sundayController.text);
      provider.isSundayAdded = true;
      provider.updateDailyZikar(
        value: provider.sundayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }

    // Clear text fields
    mondayController.clear();
    tuesdayController.clear();
    wednesdayController.clear();
    thursdayController.clear();
    fridayController.clear();
    saturdayController.clear();
    sundayController.clear();
  }

  void resetWeek() {
    final provider = Provider.of<IsmezatProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: const Text('Do you want to reset weekly Zikar?'),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  provider.resetWeek(
                      widget.collectionName, widget.historyCollection);

                  // Clear controllers
                  mondayController.clear();
                  tuesdayController.clear();
                  wednesdayController.clear();
                  thursdayController.clear();
                  fridayController.clear();
                  saturdayController.clear();
                  sundayController.clear();
                },
                child: const Text('Reset',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IsmezatProvider>(context);
    int remainingZikar = provider.totalZikarGoal - provider.completedZikar;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'AutourOne',
            ),
          ),
        ),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, provider.completedPercentage);
            provider.loadData(widget.collectionName, widget.historyCollection);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ZikarHistoryScreen(history: provider.zikarHistory),
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.clockRotateLeft,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.subtitle,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),
                  const SizedBox(width: 7),
                  const Text('Total Zikar'),
                  const SizedBox(width: 20),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.teal),
                  ),
                  const SizedBox(width: 7),
                  const Text('Remaining Zikar'),
                ],
              ),
              const SizedBox(height: 30),
              _buildProgressBar(provider.completedZikar, Colors.blue,
                  provider.totalZikarGoal),
              Text('${provider.completedZikar}'),
              const SizedBox(height: 20),
              _buildProgressBar(
                  remainingZikar, Colors.teal, provider.totalZikarGoal),
              Text('$remainingZikar'),
              const SizedBox(height: 20),
              Column(
                children: [
                  buildDayZikarInput(
                      'Day 1', mondayController, provider.mondayZikar,
                      provider.isMondayAdded),
                  buildDayZikarInput(
                      'Day 2', tuesdayController, provider.tuesdayZikar,
                      provider.isTuesdayAdded),
                  buildDayZikarInput(
                      'Day 3', wednesdayController, provider.wednesdayZikar,
                      provider.isWednesdayAdded),
                  buildDayZikarInput(
                      'Day 4', thursdayController, provider.thursdayZikar,
                      provider.isThursdayAdded),
                  buildDayZikarInput(
                      'Day 5', fridayController, provider.fridayZikar,
                      provider.isFridayAdded),
                  buildDayZikarInput(
                      'Day 6', saturdayController, provider.saturdayZikar,
                      provider.isSaturdayAdded),
                  buildDayZikarInput(
                      'Day 7', sundayController, provider.sundayZikar,
                      provider.isSundayAdded),
                  buildTotalRow(
                      'Total Weekly Zikar    :  ', provider.weeklyTotal),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: resetWeek,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text('Reset Week',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: updateDailyZikar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const Text('Add Zikar',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildProgressBar(int value, Color color, int total) {
    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(10),
      minHeight: 20,
      value: value / total,
      backgroundColor: color.withOpacity(0.2),
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }

  Widget buildDayZikarInput(
      String label, TextEditingController controller, int zikarValue,
      bool isAdded) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              controller: controller,
              enabled: !isAdded,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                hintText: isAdded
                    ? '$label Zikar: $zikarValue'
                    : '$label',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalRow(String label, int total) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 8),
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 8),
          child: Text(
            total.toString(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
