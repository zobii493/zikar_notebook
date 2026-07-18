import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/screens/home_screen/checklist_screen.dart';
import 'package:naqashbandi_shazli/widgets/CustomCard.dart';
import 'package:naqashbandi_shazli/widgets/custom_paint.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/app_theme_colors.dart';
import '../../core/username_cache.dart';
import '../../repositories/auth_repository.dart';
import '../../viewmodel/asma_ul_husna_provider.dart';
import '../../viewmodel/fezunoor_provider.dart';
import '../../viewmodel/progressbar_provider.dart';
import 'widgets/bookcard.dart';
import 'ismezat.dart';
import 'kalmashareef.dart';

class MyFrontPage extends StatefulWidget {
  MyFrontPage({super.key});

  @override
  State<MyFrontPage> createState() => _MyFrontPageState();
}

class _MyFrontPageState extends State<MyFrontPage> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.98,
  );
  final AuthRepository _authRepository = AuthRepository();
  double progressPercentage = 0.0;
  double completedIsmeZatPercentage = 0;
  double completedkalmaSharifPercentage = 0;
  late String username = UsernameCache.value ?? "";
  late bool isLoadingUsername = UsernameCache.value == null;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final user = _authRepository.currentUser;

    if (user == null) return;

    final fetchedUsername = await _authRepository.fetchUsername(user.uid);

    if (!mounted) return;

    final resolved = fetchedUsername ?? "User";

    // Save for next time — no more "Loading..." flash on future visits.
    UsernameCache.save(resolved);

    setState(() {
      username = resolved;
      isLoadingUsername = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 315,
            child: Stack(
              clipBehavior: .none,
              children: [
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
                          colors.headerGradientStart,
                          colors.headerGradientEnd,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: CrosshatchPainter()),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ASSALAMU ALAIKUM",
                                    style: TextStyle(
                                      color: AppColors.whiteColor.withValues(
                                        alpha: 0.70,
                                      ),
                                      fontSize: 11,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'PlusJakartaSans',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    isLoadingUsername ? "Loading..." : username,
                                    style: TextStyle(
                                      color: colors.headingSecondary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "PlusJakartaSans",
                                    ),
                                  ),
                                ],
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
                      children: const [
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
                dotColor: colors.emeraldDeep,
                activeDotColor: colors.gold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
            child: Text(
              'YOUR PRACTICES',
              style: TextStyle(
                color: colors.headingPrimary,
                fontSize: 12,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  iconBackColor: colors.lightPink,
                  progressPercentage: progressProvider.fezuNoorProgress,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChecklistScreen(
                          appBarTitle: 'فیوض النور',
                          itemsLabel: 'Wazaif',
                          createProvider: () => FezuNoorProvider(),
                        ),
                      ),
                    );
                  },
                  backgroundcolor: Colors.pink.shade700,
                ),
                CustomProgressCard(
                  title: 'اَسْمَاءُ الْحُسْنٰی',
                  svgAsset: "assets/icons/book.svg",
                  iconBackColor: colors.gold.withValues(alpha: 0.2),
                  progressPercentage: progressProvider.asmaUlHusnaProgress,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChecklistScreen(
                          appBarTitle: 'اَسْمَاءُ الْحُسْنٰی',
                          itemsLabel: 'Names',
                          createProvider: () => AsmaUlHusnaProvider(),
                        ),
                      ),
                    );
                  },
                  backgroundcolor: colors.gold,
                ),
                CustomProgressCard(
                  title: 'اسم ذات الله',
                  icon: FontAwesomeIcons.handPointUp,
                  iconColor: Colors.purple.shade800,
                  iconBackColor: colors.lightPurple,
                  progressPercentage: progressProvider.ismeZatProgress,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NoteBook()),
                    );
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
                  iconBackColor: colors.lightBlue,
                  progressPercentage: progressProvider.kalmaSharifProgress,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Kalmashareef(),
                      ),
                    );
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
