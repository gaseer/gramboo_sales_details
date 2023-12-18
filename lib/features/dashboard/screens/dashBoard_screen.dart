import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/core/navigation_services.dart';
import 'package:gramboo_sales_details/features/sales_report/screens/salesReport_screen.dart';

import '../../../core/global_variables.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({super.key});

  @override
  ConsumerState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DASHBOARD"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: h * .25,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wallet,
                            size: w * .1,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "552 GM",
                            style: GoogleFonts.poppins(
                              fontSize: w * .06,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "TOTAL WIEGHT",
                            style: GoogleFonts.poppins(
                              fontSize: w * .03,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: h * .25,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Today",
                                style: TextStyle(fontSize: w * .045),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    "1/8",
                                    style: TextStyle(
                                      fontSize: w * .08,
                                    ),
                                  ),
                                ),
                                PieChart(
                                  PieChartData(
                                    borderData: FlBorderData(
                                        border: Border.all(color: Colors.black),
                                        show: true),
                                    sections: showingSections(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "TOP SALES",
                            style: GoogleFonts.poppins(
                              fontSize: w * .04,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => NavigationService.navigateToScreen(
                          context, const SalesReportScreen()),
                      child: customCard(
                        title: "SALES REPORT",
                        icon: Icons.monetization_on_outlined,
                      ),
                    ),
                    GestureDetector(
                      child: customCard(
                        title: "OLD GOLD PURCHASE",
                        icon: Icons.monetization_on_outlined,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: customCard(
                        title: "BALANCE HISTORY",
                        icon: Icons.monetization_on_outlined,
                      ),
                    ),
                    GestureDetector(
                      child: customCard(
                        title: "ALL DATA",
                        icon: Icons.monetization_on_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //Custom card

  SizedBox customCard({required String title, required IconData icon}) {
    return SizedBox(
      height: h * .27,
      width: w * .47,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: w * .1,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.alice(
                  fontSize: w * .05, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  //chart sections

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        const fontSize = 16.0;
        const radius = 15.0;
        const shadows = [
          Shadow(color: Colors.black, blurRadius: 2),
        ];
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Colors.blue,
              radius: radius,
            );
          case 1:
            return PieChartSectionData(
              color: Colors.cyan,
              radius: radius,
            );

          default:
            throw Error();
        }
      },
    );
  }
}
