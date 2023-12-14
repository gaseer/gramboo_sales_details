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

import '../../../core/global_functions.dart';
import '../../../core/global_variables.dart';

final weightDropValueProvider = StateProvider<String?>((ref) {
  return "GW";
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
              dropList: const ["Today", "Yesterday", "This month"],
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
                color: Colors.lightBlueAccent,
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
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the radius value to your preference
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
                              dropList: const ["GW", "StoneWt", "diaWt"],
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
                              "WEIGHT SPLIT",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.alice(
                                fontSize: w * .08,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_horiz),
                            ),
                          ],
                        ),
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  //ONCLICK POVUM BUT TODO pass the data accordingly !
                                  NavigationService.navigateToScreen(
                                      context, const WeightReportScreen());

                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    ref
                                        .read(touchedIndexPieProvider.notifier)
                                        .state = -1;
                                    return;
                                  }
                                  ref
                                          .read(touchedIndexPieProvider.notifier)
                                          .state =
                                      pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 2,
                              centerSpaceColor: Colors.white,
                              centerSpaceRadius: 55,
                              sections: showingSections(ref: ref),
                            ),
                          ),
                        ),
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

  //function to display the pie chart sections !
  List<PieChartSectionData> showingSections({required WidgetRef ref}) {
    return List.generate(
      4,
      (i) {
        final isTouched = i == ref.watch(touchedIndexPieProvider);

        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Colors.blue,
              value: 40,
              title: '40 Dia ',
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
              color: Colors.cyan,
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
              title: '15 GW',
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
      },
    );
  }
}
