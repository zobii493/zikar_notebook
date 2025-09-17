import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Helps & Supports',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'AutourOne',
          ),
        ),
        backgroundColor: Colors.black,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Troubleshooting Common Issues',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. App Crashes: Try restarting the app. If the problem persists, check for updates to ensure you have the latest version.',
              ),
              SizedBox(height: 16),
              Text(
                '2. Button Not Responding: Ensure your device’s screen is clean and functional. Sometimes a screen protector can interfere with touch sensitivity.',
              ),
              SizedBox(height: 16),
              Text(
                '3. registrations_screens Issues: If you face any issues while registering, make sure you are connected to the internet and try again. Ensure that all required fields are filled in correctly.',
              ),
              SizedBox(height: 16),
              Text(
                '4. Password Reset Issues: If you are unable to reset your password, ensure you are using the correct email address and follow the instructions carefully. Contact support if the issue persists.',
              ),
              SizedBox(height: 16),
              Divider(),
              Text(
                'Updates and Announcements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Stay updated with the latest features and bug fixes by following us on social media or visiting our website. Regular updates ensure you have the best experience with NaqashBandi Shazli App.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
