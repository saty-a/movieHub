import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/app_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  Get.put(storageService, permanent: true);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
    ),
  );
}
