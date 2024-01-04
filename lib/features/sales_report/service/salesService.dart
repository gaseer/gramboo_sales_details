import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gramboo_sales_details/features/sales_report/data/multiSelectType.dart';
import 'package:gramboo_sales_details/models/salesSummaryParamModel.dart';

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
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/dropdown?table=$tableName&branchid=$branchId");

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
        return left(
          Failure(
            errMSg: e.toString(),
          ),
        );
      }
    }
  }

  FutureEither<List<Map<String, dynamic>>> getSalesSummary(
      {required SalesSummaryParamsModel parameters}) async {
    try {
      String url =
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/"
          "SalesSummary?dateFrom=${parameters.dateFrom}&dateTo=${parameters.dateTo}&branchid=${parameters.branchId}";
      //item name filter set
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == MultiSelectType.itemName) {
        String itemNameParams =
            parameters.multiSelectList!.map((itemName) => itemName).join(',');
        url += '&itemNAme=$itemNameParams';
      }
      //category name filter set
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == MultiSelectType.categoryName) {
        String itemCategoryParams = parameters.multiSelectList!
            .map((itemCategoryName) => itemCategoryName.trim())
            .join(',');
        url += '&itemCategory=$itemCategoryParams';
      }

      //measurement type filter (radius inch not in json)
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == MultiSelectType.measurementType) {
        String measurementNameParams = parameters.multiSelectList!
            .map((measurementName) => measurementName.trim())
            .join(',');
        url += '&MeasurementType=$measurementNameParams';
      }

      //metal type filter set

      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == MultiSelectType.metalType) {
        print(parameters.multiSelectList);

        String metalTypeParams = parameters.multiSelectList!
            .map((metalType) => metalType.trim())
            .join(',');
        url += '&MetalType=$metalTypeParams';
      }

      //model name filter (model Id {} modelName {})
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == MultiSelectType.modelName) {
        String modelNameParams = parameters.multiSelectList!
            .map((modelName) => modelName.trim())
            .join(',');
        url += '&ModelName=$modelNameParams';
      }

      //salesman id filter

      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == MultiSelectType.salesManId) {
        String salesManIdParams = parameters.multiSelectList![0];
        // String salesManIdParams = parameters.multiSelectList!
        //     .map((salesManId) => salesManId.trim())
        //     .join(',');
        url += '&SalesmanID=$salesManIdParams';
      }

      //sales mode filter (empty data)

      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == MultiSelectType.salesType) {
        String salesModeParams = parameters.multiSelectList![0];
        url += '&SalesMode=$salesModeParams';
      }

      print("UUUUUURRRRRRLLLLLLLLL");
      print(url.trim());

      //base url
      // "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/SalesSummary?dateFrom=01-dec-2023&dateTo=21-dec-2023&branchid=101"

      final response = await dio.get(url);
      List<Map<String, dynamic>> castedList =
          response.data.cast<Map<String, dynamic>>();

      return right(castedList);
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw "Error:- ${e.response!.statusCode}";
        } else {
          throw e.message!;
        }
      } else {
        return left(
          Failure(
            errMSg: e.toString(),
          ),
        );
      }
    }
  }
}
