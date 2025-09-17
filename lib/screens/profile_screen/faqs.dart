import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FAQsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'FAQs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildFAQItem('How do I register for an account?',
              'To register for an account, open the app and navigate to the registration page. Enter your details including name, email, and password, then submit the form to create your account.'),
          _buildFAQItem('I forgot my password. How can I reset it?',
              'If you forget your password, go to the login page and click on the "Forgot Password" link. Follow the instructions to reset your password using your registered email address.'),
          _buildFAQItem('Can I update my registration details?',
              'Yes, you can update your registration details by accessing the profile settings in the app. Here, you can modify your personal information and email address.'),
          _buildFAQItem('What is the CounterApp?',
              'The CounterApp is a simple and easy-to-use application that allows users to count daily zikar. It features a counter that can be incremented, reset, and optionally saved for future reference.'),
          _buildFAQItem('How do I increment the counter?',
              'To increment the counter, simply tap the large "👆" button in the center of the screen. Each tap will increase the counter by one.'),
          _buildFAQItem('Can I reset the counter to zero?',
              'Yes, you can reset the counter to zero by pressing the "Reset" button below the counter display. A confirmation dialog will appear to ensure you want to reset the count.'),
          _buildFAQItem('What does the "Save" button do?',
              'The "Save" button is currently reserved for future functionality. In upcoming updates, this button may be used to save the counter value to local storage or a database.'),
          _buildFAQItem(
            'How do I set a target value?',
            'Click on the "Edit" button in the "Goal Progress" section to enter a new target value.',
          ),
          _buildFAQItem(
            'Can I reset the counter?',
            'Yes, simply press the "Reset" button to reset the counter to zero.',
          ),
          _buildFAQItem(
            'What happens if I exceed the target value?',
            'The counter will stop incrementing once it reaches the target value you have set.',
          ),
          _buildFAQItem(
              'How do I navigate to different pages like Home or Profile?',
              'You can navigate to different pages using the bottom navigation bar. Simply tap on "Home," "Counter," or "Profile" to switch between the pages.'),
          _buildFAQItem('What can I do on the Home Page?',
              'The Home Page allows you to view and interact with a PDF book. You can read the book directly within the app. Additionally, you can see information cards, including "Fayzunoor," which contain checkboxes and wazaif.'),
          _buildFAQItem('How do I read the PDF book on the Home Page?',
              'You can read the PDF book directly within the app. Navigate to the Home Page and locate the PDF viewer. Tap on the PDF to open it and scroll through the pages as needed.'),
          _buildFAQItem('What features are available on the Profile Page?',
              'On the Profile Page, you can view and update your profile information, including your name and email. You can also upload and change your profile picture, view a date timeline, and access various settings and options such as notifications and help & support.'),
          _buildFAQItem('How do I update my profile picture?',
              'To update your profile picture, tap on the profile picture area on the Profile Page. You can choose to select an image from your gallery or take a new photo. The selected image will be updated as your profile picture.'),
          _buildFAQItem('How can I manage notifications on the Profile Page?',
              'In the Profile Page, you can access notification settings by tapping on the "Notification" option. Here, you can customize which notifications you receive and adjust your preferences.'),
          _buildFAQItem('Can I receive daily notifications for Zikar?',
              'Yes, you will receive daily notifications to remind you to enter your Zikar. This helps you stay consistent with your daily practice.'),
          _buildFAQItem('How is my daily Zikar stored?',
              'Your daily Zikar entries are stored in Firebase. This allows you to keep a record of your daily activities and track your spiritual progress.'),
          _buildFAQItem('Can I view my past Zikar entries?',
              'You can view your past Zikar entries by navigating to the appropriate section on the Kalma Sharif page. This helps you review your past entries and track your progress over time.'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      // showTrailingIcon: false,
      trailing: FaIcon(FontAwesomeIcons.chevronDown,size: 16,),
      title: Text(
        question,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
