import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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

  FutureEither<List> getSalesSummary(
      {required SalesSummaryParamsModel parameters}) async {
    try {
      String url =
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/"
          "SalesSummary?dateFrom=${parameters.dateFrom}&dateTo=${parameters.dateTo}&branchid=${parameters.branchId}";

      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == "item") {
        String itemNameParams =
            parameters.multiSelectList!.map((itemName) => itemName).join(',');
        url += '&itemNAme=$itemNameParams';
      }

      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == "category") {
        String itemCategoryParams = parameters.multiSelectList!
            .map((itemCategoryName) => itemCategoryName.trim())
            .join(',');
        url += '&itemCategory=$itemCategoryParams';
      }
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == "measurement") {
        String measurementNameParams = parameters.multiSelectList!
            .map((measurementName) => measurementName.trim())
            .join(',');
        url += '&MeasurementType=$measurementNameParams';
      }
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == "metal") {
        String metalTypeParams = parameters.multiSelectList!
            .map((metalType) => metalType.trim())
            .join(',');
        url += '&MetalType=$metalTypeParams';
      }
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == "model") {
        String modelNameParams = parameters.multiSelectList!
            .map((modelName) => modelName.trim())
            .join(',');
        url += '&ModelName=$modelNameParams';
      }

      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == "salesman") {
        String salesManIdParams = parameters.multiSelectList!
            .map((salesManId) => salesManId.trim())
            .join(',');
        url += '&SalesmanID=$salesManIdParams';
      }
      if (parameters.multiSelectName != null &&
          parameters.multiSelectName == "salesType") {
        String salesModeParams = parameters.multiSelectList![0];
        url += '&SalesMode=$salesModeParams';
      }
      // if (parameters.multiSelectName != null &&
      //     parameters.multiSelectName == "salesMode") {
      //   String salesCategoryParams = parameters.salesCategory![0];
      //   url += '&SalesMode=$salesCategoryParams';
      // }

      //
      // if (measurementName != null && itemName.isNotEmpty) {
      //   for (int i = 0; i < itemName.length; i++) {
      //     if (i == 0) {
      //       url += "&itemNAme=${itemName[i]}";
      //     } else {
      //       url += ",${itemName[i]}";
      //     }
      //   }
      // }
      // if (metalType != null && metalType.isNotEmpty) {
      //   url += "&MetalType=$metalType";
      // }
      //
      // if (modelName != null && modelName.isNotEmpty) {
      //   url += "&ModelName=$modelName";
      // }
      // if (salesManId != null && salesManId.isNotEmpty) {
      //   url += "&SalesManID=$salesManId";
      // }
      // if (measurementName != null && measurementName.isNotEmpty) {
      //   url += "&MeasurementName=$measurementName";
      // }
      // if (salesMode != null && salesMode.isNotEmpty) {
      //   url += "&SalesMode=$salesMode";
      // }
      print("UUUUUUUU");
      print(url.trim());

      //base url
      // "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/SalesSummary?dateFrom=01-dec-2023&dateTo=21-dec-2023&branchid=101"

      final response = await dio.get(url);

      return right(response.data);
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
}
