import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';
import 'package:gramboo_sales_details/features/sales_report/screens/weightReport_screen.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

// import '../../../core/global_functions.dart';
import '../../../core/global_variables.dart';
import '../../auth/controller/loginController.dart';

final weightDropValueProvider = StateProvider<String?>((ref) {
  return "Gross Weight";
});

class SalesReportScreen extends ConsumerStatefulWidget {
  const SalesReportScreen({super.key});

  @override
  ConsumerState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends ConsumerState<SalesReportScreen> {
  final _filterController = MultiSelectController();

  final touchedIndexPieProvider = StateProvider<int>((ref) {
    return -1;
  });

  final dayFilterDropValueProvider = StateProvider<String?>((ref) {
    return "Today";
  });

  @override
  void dispose() {
    super.dispose();
    _filterController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showDropDownDialog();
  }

  final branchValueProvider = StateProvider<String?>((ref) {
    final branchList = ref.read(branchListProvider);
    return branchList.isNotEmpty ? branchList[0].branchName : null;
  });

  void _showDropDownDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select an Option'),
            content: Column(
              children: [
                CustomDropDown(
                    dropList: ref
                        .read(branchListProvider)
                        .map((e) => e.branchName)
                        .toList(),
                    selectedValueProvider: branchValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(branchListProvider)
                        .map((e) => e.branchName)
                        .toList(),
                    selectedValueProvider: branchValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(branchListProvider)
                        .map((e) => e.branchName)
                        .toList(),
                    selectedValueProvider: branchValueProvider),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  bool isShowingMainData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SALES REPORT",
          style: GoogleFonts.alice(
            fontSize: w * .07,
          ),
        ),
        actions: const [
          Text("Today's RS  "),
        ],
      ),
      drawer: const Drawer(),
      body: SizedBox(
        height: h,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomDropDown(
              dropList: const ["Today", "Yesterday", "This month", 'This Week'],
              selectedValueProvider: dayFilterDropValueProvider,
            ),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: MultiSelectDropDown(
                backgroundColor: Palette.cardColor,
                hint: 'SELECT NEEDED ITEMS',
                hintStyle: GoogleFonts.alice(
                    fontWeight: FontWeight.w400, fontSize: 18),
                showClearIcon: true,
                controller: _filterController,
                onOptionSelected: (options) {},
                options: const <ValueItem>[
                  ValueItem(label: 'GOLD 18K', value: '1'),
                  ValueItem(label: 'GOLD 22K', value: '2'),
                  ValueItem(label: 'DIAMOND', value: '3'),
                  ValueItem(label: 'UNCUT', value: '4'),
                  ValueItem(label: 'OLD GOLD', value: '5'),
                  ValueItem(label: 'OLD DIAMOND', value: '6'),
                ],
                maxItems: 6,
                disabledOptions: const [
                  ValueItem(label: 'GOLD 18K', value: '1')
                ],
                selectionType: SelectionType.multi,
                chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                dropdownHeight: 300,
                optionTextStyle: const TextStyle(fontSize: 16),
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
            ),

            //weight selection card
            SizedBox(
              height: h * .2,
              width: w * .9,
              child: Card(
                elevation: 20,
                color: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "TOTAL WEIGHT",
                        style: GoogleFonts.alice(
                            fontSize: w * .08, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 7, left: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: .5,
                              ),
                            ),
                            height: h * .055,
                            child: Center(
                              child: Text(
                                "556855.099",
                                style: TextStyle(
                                    fontSize: w * .05,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: h * .06,
                            child: CustomDropDown(
                              dropList: const [
                                "Gross Weight",
                                "Stone Weight",
                                "Dia Weight",
                                'Net Weight',
                                'Total Qty',
                                'VA Percentage',
                                'VA Amount',
                                'Dia Cash'
                              ],
                              selectedValueProvider: weightDropValueProvider,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Added pie chart
            SizedBox(
              height: h * .4,
              width: w * .9,
              child: Card(
                child: Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "WEIGHT DATA",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.alice(
                                fontSize: w * .08,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isShowingMainData = !isShowingMainData;
                                });
                              },
                              icon: Icon(
                                Icons.swipe,
                                color: Colors.lightBlueAccent,
                                size: w * .12,
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: LineChart(
                            isShowingMainData ? sampleData1 : sampleData2,
                            // duration: const Duration(milliseconds: 250),
                          ),
                        )

                        // Expanded(
                        //   child: PieChart(
                        //     PieChartData(
                        //       pieTouchData: PieTouchData(
                        //         touchCallback:
                        //             (FlTouchEvent event, pieTouchResponse) {
                        //           //ONCLICK POVUM BUT TODO pass the data accordingly !
                        //           NavigationService.navigateToScreen(
                        //               context, const WeightReportScreen());
                        //
                        //           if (!event.isInterestedForInteractions ||
                        //               pieTouchResponse == null ||
                        //               pieTouchResponse.touchedSection == null) {
                        //             ref
                        //                 .read(touchedIndexPieProvider.notifier)
                        //                 .state = -1;
                        //             return;
                        //           }
                        //           ref
                        //                   .read(touchedIndexPieProvider.notifier)
                        //                   .state =
                        //               pieTouchResponse
                        //                   .touchedSection!.touchedSectionIndex;
                        //         },
                        //       ),
                        //       borderData: FlBorderData(
                        //         show: false,
                        //       ),
                        //       sectionsSpace: 2,
                        //       centerSpaceColor: Colors.white,
                        //       centerSpaceRadius: 55,
                        //       sections: showingSections(ref: ref),
                        //     ),
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1 GW';
        break;
      case 2:
        text = '2 GW';
        break;
      case 3:
        text = '3 GW';
        break;
      case 4:
        text = '5 GW';
        break;
      case 5:
        text = '6 GW';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('SEPT', style: style);
        break;
      case 7:
        text = const Text('OCT', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.blueGrey,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.pink,
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: Colors.cyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.green,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: Colors.grey,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Colors.lightBlueAccent,
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.cyanAccent,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}
