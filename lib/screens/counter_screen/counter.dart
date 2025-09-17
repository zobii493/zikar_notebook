import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/provider/counter_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../widgets/top_snack_bar.dart';
import '../../widgets/top_curve_shade.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  void _showEditDialog(BuildContext context) {
    final provider = Provider.of<CounterProvider>(context, listen: false);
    final TextEditingController controller =
    TextEditingController(text: provider.maxValue.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Target Value'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Target Value',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final int newValue = int.tryParse(controller.text) ?? provider.maxValue;
                if (newValue > 0) {
                  provider.updateMaxValue(newValue);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  _showErrorDialog(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid Value'),
        content: const Text('Target must be greater than 0'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  double getProportionateScreenWidth(double inputWidth) {
    // Assuming 375 is the width of the design screen
    double screenWidth = MediaQuery.of(context).size.width;
    return (inputWidth / 375.0) * screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CounterProvider>(context);
    double percent = provider.maxValue > 0
        ? provider.counter / provider.maxValue
        : 0;
    // double percent = _maxValue > 0 ? _counter / _maxValue : 0;
    return Scaffold(
      body: Stack(
        children: [
          // Full-width curved gradient background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            // Adjust height as needed
            child: ClipPath(
              clipper: FullWidthWavyTopRightClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Row for Goal Progress and Edit Button
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Goal Progress',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed:()=> _showEditDialog(context),
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                                side: const BorderSide(
                                    width: 1, color: Colors.white54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text('Edit',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      // Circular Percent Indicator with LayoutBuilder
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double radius = constraints.maxWidth *
                              0.4; // Use 40% of the width
                          return Align(
                            alignment: Alignment.topCenter,
                            heightFactor: 0.7,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.purpleAccent
                                  ], // White to Blue gradient
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds);
                              },
                              child: CircularPercentIndicator(
                                radius: radius,
                                lineWidth: 15,
                                animation: false,
                                restartAnimation: false,
                                arcType: ArcType.HALF,
                                percent: percent.clamp(0, 1),
                                arcBackgroundColor:
                                    Colors.grey.withOpacity(0.3),
                                startAngle: 180,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.white,
                                header: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(provider.maxValue.toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Current'),
                                    Text(
                                      '${provider.counter}',
                                      style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: provider.incrementCounter,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(colors: [
                            Colors.blueAccent,
                            Colors.purpleAccent
                          ]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.transparent,
                              child: FaIcon(FontAwesomeIcons.solidHandPointer,
                                  size: 100, color: Colors.grey.shade300),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Confirm Reset'),
                                        content: const Text('Do you want to reset the counter?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              provider.resetCounter(); // provider method call
                                              Navigator.pop(ctx);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                    textStyle: const TextStyle(fontSize: 20),
                                    backgroundColor: Colors.amber.shade300,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text('Reset'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    bool success = await provider.saveData();
                                    final overlay = Overlay.of(context);
                                    final overlayEntry = OverlayEntry(
                                      builder: (context) => Positioned(
                                        top: MediaQuery.of(context)
                                            .padding
                                            .top, // Position at the top
                                        left: 8,
                                        right: 8,
                                        child: TopSnackBar(
                                          message: success
                                              ? 'Record saved successfully!'
                                              : 'Failed to save record.',
                                          backgroundColor: success
                                              ? Colors.amber.shade300
                                              : Colors.red,
                                        ),
                                      ),
                                    );

                                    // Insert the overlay entry
                                    overlay.insert(overlayEntry);

                                    // Remove the overlay entry after 3 seconds
                                    await Future.delayed(
                                        const Duration(seconds: 3));
                                    overlayEntry.remove();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    textStyle: const TextStyle(fontSize: 20),
                                    backgroundColor: Colors.white,
                                    // Background color
                                    foregroundColor:
                                        Colors.black, // Text color
                                  ),
                                  child: const Text('Save',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}