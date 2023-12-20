import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gramboo_sales_details/core/error_handling/failure.dart';
import 'package:gramboo_sales_details/core/error_handling/type_defs.dart';

final authServiceProvider = Provider((ref) {
  return AuthServices();
});

class AuthServices {
  final dio = Dio();
  FutureVoid login({required String userName, required String password}) async {
    try {
      final response = await dio.get(
          "http://viewproduct-env.eba-smbpywd9.ap-south-1.elasticbeanstalk.com/"
          "api/usermodels?username=$userName&password=$password");

      if (response.data == true) {
        return right(null);
      } else {
        throw "Username or password incorrect!";
      }
    } catch (e) {
      if (e is DioException) {
        return left(
          Failure(
            errMSg: e.toString(),
          ),
        );
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
