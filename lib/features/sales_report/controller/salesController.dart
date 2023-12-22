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
import 'package:gramboo_sales_details/models/salesTypeModel.dart';
import 'package:gramboo_sales_details/models/salesmanModel.dart';

final salesControllerProvider = NotifierProvider<SalesController, bool>(
  () => SalesController(),
);

class SalesController extends Notifier<bool> {
  SalesController();

  @override
  build() {
    return false;
  }

  Future<List<MetalTypeModel>> getMetalTypeData({required int branchId}) async {
    List<MetalTypeModel> metalList = [];

    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "MetalType", branchId: branchId);

    res.fold((l) {}, (dropDownList) {
      metalList = dropDownList.map((e) => MetalTypeModel.fromMap(e)).toList();
    });
    return metalList;
  }

  Future<List<MeasurementModel>> getMeasurementList(
      {required int branchId, required BuildContext context}) async {
    List<MeasurementModel> metalList = [];

    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Measurement", branchId: branchId);

    res.fold((l) {
      showSnackBar(content: l.errMSg, context: context, color: Colors.red);
    }, (dropDownList) {
      metalList = dropDownList.map((e) => MeasurementModel.fromMap(e)).toList();
    });
    return metalList;
  }

  Future<List<ItemModel>> getItemList(
      {required int branchId, required BuildContext context}) async {
    List<ItemModel> metalList = [];

    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Item", branchId: branchId);

    res.fold((l) {
      showSnackBar(content: l.errMSg, context: context, color: Colors.red);
    }, (dropDownList) {
      metalList = dropDownList.map((e) => ItemModel.fromMap(e)).toList();
    });
    return metalList;
  }

  Future<List<SalesmanModel>> getSalesmanList(
      {required int branchId, required BuildContext context}) async {
    List<SalesmanModel> metalList = [];

    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: "Salesman", branchId: branchId);

    res.fold((l) {
      showSnackBar(content: l.errMSg, context: context, color: Colors.red);
    }, (dropDownList) {
      metalList = dropDownList.map((e) => SalesmanModel.fromMap(e)).toList();
    });
    return metalList;
  }
}
