import 'package:dotted_border/dotted_border.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';

import '../../../core/global_variables.dart';

class SalesReportScreen extends ConsumerStatefulWidget {
  const SalesReportScreen({super.key});

  @override
  ConsumerState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends ConsumerState<SalesReportScreen> {
  int touchedIndex = -1;

  final dayFilterDropValueProvider = StateProvider<String?>((ref) {
    return "Today";
  });

  final weightDropValueProvider = StateProvider<String?>((ref) {
    return "StoneWt";
  });

  @override
  Widget build(BuildContext context) {
    print(ref.watch(weightDropValueProvider));
    print(ref.watch(dayFilterDropValueProvider));
    return Scaffold(
      appBar: AppBar(
        title: const Text("SALES REPORT"),
        actions: [Text("Today's RS  ")],
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              CustomDropDown(
                dropList: const ["Today", "Yesterday", "This month"],
                onChanged: (p0) {},
                selectedValueProvider: dayFilterDropValueProvider,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: w * .8,
                color: Colors.black,
              ),
              SizedBox(
                height: h * .2,
                width: w * .8,
                child: Card(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "TOTAL WEIGHT",
                          style: TextStyle(
                            fontSize: w * .09,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DottedBorder(
                              color: Palette.borderColor,
                              radius: Radius.circular(15),
                              borderType: BorderType.RRect,
                              dashPattern: [10],
                              child: Container(
                                height: h * .05,
                                width: w * .2,
                                child: Center(
                                  child: Text(
                                    "556",
                                    style: TextStyle(
                                      fontSize: w * .05,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: h * .06,
                              width: w * .25,
                              child: CustomDropDown(
                                dropList: ["GW", "StoneWt", "diaWt"],
                                onChanged: (p0) {},
                                selectedValueProvider: weightDropValueProvider,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 2,
                    centerSpaceColor: Colors.white,
                    centerSpaceRadius: 50,
                    sections: showingSections(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40 Gm',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 30,
            title: '30 St',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 15,
            title: '15 Dia',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.green,
            value: 15,
            title: '15 Net',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
