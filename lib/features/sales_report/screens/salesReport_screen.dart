import 'dart:convert';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';
import 'package:gramboo_sales_details/core/utilities/loader.dart';
import 'package:gramboo_sales_details/features/sales_report/controller/salesController.dart';
import 'package:gramboo_sales_details/features/sales_report/data/graphType.dart';
import 'package:gramboo_sales_details/features/sales_report/data/multiSelectType.dart';
import 'package:gramboo_sales_details/features/sales_report/widgets/barChartWidget.dart';
import 'package:gramboo_sales_details/features/sales_report/widgets/newLineChart.dart';
import 'package:gramboo_sales_details/models/salesSummaryParamModel.dart';
import 'package:gramboo_sales_details/models/salesSummary_model.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../core/error_handling/error_text.dart';
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
  int? branchId;

  List<Color> graphLineColorList = [
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.black,
    Colors.deepOrange,
    Colors.amber,
    Colors.cyanAccent,
    Colors.brown,
    Colors.deepPurple,
    Colors.teal
  ];

  final touchedIndexPieProvider = StateProvider<int>((ref) {
    return -1;
  });

  final dayFilterDropValueProvider = StateProvider<String?>((ref) {
    return "Today";
  });

  final graphFiltersProvider = StateProvider<List<String>>((ref) => []);

  //to pass parameters for filter

  final parameterProvider = StateProvider<SalesSummaryParamsModel>(
    (ref) {
      String formattedStartDate =
          DateFormat("dd-MMM-yyyy").format(DateTime.now());
      String formattedEndDate =
          DateFormat("dd-MMM-yyyy").format(DateTime.now());

      return SalesSummaryParamsModel(
          dateFrom: formattedStartDate,
          dateTo: formattedEndDate,
          branchId: ref.read(branchListProvider)[0].branchId,
          multiSelectName: null,
          multiSelectList: null);
    },
  );

  //picked date providers
  final startDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });
  final endDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });

  final multiSelectListProvider = StateProvider<List<String>>((ref) => []);

  final disableMultiSelectProvider = StateProvider<String?>((ref) => null);

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
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
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
          ? const LinearProgressIndicator()
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
                            onPressed: () => showCalendar(),
                            icon: Icon(
                              Icons.calendar_month_sharp,
                              size: w * .14,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () => _showDropDownDialog(),
                        icon: Icon(
                          Icons.filter_list,
                          size: w * .14,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: w * .05,
                  ),

                  //weight selection card

                  Expanded(
                    child: Card(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final parametersModel = ref.watch(parameterProvider);

                          ref.watch(weightDropValueProvider);

                          return ref
                              .watch(salesSummaryProvider(
                                  jsonEncode(parametersModel.toMap())))
                              .when(
                                data: (data) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: h * .2,
                                        width: w * .9,
                                        child: Card(
                                          elevation: 20,
                                          color: Colors.blue,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "TOTAL WEIGHT",
                                                  style: GoogleFonts.alice(
                                                      fontSize: w * .08,
                                                      color: Colors.white),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 7,
                                                              left: 7),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: .5,
                                                        ),
                                                      ),
                                                      height: h * .055,
                                                      child: Center(
                                                        child: Text(
                                                          getTotalWeight(
                                                              salesSummaryList:
                                                                  data,
                                                              weightName: ref.read(
                                                                  weightDropValueProvider)!),
                                                          style: TextStyle(
                                                              fontSize: w * .05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
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
                                      Text(
                                        "WEIGHT DATA",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.alice(
                                          fontSize: w * .08,
                                        ),
                                      ),
                                      getGraph(
                                          data: data,
                                          parametersModel: parametersModel),
                                      Wrap(
                                        spacing: 10,
                                        children: getColorCodeForGraph(),
                                      )
                                    ],
                                  );
                                },
                                error: (err, stack) {
                                  return ErrorText(errorText: err.toString());
                                },
                                loading: () => const Loader(),
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
            title: const Text(
              'Select an Option',
              textAlign: TextAlign.center,
            ),
            content: Consumer(
              builder: (context, ref, child) {
                final disableMultiSelect =
                    ref.watch(disableMultiSelectProvider);

                return Wrap(
                  children: [
                    //extracted method to make it more readable

                    //1

                    disableMultiSelect == null ||
                            disableMultiSelect == MultiSelectType.metalType
                        ? multiSelectDialogField(
                            title: 'SELECT METAL',
                            items: ref
                                .read(metalTypeListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //2

                    disableMultiSelect == null ||
                            disableMultiSelect == MultiSelectType.categoryName
                        ? multiSelectDialogField(
                            title: 'SELECT CATEGORY',
                            items: ref
                                .read(categoryListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //3

                    disableMultiSelect == null ||
                            disableMultiSelect == MultiSelectType.itemName
                        ? multiSelectDialogField(
                            title: 'SELECT ITEM',
                            items: ref
                                .read(itemListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //4
                    disableMultiSelect == null ||
                            disableMultiSelect == MultiSelectType.salesType
                        ? multiSelectDialogField(
                            title: 'SELECT SALES TYPE',
                            items: ref
                                .read(salesTypeListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //5

                    disableMultiSelect == null ||
                            disableMultiSelect ==
                                MultiSelectType.measurementType
                        ? multiSelectDialogField(
                            title: 'SELECT MEASUREMENT',
                            items: ref
                                .read(measurmentListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //6
                    disableMultiSelect == null ||
                            disableMultiSelect == MultiSelectType.modelName
                        ? multiSelectDialogField(
                            title: 'SELECT MODEL',
                            items: ref
                                .read(modelListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList(),
                          )
                        : Container(),

                    //7
                    disableMultiSelect == null ||
                            disableMultiSelect == MultiSelectType.salesManId
                        ? multiSelectDialogField(
                            title: 'SELECT SALESMAN',
                            items: ref
                                .read(salesManListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(graphFiltersProvider.notifier).state = [];
                  ref.read(disableMultiSelectProvider.notifier).state = null;
                  ref.read(startDateProvider.notifier).state = DateTime.now();
                  ref.read(endDateProvider.notifier).state = DateTime.now();
                  String formattedStartDate =
                      DateFormat("dd-MMM-yyyy").format(DateTime.now());
                  String formattedEndDate =
                      DateFormat("dd-MMM-yyyy").format(DateTime.now());

                  ref.read(parameterProvider.notifier).state =
                      SalesSummaryParamsModel(
                          dateFrom: formattedStartDate,
                          dateTo: formattedEndDate,
                          branchId: ref.read(branchListProvider)[0].branchId,
                          multiSelectName: null,
                          multiSelectList: null);
                },
                child: const Text("Clear filter"),
              ),
              TextButton(
                onPressed: () {
                  final startDate = ref.read(startDateProvider);
                  final endDate = ref.read(endDateProvider);
                  final multiSelectList = ref.read(multiSelectListProvider);

                  String formattedStartDate =
                      DateFormat("dd-MMM-yyyy").format(startDate);
                  String formattedEndDate =
                      DateFormat("dd-MMM-yyyy").format(endDate);

                  SalesSummaryParamsModel salesSummaryParams =
                      SalesSummaryParamsModel(
                          dateFrom: formattedStartDate,
                          dateTo: formattedEndDate,
                          multiSelectName: ref.read(disableMultiSelectProvider),
                          branchId: branchId!,
                          multiSelectList: multiSelectList);

                  ref.read(graphFiltersProvider.notifier).state =
                      multiSelectList;

                  ref.read(parameterProvider.notifier).state =
                      salesSummaryParams;

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
    List<String> selectedItems = ref.watch(graphFiltersProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MultiSelectDialogField(
        dialogWidth: w,
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
        initialValue: selectedItems,
        searchable: true,
        onConfirm: (values) {
          ref.read(multiSelectListProvider.notifier).state = values;

          switch (title) {
            case "SELECT ITEM":
              ref.read(disableMultiSelectProvider.notifier).state =
                  MultiSelectType.itemName;
              break;
            case "SELECT METAL":
              ref.read(disableMultiSelectProvider.notifier).state =
                  MultiSelectType.metalType;
              break;
            case "SELECT MEASUREMENT":
              ref.read(disableMultiSelectProvider.notifier).state =
                  MultiSelectType.measurementType;
              break;
            case "SELECT SALES TYPE":
              ref.read(disableMultiSelectProvider.notifier).state =
                  MultiSelectType.salesType;
              break;
            case "SELECT CATEGORY":
              ref.read(disableMultiSelectProvider.notifier).state =
                  MultiSelectType.categoryName;
              break;
            case "SELECT MODEL":
              ref.read(disableMultiSelectProvider.notifier).state =
                  MultiSelectType.modelName;
              break;
            case "SELECT SALESMAN":
              ref.read(disableMultiSelectProvider.notifier).state =
                  MultiSelectType.salesManId;
              break;
          }
        },
        chipDisplay: MultiSelectChipDisplay(
          scroll: true,
          items: selectedItems.map((e) => MultiSelectItem(e, e)).toList(),
        ),
      ),
    );
  }

  //didchange functions =============================

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

  //==============================================

  //Get Total wight acc to dropdown selection ====================

  String getTotalWeight(
      {required List<SalesSummaryModel> salesSummaryList,
      required String weightName}) {
    double totalWeight = 0;
    switch (weightName) {
      case "Gross Weight":
        for (var i in salesSummaryList) {
          totalWeight += i.gwt!;
        }

        return totalWeight.toStringAsFixed(3);
      case "Stone Weight":
        for (var i in salesSummaryList) {
          totalWeight += i.stoneWt!;
        }

        return totalWeight.toStringAsFixed(3);
      case "Dia Weight":
        for (var i in salesSummaryList) {
          totalWeight += i.diaWt!;
        }

        return totalWeight.toStringAsFixed(3);
      case "Net Weight":
        for (var i in salesSummaryList) {
          totalWeight += i.netWt!;
        }

        return totalWeight.toStringAsFixed(3);
      case "Total Qty":
        for (var i in salesSummaryList) {
          totalWeight += i.qty ?? 0;
        }

        return totalWeight.toStringAsFixed(3);
      case "VA Percentage":
        for (var i in salesSummaryList) {
          totalWeight += i.vAPercAfterDisc!;
        }

        return totalWeight.toStringAsFixed(3);
      case "VA Amount":
        for (var i in salesSummaryList) {
          totalWeight += i.vAAfterDisc!;
        }

        return totalWeight.toStringAsFixed(3);
      default:
        for (var i in salesSummaryList) {
          totalWeight += i.diaWt!;
        }

        return totalWeight.toStringAsFixed(3);
    }
  }

  //=============================

  //GRAPH
  //Get color for labels ================================
  List<Text> getColorCodeForGraph() {
    final multiSelectList = ref.read(graphFiltersProvider);
    List<Text> filterList = [];
    for (int i = 0; i < multiSelectList.length; i++) {
      filterList.add(
        Text(
          multiSelectList[i],
          style: TextStyle(color: graphLineColorList[i]),
        ),
      );
    }

    return filterList;
  }

  Widget getGraph(
      {required List<SalesSummaryModel> data,
      required SalesSummaryParamsModel parametersModel}) {
    int noOfDays = ref
        .read(endDateProvider)
        .difference(ref.read(startDateProvider))
        .inDays;

    String graphType = _calculateGraphType(noOfDays);

    if (graphType != GraphType.today) {
      return NewLineChart(
        salesSummaryList: data,
        paramModel: parametersModel,
        filters: ref.read(graphFiltersProvider),
        yAxisConstraint: ref.read(weightDropValueProvider)!,
        multiSelect: ref.read(disableMultiSelectProvider) ?? "",
        colorList: graphLineColorList,
        graphType: graphType,
      );
    } else {
      return BarCharWidget(
        salesSummaryList: data,
        paramModel: parametersModel,
        filters: ref.read(graphFiltersProvider),
        yAxisConstraint: ref.read(weightDropValueProvider)!,
        multiSelect: ref.read(disableMultiSelectProvider) ?? "",
        colorList: graphLineColorList,
        graphType: graphType,
      );
    }
  }

  String _calculateGraphType(int noOfDays) {
    DateTime startDate = ref.read(startDateProvider);
    DateTime endDate = ref.read(endDateProvider);

    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        noOfDays > 1) {
      return GraphType.daysInMonth;
    } else if ((startDate.year != endDate.year ||
            startDate.month != endDate.month) &&
        noOfDays <= 365) {
      return GraphType.monthly;
    } else if (noOfDays > 365) {
      return GraphType.yearly;
    } else {
      return GraphType.today;
    }
  }

  //++======================================================

  //
  // List<String> getIdOfDropDownValue({required String dropDownName}) {
  //   switch (dropDownName) {
  //     case "item":
  //       return ref.read(itemListProvider).map((e) => e.valueMember).toList();
  //     case "metal":
  //       return ref
  //           .read(metalTypeListProvider)
  //           .map((e) => e.valueMember)
  //           .toList();
  //     case "salesman":
  //       return ref
  //           .read(salesManListProvider)
  //           .map((e) => e.valueMember)
  //           .toList();
  //     case "measurement":
  //       return ref
  //           .read(measurmentListProvider)
  //           .map((e) => e.valueMember)
  //           .toList();
  //     case "sales":
  //       return ref
  //           .read(salesTypeListProvider)
  //           .map((e) => e.valueMember)
  //           .toList();
  //     case "category":
  //       return ref
  //           .read(categoryListProvider)
  //           .map((e) => e.valueMember)
  //           .toList();
  //     case "model":
  //       return ref.read(modelListProvider).map((e) => e.valueMember).toList();
  //     default:
  //       return [];
  //   }
  // }

  showCalendar() {
    DateTime startDate = ref.read(startDateProvider);
    DateTime endDate = ref.read(endDateProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Text('Select Date Range'),
              TextButton(
                onPressed: () {
                  ref.read(startDateProvider.notifier).state = DateTime.now();
                  ref.read(endDateProvider.notifier).state = DateTime.now();
                  Navigator.pop(context);
                },
                child: const Text('Clear date'),
              ),
            ],
          ),
          content: SizedBox(
            height: w * .9,
            width: h * .8,
            child: SfDateRangePicker(
              initialSelectedDate: DateTime.now(),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                startDate = args.value.startDate;
                endDate = args.value.endDate;
              },
              allowViewNavigation: true,
              initialSelectedRange: PickerDateRange(startDate, endDate),
              maxDate: DateTime.now(),
              onSubmit: (p0) {
                ref.read(startDateProvider.notifier).state = startDate;
                ref.read(endDateProvider.notifier).state = endDate;

                String formattedStartDate =
                    DateFormat("dd-MMM-yyyy").format(startDate);
                String formattedEndDate =
                    DateFormat("dd-MMM-yyyy").format(endDate);

                final parameterModel = ref.read(parameterProvider);

                ref.read(parameterProvider.notifier).state =
                    parameterModel.copyWith(
                        dateFrom: formattedStartDate, dateTo: formattedEndDate);

                Navigator.pop(context);
              },
              onCancel: () {
                Navigator.pop(context);
              },
              showActionButtons: true,
              selectionMode: DateRangePickerSelectionMode.extendableRange,
              extendableRangeSelectionDirection:
                  ExtendableRangeSelectionDirection.both,
              toggleDaySelection: true,
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
              ),
              monthViewSettings: DateRangePickerMonthViewSettings(
                enableSwipeSelection: false,
              ),
            ),
          ),
        );
      },
    );
  }
}
