import 'dart:convert';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';
import 'package:gramboo_sales_details/core/utilities/loader.dart';
import 'package:gramboo_sales_details/features/sales_report/controller/salesController.dart';
import 'package:gramboo_sales_details/features/sales_report/widgets/lineChartWidget.dart';
import 'package:gramboo_sales_details/models/salesSummaryParamModel.dart';
import 'package:gramboo_sales_details/models/salesSummary_model.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
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

  final touchedIndexPieProvider = StateProvider<int>((ref) {
    return -1;
  });

  final dayFilterDropValueProvider = StateProvider<String?>((ref) {
    return "Today";
  });

  final graphFiltersProvider = StateProvider<List<String>>((ref) => []);

  //to pass parameters for filter

  final parameterProvider =
      StateProvider<SalesSummaryParamsModel?>((ref) => null);

  //picked date providers
  final startDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });
  final endDateProvider = StateProvider<DateTime>((ref) {
    return DateTime.now();
  });

  final multiSelectListProvider = StateProvider<List<String>>((ref) => []);

  final disableMultiSelectProvider = StateProvider<String?>((ref) => null);

  // //metal type
  //
  // final metalTypeValueProvider = StateProvider<List<String>>((ref) {
  //   return [];
  // });
  //
  // //item list
  //
  // final itemValueProvider = StateProvider<List<String>>((ref) {
  //   return [];
  // });
  //
  // //Measurement list
  //
  // final measurementValueProvider = StateProvider<List<String>>((ref) {
  //   return [];
  // });
  //
  // //salesman list
  //
  // final salesmanValueProvider = StateProvider<List<String>>((ref) {
  //   return [];
  // });
  //
  // //Sales type list
  //
  // final salesTypeValueProvider = StateProvider<List<String>>((ref) {
  //   return [];
  // });
  //
  // //Item model
  //
  // final modelValueProvider = StateProvider<List<String>>((ref) {
  //   return [];
  // });
  //
  // //category value
  //
  // final categoryValueProvider = StateProvider<List<String>>((ref) {
  //   return [];
  // });

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

                                  String formattedStartDate =
                                      DateFormat("dd-MMM-yyyy").format(start);
                                  String formattedEndDate =
                                      DateFormat("dd-MMM-yyyy").format(end);

                                  final parameterModel =
                                      ref.read(parameterProvider);

                                  ref.read(parameterProvider.notifier).state =
                                      parameterModel!.copyWith(
                                          dateFrom: formattedStartDate,
                                          dateTo: formattedEndDate);
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

                          return parametersModel != null
                              ? ref
                                  .watch(
                                    salesSummaryProvider(
                                      jsonEncode(parametersModel.toMap()),
                                    ),
                                  )
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      "TOTAL WEIGHT",
                                                      style: GoogleFonts.alice(
                                                          fontSize: w * .08,
                                                          color: Colors.white),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 7,
                                                                  left: 7),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: .5,
                                                            ),
                                                          ),
                                                          height: h * .055,
                                                          child: Center(
                                                            child: Text(
                                                              getTotalWeight(
                                                                  salesSummaryList:
                                                                      data,
                                                                  weightName:
                                                                      ref.read(
                                                                          weightDropValueProvider)!),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      w * .05,
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
                                          LineChartWidget(
                                            salesSummaryList: data,
                                            paramModel: parametersModel,
                                            filters:
                                                ref.read(graphFiltersProvider),
                                            yAxisConstraint: ref
                                                .read(weightDropValueProvider)!,
                                            multiSelect: ref.read(
                                                disableMultiSelectProvider)!,
                                          )
                                        ],
                                      );
                                    },
                                    error: (err, stack) {
                                      print(stack);
                                      return ErrorText(
                                          errorText: err.toString());
                                    },
                                    loading: () => const Loader(),
                                  )
                              : const Text("Select options!");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  final List<String> _selectedItems = [];

  void _showDropDownDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          print("REEEEEBBUUBUB");

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

                    disableMultiSelect == null || disableMultiSelect == "item"
                        ? multiSelectDialogField(
                            title: 'SELECT ITEM',
                            items: ref
                                .read(itemListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //2
                    disableMultiSelect == null || disableMultiSelect == "metal"
                        ? multiSelectDialogField(
                            title: 'SELECT METAL',
                            items: ref
                                .read(metalTypeListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //3
                    disableMultiSelect == null ||
                            disableMultiSelect == "measurement"
                        ? multiSelectDialogField(
                            title: 'SELECT MEASUREMENT',
                            items: ref
                                .read(measurmentListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //4
                    disableMultiSelect == null ||
                            disableMultiSelect == "salesType"
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
                            disableMultiSelect == "category"
                        ? multiSelectDialogField(
                            title: 'SELECT CATEGORY',
                            items: ref
                                .read(categoryListProvider)
                                .map((e) => MultiSelectItem<String>(
                                    e.displayMember, e.displayMember))
                                .toList())
                        : Container(),

                    //6
                    disableMultiSelect == null || disableMultiSelect == "model"
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
                            disableMultiSelect == "salesman"
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
                  final startDate = ref.read(startDateProvider);
                  final endDate = ref.read(endDateProvider);

                  String formattedStartDate =
                      DateFormat("dd-MMM-yyyy").format(startDate);
                  String formattedEndDate =
                      DateFormat("dd-MMM-yyyy").format(endDate);

                  SalesSummaryParamsModel salesSummaryParams =
                      SalesSummaryParamsModel(
                          dateFrom: formattedStartDate,
                          dateTo: formattedEndDate,
                          branchId: branchId!,
                          multiSelectName: null,
                          multiSelectList: null);

                  ref.read(parameterProvider.notifier).state =
                      salesSummaryParams;

                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  final startDate = ref.read(startDateProvider);
                  final endDate = ref.read(endDateProvider);
                  final multiSelectList = ref.read(multiSelectListProvider);
                  // final itemCategoryList = ref.read(categoryValueProvider);
                  // final itemNameList = ref.read(itemValueProvider);
                  // final metalTypeList = ref.read(metalTypeValueProvider);
                  // final modelNameList = ref.read(modelValueProvider);
                  // final salesManIdList = ref.read(salesmanValueProvider);
                  // final measurementList = ref.read(measurementValueProvider);
                  // final salesModeList = ref.read(salesTypeValueProvider);

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
          ref.read(multiSelectListProvider.notifier).state = values;

          switch (title) {
            case "SELECT ITEM":
              ref.read(disableMultiSelectProvider.notifier).state = "item";
              break;
            case "SELECT METAL":
              ref.read(disableMultiSelectProvider.notifier).state = "metal";
              break;
            case "SELECT MEASUREMENT":
              ref.read(disableMultiSelectProvider.notifier).state =
                  "measurement";
              break;
            case "SELECT SALES TYPE":
              ref.read(disableMultiSelectProvider.notifier).state = "salesType";
              break;
            case "SELECT CATEGORY":
              ref.read(disableMultiSelectProvider.notifier).state = "category";
              break;
            case "SELECT MODEL":
              ref.read(disableMultiSelectProvider.notifier).state = "model";
              break;
            case "SELECT SALESMAN":
              ref.read(disableMultiSelectProvider.notifier).state = "salesman";
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
          totalWeight += i.qty!;
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
}
