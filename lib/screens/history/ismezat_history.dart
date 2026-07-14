import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ZikarHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  ZikarHistoryScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Zikar history',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'AutourOne',
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: FaIcon(
            FontAwesomeIcons.angleLeft,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          var entry = history[index];

          // Check if 'date' is a string and parse it to DateTime if necessary
          DateTime dateTime;
          if (entry['date'] is String) {
            dateTime = DateTime.parse(entry['date']);
          } else {
            dateTime = entry['date'];
          }

          // Formatting date and time
          String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
          String formattedTime = DateFormat('hh:mm a').format(dateTime);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: ListTile(
                title: Text(
                  '${entry['day']}: ${entry['zikar']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text('Date: $formattedDate\nTime: $formattedTime'),
              ),
            ),
          );
        },
      ),
    );
  }
}
