import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/utilities/custom_snackBar.dart';
import 'package:gramboo_sales_details/features/sales_report/service/salesService.dart';
import 'package:gramboo_sales_details/models/metalType_model.dart';

final salesControllerProvider = NotifierProvider<SalesController, bool>(
  () => SalesController(),
);

final metalTypeListProvider = StateProvider<List<MetalTypeModel>>((ref) {
  return [];
});

final itemListProvider = StateProvider<List>((ref) {
  return [];
});

final categoryListProvider = StateProvider<List>((ref) {
  return [];
});

final modelListProvider = StateProvider<List>((ref) {
  return [];
});

final measurmentListProvider = StateProvider<List>((ref) {
  return [];
});

final salesTypeListProvider = StateProvider<List>((ref) {
  return [];
});

final salesManListProvider = StateProvider<List>((ref) {
  return [];
});

class SalesController extends Notifier<bool> {
  SalesController();

  @override
  build() {
    return false;
  }

  getFilterData(
      {required String tableName,
      required int branchId,
      required BuildContext context}) async {
    final res = await ref
        .read(salesServiceProvider)
        .getFilterData(tableName: tableName, branchId: branchId);

    res.fold(
        (l) => showSnackBar(
            content: l.errMSg,
            context: context,
            color: Colors.red), (dropDownList) {
      if (tableName == "MetalType") {
        ref.read(metalTypeListProvider.notifier).state =
            dropDownList.map((e) => MetalTypeModel.fromMap(e)).toList();
      }
    });
  }
}
