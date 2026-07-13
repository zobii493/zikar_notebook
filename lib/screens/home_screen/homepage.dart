import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/screens/home_screen/FezuNoor.dart';
import 'package:naqashbandi_shazli/widgets/CustomCard.dart';
import 'package:naqashbandi_shazli/widgets/top_curve_shade.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
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

  final PageController _pageController = PageController(initialPage: 0,viewportFraction: 0.98);
  double progressPercentage = 0.0;
  double completedIsmeZatPercentage = 0;
  double completedkalmaSharifPercentage = 0;

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 315,
            child: Stack(
              clipBehavior: .none,
              children:
              [
                ClipRRect(
                child: Container(
                  width: double.infinity,
                  height: 150,
                  padding: EdgeInsets.only(
                    // top: MediaQuery.of(context).padding.top + 20,
                    left: 20,
                    right: 20,
                    // bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.emeraldDeepColor,
                        AppColors.emeraldColor,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CrosshatchPainter(),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ASSALAMU ALAIKUM",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'PlusJakartaSans'
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Zohaib Hassan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "PlusJakartaSans",
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white24,
                            ),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _pageController,
                  children: const[
                    BookCard(
                      title: 'فیوض النور',
                      pdfPath: 'assets/fayzunnoor.pdf',
                      pdfTitle: 'فیوض النور',
                      backgroundImage: 'assets/bookcard2.png',
                    ),
                    BookCard(
                      title: 'منزل',
                      pdfPath: 'assets/Manzilpdf.pdf',
                      pdfTitle: 'منزل',
                      backgroundImage: 'assets/bookcard1.jfif',
                    ),
                    BookCard(
                      title: 'حزب البحر',
                      pdfPath: 'assets/hizbulbahar.pdf',
                      pdfTitle: 'حزب البحر',
                      backgroundImage: 'assets/bookcard.jfif',
                    ),
                  ],
                ),
              ),
            ),
            ],
            ),
          ),
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                dotColor: AppColors.emeraldDeepColor,
                activeDotColor: AppColors.antiqueGoldColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0, top: 4.0),
            child: Text('YOUR PRACTICES',style: const TextStyle(
              color: AppColors.emeraldDeepColor,
              fontSize: 12,
              fontFamily: 'PlusJakartaSans'
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: [
                CustomProgressCard(
                  title: 'شازلی ازکار',
                  svgAsset: "assets/icons/list.svg",
                  iconBackColor: Colors.pink.shade50,
                  progressPercentage: progressProvider.fezuNoorProgress,
                  onTap: () async {
                    double updateProgress = await Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const FezuNoor()));
                    setState(() {
                      progressPercentage = updateProgress;
                    });
                  },
                  backgroundcolor: Colors.pink.shade700,
                ),
                CustomProgressCard(
                  title: 'اَسْمَاءُ الْحُسْنٰی',
                  svgAsset: "assets/icons/book.svg",
                  iconBackColor: AppColors.antiqueGoldColor.withValues(alpha: 0.2),
                  progressPercentage: progressProvider.fezuNoorProgress,
                  onTap: () async {
                    double updateProgress = await Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const FezuNoor()));
                    setState(() {
                      progressPercentage = updateProgress;
                    });
                  },
                  backgroundcolor: AppColors.antiqueGoldColor,
                ),
                CustomProgressCard(
                  title: 'اسم ذات الله',
                  icon: FontAwesomeIcons.handPointUp,
                  iconColor: Colors.purple.shade800,
                  iconBackColor: Colors.purple.shade50,
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
                  title: 'لَا إِلٰهَ إِلَّا اللهُ',
                  icon: FontAwesomeIcons.kaaba,
                  iconColor: Colors.blue.shade800,
                  iconBackColor: Colors.blue.shade50,
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
    );
  }
}