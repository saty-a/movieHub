import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../../liked_movies/views/liked_movies_view.dart';
import '../../search_movies/views/search_movies_view.dart';

class BottomNavController extends GetxController {
  Rx<int> currentIndex = 0.obs;

  final pages = <Widget>[
    const HomeView(),
    const SearchMoviesView(),
    const LikedMoviesView(),
  ];
}
