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
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

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

  //to pass parameters for filter

  final parameterProvider = StateProvider<Map<String, dynamic>>((ref) => {});

  //picked date providers
  final startDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });
  final endDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });

  //metal type

  final metalTypeValueProvider = StateProvider<List<String>>((ref) {
    return [];
  });

  //item list

  final itemValueProvider = StateProvider<List<String>>((ref) {
    return [];
  });

  //Measurement list

  final measurementValueProvider = StateProvider<List<String>>((ref) {
    return [];
  });

  //salesman list

  final salesmanValueProvider = StateProvider<List<String>>((ref) {
    return [];
  });

  //Sales type list

  final salesTypeValueProvider = StateProvider<List<String>>((ref) {
    return [];
  });

  //Item model

  final modelValueProvider = StateProvider<List<String>>((ref) {
    return [];
  });

  //category value

  final categoryValueProvider = StateProvider<List<String>>((ref) {
    return [];
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: w * .05,
                  ),
                  Row(
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
                      Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            color: Colors.indigo,
                            onPressed: () async {
                              showCustomDateRangePicker(
                                context,
                                dismissible: true,
                                minimumDate: DateTime.now()
                                    .subtract(const Duration(days: 30)),
                                maximumDate: DateTime.now()
                                    .add(const Duration(days: 30)),
                                endDate: ref.watch(endDateProvider),
                                startDate: ref.watch(startDateProvider),
                                backgroundColor: Colors.white,
                                primaryColor: Colors.green,
                                onApplyClick: (start, end) {
                                  ref.read(startDateProvider.notifier).state =
                                      start;
                                  ref.read(endDateProvider.notifier).state =
                                      end;
                                },
                                onCancelClick: () {
                                  ref.read(startDateProvider.notifier).state =
                                      DateTime.now();
                                  ref.read(endDateProvider.notifier).state =
                                      DateTime.now();
                                },
                              );
                            },
                            icon: Icon(
                              Icons.calendar_month_sharp,
                              size: w * .14,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(
                    height: w * .05,
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
                                      "101.099",
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

                  SizedBox(
                    height: w * .1,
                  ),
                  //Added pie chart
                  SizedBox(
                    height: h * .5,
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

                                  final parameterMap =
                                      ref.watch(parameterProvider);

                                  if (parameterMap.isEmpty) {
                                    final startDate =
                                        ref.read(startDateProvider);
                                    final endDate = ref.read(endDateProvider);
                                    String formattedStartDate =
                                        DateFormat("dd-MMM-yyyy")
                                            .format(startDate);
                                    String formattedEndDate =
                                        DateFormat("dd-MMM-yyyy")
                                            .format(endDate);

                                    parameterMap["branchId"] =
                                        branchId.toString();
                                    parameterMap["dateFrom"] =
                                        formattedStartDate;
                                    parameterMap["dateTo"] = formattedEndDate;
                                  }

                                  return ref
                                      .watch(salesSummaryProvider(
                                        jsonEncode(parameterMap),
                                      ))
                                      .when(
                                        data: (data) {
                                          return LineChartWidget(
                                              salesSummaryList: data,
                                              //TODO static value
                                              xAxisFilter: "This week");
                                        },
                                        error: (err, stack) {
                                          return ErrorText(
                                              errorText: err.toString());
                                        },
                                        loading: () => const Loader(),
                                      );
                                },
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

  List<String> _selectedItems = [];

  void _showDropDownDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Select Options',
              textAlign: TextAlign.center,
            ),
            content: Wrap(
              children: [
                //extracted method to make it more readable
                // TODO EXTRACT WIDGET AND PASS providers accordingly

                //1
                multiSelectDialogField(
                    title: 'SELECT ITEM',
                    items: ref
                        .read(itemListProvider)
                        .map((e) => MultiSelectItem<String>(
                            e.displayMember, e.displayMember))
                        .toList()),

                //2
                multiSelectDialogField(
                    title: 'SELECT METAL',
                    items: ref
                        .read(metalTypeListProvider)
                        .map((e) => MultiSelectItem<String>(
                            e.displayMember, e.displayMember))
                        .toList()),

                //3
                multiSelectDialogField(
                    title: 'SELECT MEASUREMENT',
                    items: ref
                        .read(measurmentListProvider)
                        .map((e) => MultiSelectItem<String>(
                            e.displayMember, e.displayMember))
                        .toList()),

                //4
                multiSelectDialogField(
                    title: 'SELECT SALES TYPE',
                    items: ref
                        .read(salesTypeListProvider)
                        .map((e) => MultiSelectItem<String>(
                            e.displayMember, e.displayMember))
                        .toList()),

                //5
                multiSelectDialogField(
                    title: 'SELECT CATEGORY',
                    items: ref
                        .read(categoryListProvider)
                        .map((e) => MultiSelectItem<String>(
                            e.displayMember, e.displayMember))
                        .toList()),

                //6
                multiSelectDialogField(
                  title: 'SELECT MODEL',
                  items: ref
                      .read(modelListProvider)
                      .map((e) => MultiSelectItem<String>(
                          e.displayMember, e.displayMember))
                      .toList(),
                ),

                //7
                multiSelectDialogField(
                    title: 'SELECT SALESMAN',
                    items: ref
                        .read(salesManListProvider)
                        .map((e) => MultiSelectItem<String>(
                            e.displayMember, e.displayMember))
                        .toList()),

                //TODO refer the below code and modify the above code !

                // CustomDropDown(
                //     dropList: ref
                //         .read(itemListProvider)
                //         .map((e) => e.displayMember)
                //         .toList(),
                //     selectedValueProvider: itemValueProvider),
                // CustomDropDown(
                //     dropList: ref
                //         .read(measurmentListProvider)
                //         .map((e) => e.displayMember)
                //         .toList(),
                //     selectedValueProvider: measurementValueProvider),
                // CustomDropDown(
                //     dropList: ref
                //         .read(salesTypeListProvider)
                //         .map((e) => e.displayMember)
                //         .toList(),
                //     selectedValueProvider: salesTypeValueProvider),
                // CustomDropDown(
                //     dropList: ref
                //         .read(categoryListProvider)
                //         .map((e) => e.displayMember)
                //         .toList(),
                //     selectedValueProvider: categoryValueProvider),
                // CustomDropDown(
                //     dropList: ref
                //         .read(modelListProvider)
                //         .map((e) => e.displayMember)
                //         .toList(),
                //     selectedValueProvider: modelValueProvider),
                // CustomDropDown(
                //     dropList: ref
                //         .read(salesManListProvider)
                //         .map((e) => e.displayMember)
                //         .toList(),
                //     selectedValueProvider: salesmanValueProvider),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  final startDate = ref.read(startDateProvider);
                  final endDate = ref.read(endDateProvider);
                  final itemCategory = ref.read(categoryValueProvider);
                  final itemName = ref.read(itemValueProvider);
                  final metalType = ref.read(metalTypeValueProvider);
                  final modelName = ref.read(modelValueProvider);
                  final salesManId = ref.read(salesmanValueProvider);
                  final measurementName = ref.read(measurementValueProvider);
                  final salesMode = ref.read(salesTypeValueProvider);

                  String formattedStartDate =
                      DateFormat("dd-MMM-yyyy").format(startDate);
                  String formattedEndDate =
                      DateFormat("dd-MMM-yyyy").format(endDate);

                  Map<String, dynamic> parameterMap = {
                    "dateFrom": formattedStartDate,
                    "dateTo": formattedEndDate,
                    "branchId": branchId.toString(),
                    "itemCategory":
                        itemCategory.isNotEmpty ? itemCategory[0] : null,
                    "itemName": itemName.isNotEmpty ? itemName[0] : null,
                    "metalType": metalType.isNotEmpty ? metalType[0] : null,
                    "modelName": modelName.isNotEmpty ? modelName[0] : null,
                    "salesManId": salesManId.isNotEmpty ? salesManId[0] : null,
                    "measurementName":
                        measurementName.isNotEmpty ? measurementName[0] : null,
                    "salesMode": salesMode.isNotEmpty ? salesMode[0] : null
                  };
                  print("===============");
                  print(parameterMap);
                  print("===========");

                  ref.read(parameterProvider.notifier).state = parameterMap;

                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      );
    });
  }

  Padding multiSelectDialogField({required title, required items}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MultiSelectDialogField(
        buttonText: Text(title),
        title: Text(
          title,
          style: GoogleFonts.alice(
              fontSize: w * .045, fontWeight: FontWeight.w400),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        searchHint: 'Search Here...',
        items: items,
        initialValue: _selectedItems,
        searchable: true,
        onConfirm: (values) {
          switch (title) {
            case "SELECT ITEM":
              ref.read(itemValueProvider.notifier).state = values;
              break;
            case "SELECT METAL":
              ref.read(metalTypeValueProvider.notifier).state = values;
              break;
            case "SELECT MEASUREMENT":
              ref.read(measurementValueProvider.notifier).state = values;
              break;
            case "SELECT SALES TYPE":
              ref.read(salesTypeValueProvider.notifier).state = values;
              break;
            case "SELECT CATEGORY":
              ref.read(categoryValueProvider.notifier).state = values;
              break;
            case "SELECT MODEL":
              ref.read(modelValueProvider.notifier).state = values;
              break;
            case "SELECT SALESMAN":
              ref.read(salesmanValueProvider.notifier).state = values;
              break;
          }
        },
      ),
    );
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
