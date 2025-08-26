import '../../../utils/exception_handler.dart';

/// This file contains the base data transfer objects for API responses.
/// It holds the data and error returned from the network request.

class RepoResponse<T> {
  final APIException? error;
  final T? data;
  RepoResponse({this.error, this.data});
}

class DataWrapper<T> {
  T? data;
  String? error;
  DataWrapper({this.error, this.data});
}
