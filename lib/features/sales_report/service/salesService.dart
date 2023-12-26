import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gramboo_sales_details/models/metalType_model.dart';

import '../../../core/error_handling/failure.dart';
import '../../../core/error_handling/type_defs.dart';

final salesServiceProvider = Provider((ref) {
  return SalesService();
});

class SalesService {
  final dio = Dio();

  // to get data to drop down for drop down
  FutureEither<List> getFilterData(
      {required String tableName, required int branchId}) async {
    List dropDownValueList = [];

    try {
      final response = await dio.get(
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/"
          "dropdown?table=$tableName&branchid=$branchId");

      if (response.statusCode == 200) {
        final responseDecodedData = response.data;

        for (var i in responseDecodedData) {
          dropDownValueList.add(i);
        }

        return right(dropDownValueList);
      } else {
        throw "ERROR OCCUR!";
      }
    } catch (e, stackTrace) {
      if (e is DioException) {
        if (e.response != null) {
          throw "Error:- ${e.response!.statusCode}";
        } else {
          throw e.message!;
        }
      } else {
        print(stackTrace);
        return left(
          Failure(
            errMSg: e.toString(),
          ),
        );
      }
    }
  }

  // to get data to show in the GRAPH
  Future<List> getSalesSummery(
      {required String dateFrom,
      required String dateTo,
      String? branchId,
      String? itemCategory}) async {
    print("sales summary function worked");

    String url =
        "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/SalesSummary?dateFrom=$dateFrom&dateTo=$dateTo&branchid=$branchId";

    if (itemCategory != null && itemCategory.isNotEmpty) {
      url += "&itemCategory=$itemCategory";
    }

    //base url
    // "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/SalesSummary?dateFrom=01-dec-2023&dateTo=21-dec-2023&branchid=101"

    final response = await dio.get(url);
    print(response.data);

    return response.data;
  }
}
