import 'dart:convert';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';
import 'package:gramboo_sales_details/core/utilities/custom_snackBar.dart';
import 'package:gramboo_sales_details/core/utilities/loader.dart';
import 'package:gramboo_sales_details/features/sales_report/controller/salesController.dart';
import 'package:gramboo_sales_details/features/sales_report/screens/weightReport_screen.dart';
import 'package:gramboo_sales_details/features/sales_report/widgets/lineChartWidget.dart';
import 'package:gramboo_sales_details/models/salesSummary_model.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

// import '../../../core/global_functions.dart';
import '../../../core/error_handling/error_text.dart';
import '../../../core/global_variables.dart';
import '../../../models/metalType_model.dart';
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
  // DateTime? endDate;
  // DateTime? startDate;

  final _filterController = MultiSelectController();
  int? branchId;

  final touchedIndexPieProvider = StateProvider<int>((ref) {
    return -1;
  });

  final dayFilterDropValueProvider = StateProvider<String?>((ref) {
    return "Today";
  });

  //picked date providers
  final startDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });
  final endDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });

  //metal type

  final metalTypeValueProvider = StateProvider<String?>((ref) {
    return null;
  });

  //item list

  final itemValueProvider = StateProvider<String?>((ref) {
    return null;
  });

  //Measurement list

  final measurementValueProvider = StateProvider<String?>((ref) {
    return null;
  });

  //salesman list

  final salesmanValueProvider = StateProvider<String?>((ref) {
    return null;
  });

  //Sales type list

  final salesTypeValueProvider = StateProvider<String?>((ref) {
    return null;
  });

  //Item model

  final modelValueProvider = StateProvider<String?>((ref) {
    return null;
  });

  //category value

  final categoryValueProvider = StateProvider<String?>((ref) {
    return null;
  });

  //value to toggle the loading !
  bool _isLoading = false;

  @override
  void initState() {
    branchId = ref.read(branchListProvider)[0].branchId;

    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _loadData();
  }

  //function to fetch data to dropdown
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    await getMetalTypes();
    await getMeasurementList();
    await getItemList();
    await getSalesmanList();
    await getCategoryList();
    await getItemModelList();
    await getSalesTypeList();
    setState(() {
      _isLoading = false;
    });
    _showDropDownDialog();
  }

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
      body: _isLoading
          ? LinearProgressIndicator()
          : SizedBox(
              height: h,
              width: w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomDropDown(
                    dropList: const [
                      "Today",
                      "Yesterday",
                      "This month",
                      'This Week'
                    ],
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
                                    selectedValueProvider:
                                        weightDropValueProvider,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        // isShowingMainData = !isShowingMainData;
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

                              Consumer(
                                builder: (context, ref, child) {
                                  print("Consumer rebuild");

                                  final startDate =
                                      ref.watch(startDateProvider);
                                  final endDate = ref.watch(endDateProvider);
                                  final itemCategory =
                                      ref.watch(categoryValueProvider);

                                  String formattedStartDate =
                                      DateFormat("dd-MMM-yyyy")
                                          .format(startDate);
                                  String formattedEndDate =
                                      DateFormat("dd-MMM-yyyy").format(endDate);
                                  Map parameterMap = {
                                    "itemCategory": itemCategory,
                                    "dateFrom": formattedStartDate,
                                    "dateTo": formattedEndDate,
                                    "branchId": branchId.toString()
                                  };

                                  return ref
                                      .watch(
                                        salesSummaryProvider(
                                          jsonEncode(parameterMap),
                                        ),
                                      )
                                      .when(
                                        data: (data) {
                                          List test = data
                                              .map((e) => e.toJson())
                                              .toList();
                                          print(test);

                                          return LineChartWidget(
                                            salesSummaryList: data,
                                            //TODO static value
                                            xAxisFilter: "This week",
                                          );
                                        },
                                        error: (err, stack) {
                                          print(err);
                                          String error = "Error - ";

                                          if (err is DioException) {
                                            if (err.response!.statusCode ==
                                                500) {
                                              error += "Bad request";
                                            }
                                          } else {
                                            error += err.toString();
                                          }

                                          print(stack);
                                          return ErrorText(errorText: error);
                                        },
                                        loading: () => const Loader(),
                                      );
                                },
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

  void _showDropDownDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select an Option'),
            content: Wrap(
              children: [
                // CustomDropDown(
                //     dropList: ref
                //         .read(branchListProvider)
                //         .map((e) => e.branchName)
                //         .toList(),
                //     selectedValueProvider: branchValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(metalTypeListProvider)
                        .map((e) => e.displayMember)
                        .toList(),
                    selectedValueProvider: metalTypeValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(itemListProvider)
                        .map((e) => e.displayMember)
                        .toList(),
                    selectedValueProvider: itemValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(measurmentListProvider)
                        .map((e) => e.displayMember)
                        .toList(),
                    selectedValueProvider: measurementValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(salesTypeListProvider)
                        .map((e) => e.displayMember)
                        .toList(),
                    selectedValueProvider: salesTypeValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(categoryListProvider)
                        .map((e) => e.displayMember)
                        .toList(),
                    selectedValueProvider: categoryValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(modelListProvider)
                        .map((e) => e.displayMember)
                        .toList(),
                    selectedValueProvider: modelValueProvider),
                CustomDropDown(
                    dropList: ref
                        .read(salesManListProvider)
                        .map((e) => e.displayMember)
                        .toList(),
                    selectedValueProvider: salesmanValueProvider),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  showCustomDateRangePicker(
                    context,
                    dismissible: true,
                    minimumDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    maximumDate: DateTime.now().add(const Duration(days: 30)),
                    endDate: ref.watch(endDateProvider),
                    startDate: ref.watch(startDateProvider),
                    backgroundColor: Colors.white,
                    primaryColor: Colors.green,
                    onApplyClick: (start, end) {
                      ref.read(startDateProvider.notifier).state = start;
                      ref.read(endDateProvider.notifier).state = end;
                    },
                    onCancelClick: () {
                      ref.read(startDateProvider.notifier).state =
                          DateTime.now();
                      ref.read(endDateProvider.notifier).state = DateTime.now();
                    },
                  );
                },
                child: Text('Pick Date Range'),
              ),
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

  Future<void> getMetalTypes() async {
    await ref
        .read(salesControllerProvider.notifier)
        .getMetalTypeData(branchId: branchId!, context: context);
  }

  Future<void> getItemList() async {
    await ref
        .read(salesControllerProvider.notifier)
        .getItemList(branchId: branchId!, context: context);
  }

  Future<void> getMeasurementList() async {
    await ref
        .read(salesControllerProvider.notifier)
        .getMeasurementList(branchId: branchId!, context: context);
  }

  Future<void> getSalesmanList() async {
    await ref
        .read(salesControllerProvider.notifier)
        .getSalesmanList(branchId: branchId!, context: context);
  }

  Future<void> getCategoryList() async {
    await ref
        .read(salesControllerProvider.notifier)
        .getCategoryList(branchId: branchId!, context: context);
  }

  Future<void> getItemModelList() async {
    await ref
        .read(salesControllerProvider.notifier)
        .getItemModelList(branchId: branchId!, context: context);
  }

  Future<void> getSalesTypeList() async {
    await ref
        .read(salesControllerProvider.notifier)
        .getSalesTypeList(branchId: branchId!, context: context);
  }
}
