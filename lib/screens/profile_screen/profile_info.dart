import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naqashbandi_shazli/screens/profile_screen/faqs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../registrations_screens/login.dart';
import '../counter_screen/counter.dart';
import 'package:path/path.dart' as path;

import '../../widgets/top_curve_shade.dart';
import 'helps_supports.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // int _selectedIndex = 2;
  final ImagePicker _picker = ImagePicker();
  bool _isExpanded = false;
  String? _profileImageUrl;
  String? _username;
  String? _email;

  Future<void> _pickerImage() async {
    await requestPermissions();
    final XFile? pickerFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      final String fileName = path.basename(pickerFile.path);

      // Initialize custom bucket instance
      final customBucket = FirebaseStorage.instanceFor(
          bucket: 'gs://shazli-notebook.appspot.com');

      // Reference to the file in the custom bucket
      final Reference storageReference =
          customBucket.ref().child('profile_pics/$fileName');
      try {
        if (_profileImageUrl != null) {
          final oldImageRef = customBucket.refFromURL(_profileImageUrl!);
          await oldImageRef.delete();
        }
        // Upload the file
        await storageReference.putFile(File(pickerFile.path));

        // Get the download URL
        String downloadURL = await storageReference.getDownloadURL();

        setState(() {
// Optional: You might use this to show a preview before saving.
          _profileImageUrl = downloadURL; // Store the download URL
        });

        // Save the download URL to Firestore
        await _saveProfileImageUrl(_profileImageUrl!);
      } catch (e) {
        print("Failed to upload image: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl();
    _fetchUserProfile();
    _loadStoredProfile();
  }
  Future<void> _loadStoredProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImageUrl = prefs.getString('profileImageUrl'); // Load username if available
      _username = prefs.getString('username'); // Load username if available
    });
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch email from FirebaseAuth
      setState(() {
        _email = user.email;
      });

      // Fetch additional user details from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _username = doc[
              'username']; // Assuming 'username' is a field in your Firestore user document
          _profileImageUrl = doc['profileImageUrl']; // Fetch profile image URL
        });
      }
    }
  }
  Future<void> _fetchProfileImageUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc['profileImageUrl'] != null) {
        setState(() {
          _profileImageUrl = doc['profileImageUrl'];
        });
      }
    }
  }


  Future<void> requestPermissions() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Storage permission is not granted');
      // Handle the case when permission is denied
    }
  }

  Future<void> _saveProfileImageUrl(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'profileImageUrl': url, // Save the download URL in Firestore
      });
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User pressed Cancel
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.green,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User pressed Logout
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // Proceed with logout
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      } catch (e) {
        print("Logout failed: $e");
        // Optionally, you can show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Full-width wavy top right corner
            Positioned(
              top: 0,
              right: 0,
              child: ClipPath(
                clipper: FullWidthWavyTopRightClipper(),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),
            // Rest of your profile content
            ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: _isExpanded ? 300 : 100,
                                width: _isExpanded ? 300 : 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                  image: _profileImageUrl != null
                                      ? DecorationImage(
                                          image:
                                              NetworkImage(_profileImageUrl!),
                                          // Use NetworkImage
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: (_profileImageUrl == null
                                    ? Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.solidUser,
                                          size: _isExpanded ? 80 : 40,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : null),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickerImage,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.camera,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                  ),
                                  // child: Icon(
                                  //   Icons.add_a_photo_outlined,
                                  // ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _username ?? 'Username',
                      style: const TextStyle(fontSize: 20, fontFamily: 'AutourOne'),
                    ),
                    Text(
                      _email ?? 'example@email.com',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: EasyDateTimeLine(
                        initialDate: DateTime.now(),
                        onDateChange: (selectedDate) {
                          // Handle date change
                        },
                        headerProps: const EasyHeaderProps(
                          showMonthPicker: false,
                          monthPickerType: MonthPickerType.switcher,
                          dateFormatter: DateFormatter.fullDateDMY(),
                        ),
                        dayProps: const EasyDayProps(
                          dayStructure: DayStructure.dayStrDayNum,
                          activeDayStyle: DayStyle(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xff3371FF),
                                  Color(0xff8426D6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FAQsPage()));
                      },
                      child: ProfileOption(
                        icon: FontAwesomeIcons.circleQuestion,
                        text: 'FAQs',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FAQsPage()));
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpSupportPage()));
                      },
                      child: ProfileOption(
                        // icon: FontAwesomeIcons.info,
                        icon: HugeIcons.strokeRoundedCustomerSupport,
                        text: 'Help & Support',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HelpSupportPage()));
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: _confirmLogout,
                      child: ProfileOption(
                        icon: FontAwesomeIcons.arrowRightFromBracket,
                        text: 'Logout',
                        onPressed: _confirmLogout,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;

  const ProfileOption({super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: Colors.black12,
        ),
        height: 60,
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              size: 24,
              color: Colors.black26,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            IconButton(
              onPressed: onPressed,
              icon: const FaIcon(
                FontAwesomeIcons.angleRight,
                size: 24,
                color: Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
