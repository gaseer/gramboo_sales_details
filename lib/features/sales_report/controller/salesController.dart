import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gramboo_sales_details/core/utilities/custom_snackBar.dart';
import 'package:gramboo_sales_details/features/sales_report/service/salesService.dart';
import 'package:gramboo_sales_details/models/MeasurementModel.dart';
import 'package:gramboo_sales_details/models/categoryModel.dart';
import 'package:gramboo_sales_details/models/itemModel.dart';
import 'package:gramboo_sales_details/models/metalType_model.dart';
import 'package:gramboo_sales_details/models/modelItem_model.dart';
import 'package:gramboo_sales_details/models/salesSummaryParamModel.dart';
import 'package:gramboo_sales_details/models/salesSummary_model.dart';
import 'package:gramboo_sales_details/models/salesTypeModel.dart';
import 'package:gramboo_sales_details/models/salesmanModel.dart';
import 'package:intl/intl.dart';

final salesControllerProvider = NotifierProvider<SalesController, bool>(
  () => SalesController(),
);

final salesSummaryProvider = FutureProvider.autoDispose
    .family<List<SalesSummaryModel>, String>((ref, parameters) async {
  final decodedMap = jsonDecode(parameters);

  final SalesSummaryParamsModel salesSummaryParamsModel =
      SalesSummaryParamsModel.fromMap(decodedMap);

  return ref
      .read(salesControllerProvider.notifier)
      .getSalesSummary(paramsModel: salesSummaryParamsModel);
});

final metalTypeListProvider = StateProvider<List<MetalTypeModel>>((ref) {
  return [];
});

final itemListProvider = StateProvider<List<ItemModel>>((ref) {
  return [];
});

final categoryListProvider = StateProvider<List<CategoryModel>>((ref) {
  return [];
});

final modelListProvider = StateProvider<List<ModelModel>>((ref) {
  return [];
});

final measurmentListProvider = StateProvider<List<MeasurementModel>>((ref) {
  return [];
});

final salesTypeListProvider = StateProvider<List<SalesTypeModel>>((ref) {
  return [];
});

final salesManListProvider = StateProvider<List<SalesmanModel>>((ref) {
  return [];
});

class SalesController extends Notifier<bool> {
  SalesController();

  @override
  build() {
    return false;
  }

  getMetalTypeData(
      {required int branchId, required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "MetalType", branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      List<MetalTypeModel> metalList = [];
      metalList = dropDownList.map((e) => MetalTypeModel.fromMap(e)).toList();
      ref.read(metalTypeListProvider.notifier).state = metalList;
    });
  }

  getMeasurementList(
      {required int branchId, required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Measurement", branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      List<MeasurementModel> measurementList = [];
      measurementList =
          dropDownList.map((e) => MeasurementModel.fromMap(e)).toList();
      ref.read(measurmentListProvider.notifier).state = measurementList;
    });
  }

  getItemList({required int branchId, required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Item", branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      List<ItemModel> itemList = [];
      itemList = dropDownList.map((e) => ItemModel.fromMap(e)).toList();
      ref.read(itemListProvider.notifier).state = itemList;
    });
  }

  getSalesmanList(
      {required int branchId, required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Salesman", branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      List<SalesmanModel> salesmanList = [];
      salesmanList = dropDownList.map((e) => SalesmanModel.fromMap(e)).toList();
      ref.read(salesManListProvider.notifier).state = salesmanList;
    });
  }

  getCategoryList(
      {required int branchId, required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Category", branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      List<CategoryModel> categoryList = [];
      categoryList = dropDownList.map((e) => CategoryModel.fromMap(e)).toList();
      ref.read(categoryListProvider.notifier).state = categoryList;
    });
  }

  getItemModelList(
      {required int branchId, required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Model", branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      List<ModelModel> itemModelList = [];
      itemModelList = dropDownList.map((e) => ModelModel.fromMap(e)).toList();
      ref.read(modelListProvider.notifier).state = itemModelList;
    });
  }

  getSalesTypeList(
      {required int branchId, required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "SalesType", branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      List<SalesTypeModel> salesTypeList = [];
      salesTypeList =
          dropDownList.map((e) => SalesTypeModel.fromMap(e)).toList();
      ref.read(salesTypeListProvider.notifier).state = salesTypeList;
    });
  }

  Future<List<SalesSummaryModel>> getSalesSummary({
    required SalesSummaryParamsModel paramsModel,
  }) async {
    final res = await ref
        .read(salesServiceProvider)
        .getSalesSummary(parameters: paramsModel);

    return res.fold(
      (l) {
        throw Exception(l.errMSg);
      },
      (summaryList) {
        List<Map<String, dynamic>> allDatesSummaryList = [];

        List<String> allDatesInIso = getISO8601DatesBetween(
          startDate: paramsModel.dateFrom,
          endDate: paramsModel.dateTo,
        );

        // Filter summaries for existing dates
        allDatesSummaryList.addAll(summaryList.where(
            (summary) => allDatesInIso.contains(summary["InvDate"] as String)));

        // Ensure summaries exist for all dates and filters
        for (String filter in paramsModel.multiSelectList ?? []) {
          for (String isoDate in allDatesInIso) {
            // Check if the summary for the current date and filter exists
            bool summaryExists = allDatesSummaryList.any((summary) =>
                summary["InvDate"] == isoDate &&
                summary[paramsModel.multiSelectName!] == filter);

            // If the summary doesn't exist, add a new entry with sale data as 0
            if (!summaryExists) {
              allDatesSummaryList.add({
                "InvDate": isoDate,
                "Gwt": 0.0,
                paramsModel.multiSelectName!: filter,
                "StoneWt": 0.0,
                "NetWt": 0.0,
                "DiaWt": 0.0,
                "Qty": 0.0,
                "MetalCash": 0.0,
                "DiaCash": 0.0,
                "StoneCash": 0.0,
                "VAAfterDisc": 0.0,
                "VAPercAfterDisc": 0.0,
              });
            }
          }
        }

        allDatesSummaryList.sort((a, b) => DateTime.parse(a["InvDate"])
            .compareTo(DateTime.parse(b["InvDate"])));

        return allDatesSummaryList
            .map((e) => SalesSummaryModel.fromJson(e))
            .toList();
      },
    );
  }

  //DATES CONVERT +++++++++++++++
  List<String> getISO8601DatesBetween(
      {required String startDate, required String endDate}) {
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
    DateTime startDateTime = dateFormat.parse(startDate);
    DateTime endDateTime = dateFormat.parse(endDate);

    List<DateTime> allDates = getDatesBetween(startDateTime, endDateTime);

    List<String> isoDatesList =
        allDates.map((date) => date.toIso8601String().split('.')[0]).toList();

    return isoDatesList;
  }

  List<DateTime> getDatesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }
}
