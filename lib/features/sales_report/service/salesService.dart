import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error_handling/failure.dart';
import '../../../core/error_handling/type_defs.dart';

final salesServiceProvider = Provider((ref) {
  return SalesService();
});

class SalesService {
  final dio = Dio();

  // to get data to drop down for drop down
  FutureEither<String> getFilterData(
      {required String tableName, required String branchId}) async {
    try {
      final response = await dio.get(
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/dropdown?table=$tableName&branchid=$branchId");
      if (response.statusCode == 400) {
        return right(response.data);
      } else {
        throw "ERROR OCCUR!";
      }
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

  // to get data to show in the GRAPH
  FutureEither<String> getSalesSummery(
      {required String dateFrom,
      required String dateTo,
      String? branchId}) async {
    try {
      final response = await dio.get(
          // "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/SalesSummary?dateFrom=01-dec-2023&dateTo=21-dec-2023&branchid=101");
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/SalesSummary?$dateFrom&$dateTo&branchid=$branchId");
      if (response.statusCode == 400) {
        return right(response.data);
      } else {
        throw "ERROR OCCUR!";
      }
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
