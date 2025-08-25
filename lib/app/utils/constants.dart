import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String trendingMovies = '$baseUrl/trending/all/day?language=en-US';
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const Duration sendTimeout = Duration(seconds: 30);
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String apiKey = 'b8735916ebe69a988e7a757928558cf0';

  static const backgroundColor = Color(0xff010101);
  static const bottomNavigationBarColor = Color(0xff121212);
  static const bottomSheetColor = Color(0xff2b2b2b);
  static const bottomSheetIconColor = Color(0xff3d3d3d);
  static const redColor = Color(0xffe50914);

  static const profileColors = [
    Colors.amber,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple
  ];

  /// Errors
  static const unauthorized = 'You are not authorized';
  static const noInternet = 'Please check your internet connection';
  static const connectionTimeout = 'Please check your internet connection';
  static const networkGeneral =
      'Something went wrong.\nPlease try again later.';
  static const invalidPhone = 'Invalid Mobile number';
  static const invalidOTP = 'Invalid OTP';
  static const invalidName = 'Invalid Name';
  static const sessionExpired =
      "Your session has been expired.Please log in again";
}
