
import 'package:auth_api_dopave_app/config/api_constants.dart';
import 'package:auth_api_dopave_app/features/articles/model/articles_model.dart';
import 'package:auth_api_dopave_app/services/api_service.dart';
import 'package:auth_api_dopave_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ArticlesModel> articlesList = <ArticlesModel>[].obs;
  final pageController = PageController();
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    getArticles();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Get articles from API
  Future<void> getArticles() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _apiService.postRequest(
      ApiConstants.articlesEndpoint,
      {},
    );

    isLoading.value = false;

    if (response.status) {
      final articlesData = response.data as List<dynamic>;
      articlesList.assignAll(
        articlesData.map((json) => ArticlesModel.fromJson(json)).toList(),
      );
      await _storageService.saveArticlesData(articlesList);
    } else {
      errorMessage.value = response.message ?? 'Failed to load articles data';
      // Try to load cached data if available
      final cachedArticles = _storageService.getArticlesData();
      if (cachedArticles.isNotEmpty) {
        articlesList.assignAll(cachedArticles);
      }
    }
  }

  // Refresh articles data
  Future<void> refreshArticles() async {
    await getArticles();
  }

  // Open article in WebView
  void openArticleWebView(String url) {
    Get.toNamed('/article-webview', arguments: {'url': url});
  }
}
