import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'network_exception.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (ConnectivityResult.none == connectivityResult) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: const NetworkException('No internet connection'),
          type: DioExceptionType.connectionError,
        ),
      );
    }

    super.onRequest(options, handler);
  }
}
