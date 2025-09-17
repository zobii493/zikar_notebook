import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/screens/home_screen/FezuNoor.dart';
import 'package:naqashbandi_shazli/widgets/CustomCard.dart';
import 'package:provider/provider.dart';
import '../../pdfview/fayzunnoor_pdf.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../provider/progressbar_provider.dart';
import 'BookCard.dart';
import 'ismezat.dart';
import 'kalmashareef.dart';

class MyFrontPage extends StatefulWidget {
  MyFrontPage({super.key});

  @override
  State<MyFrontPage> createState() => _MyFrontPageState();
}

class _MyFrontPageState extends State<MyFrontPage> {

  final PageController _pageController = PageController(initialPage: 0);
  double progressPercentage = 0.0;
  double completedIsmeZatPercentage = 0;
  double completedkalmaSharifPercentage = 0;

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);

    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, bottom: 8, top: 16),
                  child: Text(
                    'Zikar NoteBook',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'AutourOne',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _pageController,
                  children: const[
                    BookCard(
                      title: 'فیوض النور',
                      pdfPath: 'assets/fayzunnoor.pdf',
                      pdfTitle: 'فیوض النور',
                      backgroundImage: 'assets/img2.jpeg',
                    ),
                    BookCard(
                      title: 'حزب البحر',
                      pdfPath: 'assets/hizbulbahar.pdf',
                      pdfTitle: 'حزب البحر',
                      backgroundImage: 'assets/img1.jpeg',
                    ),
                  ],
                ),
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: 2,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  dotColor: Colors.black,
                  activeDotColor: Colors.amber.shade300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomProgressCard(
                      title: 'شازلی ازکار',
                      icon: FontAwesomeIcons.bookOpenReader,
                      iconColor: Colors.pink.shade300,
                      gradientColors: [
                        Colors.pinkAccent.shade100,
                        Colors.pinkAccent.shade100,
                        Colors.pinkAccent.shade200,
                        Colors.pinkAccent.shade200,
                      ],
                      shadowColor: Colors.pinkAccent,
                      progressPercentage: progressProvider.fezuNoorProgress,
                      onTap: () async {
                        double updateProgress = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const FezuNoor()));
                        setState(() {
                          progressPercentage = updateProgress;
                        });
                      },
                      backgroundcolor:  Colors.pink.shade700,
                    ),
                    Card(
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(42)),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Fayzunoorpdf(
                                path: 'assets/Manzilpdf.pdf',
                                title: 'منزل',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 170,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(42),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.orangeAccent,
                                offset: Offset(0, 20),
                                blurRadius: 30,
                                spreadRadius: -5,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.orangeAccent.shade100,
                                Colors.orangeAccent.shade100,
                                Colors.orangeAccent.shade200,
                                Colors.orangeAccent.shade200,
                              ],
                              stops: const [0.1, 0.3, 0.9, 1.0],
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20.0, left: 10),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: FaIcon(
                                    FontAwesomeIcons.bookOpenReader,
                                    color: Colors.orangeAccent,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  'منزل',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.bullseye,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  Text(
                                    '---------------',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.bullseye,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomProgressCard(
                      title: 'اسم ذات الله',
                      icon: FontAwesomeIcons.listCheck,
                      iconColor: Colors.purple.shade800,
                      gradientColors: [
                        Colors.purpleAccent.shade100,
                        Colors.purpleAccent.shade100,
                        Colors.purpleAccent.shade200,
                        Colors.purpleAccent.shade200,
                      ],
                      shadowColor: Colors.purpleAccent,
                      progressPercentage: progressProvider.ismeZatProgress,
                      onTap: () async {
                        final result = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) => NoteBook()));
                        if (result is double) {
                          setState(() {
                            completedIsmeZatPercentage = result;
                          });
                        }
                      },
                      backgroundcolor: Colors.purple.shade800,
                    ),
                    CustomProgressCard(
                      title: 'لَا إِلٰهَ إِلَّا اللهُ',
                      icon: FontAwesomeIcons.listCheck,
                      iconColor: Colors.blue.shade800,
                      gradientColors: [
                        Colors.blueAccent.shade100,
                        Colors.blueAccent.shade100,
                        Colors.blueAccent.shade200,
                        Colors.blueAccent.shade200,
                      ],
                      shadowColor: Colors.blueAccent,
                      progressPercentage: progressProvider.kalmaSharifProgress,
                      onTap: () async {
                        final result = await Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const Kalmashareef()));
                        if (result is double) {
                          setState(() {
                            completedkalmaSharifPercentage = result;
                          });
                        }
                      },
                      backgroundcolor: Colors.blue.shade800,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}