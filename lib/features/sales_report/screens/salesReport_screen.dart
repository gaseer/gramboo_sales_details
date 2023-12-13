import 'package:dotted_border/dotted_border.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../core/global_variables.dart';

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

  final weightDropValueProvider = StateProvider<String?>((ref) {
    return "StoneWt";
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
        title: const Text("SALES REPORT"),
        actions: const [
          Text("Today's RS  "),
        ],
      ),
      drawer: const Drawer(),
      body: Container(
        height: h,
        width: w,
        child: Column(
          children: [
            CustomDropDown(
              dropList: const ["Today", "Yesterday", "This month"],
              selectedValueProvider: dayFilterDropValueProvider,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: h * .07,
              width: w * .9,
              child: Card(
                child: MultiSelectDropDown(
                  backgroundColor: Palette.cardColor,
                  showClearIcon: true,
                  controller: _filterController,
                  onOptionSelected: (options) {},
                  options: const <ValueItem>[
                    ValueItem(label: 'Option 1', value: '1'),
                    ValueItem(label: 'Option 2', value: '2'),
                    ValueItem(label: 'Option 3', value: '3'),
                    ValueItem(label: 'Option 4', value: '4'),
                    ValueItem(label: 'Option 5', value: '5'),
                    ValueItem(label: 'Option 6', value: '6'),
                  ],
                  maxItems: 2,
                  disabledOptions: const [
                    ValueItem(label: 'Option 1', value: '1')
                  ],
                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
              ),
            ),

            //weight selection card

            SizedBox(
              height: h * .2,
              width: w * .9,
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
                      const SizedBox(
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
                              dropList: const ["GW", "StoneWt", "diaWt"],
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
                              style: TextStyle(
                                fontSize: w * .09,
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
                              centerSpaceRadius: 50,
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
