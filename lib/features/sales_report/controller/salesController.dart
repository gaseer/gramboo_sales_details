import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/utilities/custom_snackBar.dart';
import 'package:gramboo_sales_details/features/sales_report/service/salesService.dart';
import 'package:gramboo_sales_details/models/MeasurementModel.dart';
import 'package:gramboo_sales_details/models/categoryModel.dart';
import 'package:gramboo_sales_details/models/itemModel.dart';
import 'package:gramboo_sales_details/models/metalType_model.dart';
import 'package:gramboo_sales_details/models/modelItem_model.dart';
import 'package:gramboo_sales_details/models/salesSummary_model.dart';
import 'package:gramboo_sales_details/models/salesTypeModel.dart';
import 'package:gramboo_sales_details/models/salesmanModel.dart';

final salesControllerProvider = NotifierProvider<SalesController, bool>(
  () => SalesController(),
);

final salesSummaryProvider =
    FutureProvider.family<List<SalesSummaryModel>, String>(
        (ref, parameters) async {
  final decodedMap = jsonDecode(parameters);

  final dateFrom = decodedMap["dateFrom"];
  final dateTo = decodedMap["dateTo"];
  final branchId = decodedMap["branchId"];
  final itemCategory = decodedMap["itemCategory"];

  return ref.read(salesControllerProvider.notifier).getSalesSummary(
      dateFrom: dateFrom,
      dateTo: dateTo,
      branchId: branchId,
      itemCategory: itemCategory);
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
    required String dateFrom,
    required String dateTo,
    String? branchId,
    String? itemCategory,
  }) async {
    final res = await ref.read(salesServiceProvider).getSalesSummery(
        branchId: branchId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        itemCategory: itemCategory);
    return res.map((e) => SalesSummaryModel.fromJson(e)).toList();
  }
}
