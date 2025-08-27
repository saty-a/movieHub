import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moviehub/app/utils/constants.dart';

import '../data/models/response/error_response.dart';

/// This class is used to handle Dio exceptions.

class APIException implements Exception {
  final dynamic message;
  final bool isInternetDisconnected;

  APIException({required this.message, this.isInternetDisconnected = false});
}

class ExceptionHandler {
  ExceptionHandler._privateConstructor();

  static APIException handleError(Exception error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.sendTimeout:
          return APIException(message: Constants.noInternet);
        case DioExceptionType.connectionTimeout:
          return APIException(message: Constants.connectionTimeout);
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 422) {
            return APIException(
                message: ErrorResponse.fromJson(error.response?.data));
          } else if (error.response?.statusCode == 401) {
            // handle logout here
            return APIException(message: Constants.sessionExpired);
          } else {
            return APIException(
                message: ErrorResponse.fromJson(error.response?.data).message);
          }
        case DioExceptionType.unknown:
          if (error.message!.contains('SocketException')) {
            return APIException(
                message: Constants.noInternet,
                isInternetDisconnected: true);
          }
          return APIException(message: error.message);
        default:
          return APIException(message: Constants.networkGeneral);
      }
    } else {
      return APIException(message: Constants.networkGeneral);
    }
  }
}

class HandleError {
  HandleError._privateConstructor();

  static handleError(APIException? error) {
    Get.rawSnackbar(message: error?.message ?? Constants.networkGeneral);
  }
}
