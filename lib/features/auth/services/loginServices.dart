import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gramboo_sales_details/core/error_handling/failure.dart';
import 'package:gramboo_sales_details/core/error_handling/type_defs.dart';
import 'package:gramboo_sales_details/models/branch_model.dart';

final authServiceProvider = Provider((ref) {
  return AuthServices();
});

class AuthServices {
  final dio = Dio();
  FutureEither<String> login(
      {required String userName, required String password}) async {
    try {
      final response = await dio.get(
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/"
          "api/usermodels?username=$userName&password=$password");

      if (response.data == true) {
        return right(userName);
      } else {
        throw "Username or password incorrect!";
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

  FutureEither<List<BranchModel>> getUserBranches(
      {required String userName}) async {
    try {
      List<BranchModel> branchList = [];

      final response = await dio.get(
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/api/usermodels/UserBranches/admin");

      for (var i in response.data) {
        branchList.add(BranchModel.fromMap(i));
      }

      return right(branchList);
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
