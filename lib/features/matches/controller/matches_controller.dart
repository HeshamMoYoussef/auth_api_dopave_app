import 'package:auth_api_dopave_app/config/api_constants.dart';
import 'package:auth_api_dopave_app/features/matches/model/matches_model.dart';
import 'package:auth_api_dopave_app/services/api_service.dart';
import 'package:auth_api_dopave_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MatchesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<MatchesModel> matchesList = <MatchesModel>[].obs;
  final RxString selectedDate = ''.obs; // Track selected date
  final box = GetStorage();
  final pageController = PageController();
  int index = 0;
  @override
  void onInit() {
    super.onInit();
    // Load initial matches data with today's date
    final today = DateTime.now();
    selectedDate.value = _formatDate(today);
    getMatches(selectedDate.value);
  }

  // Format date as DD-MM-YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  // Get matches with optional date parameter
  Future<void> getMatches([String? date]) async {
    isLoading.value = true;
    errorMessage.value = '';

    // Use provided date or selected date
    final requestDate = date ?? selectedDate.value;

    final response = await _apiService.postRequest(
      '${ApiConstants.matchesEndpoint}?date=$requestDate',
      {},
    );

    isLoading.value = false;

    if (response.status) {
      final matchesData = response.data as List<dynamic>;
      matchesList.assignAll(
        matchesData.map((json) => MatchesModel.fromJson(json)).toList(),
      );
      await _storageService.saveMatchesData(matchesList);
      selectedDate.value = requestDate; // Update selected date
    } else {
      errorMessage.value = response.message ?? 'Failed to load matches data';
    }
  }

  // Refresh matches data with current selected date
  Future<void> refreshMatches() async {
    await getMatches(selectedDate.value);
  }

  // Change date and load matches
  Future<void> changeDate(DateTime newDate) async {
    final formattedDate = _formatDate(newDate);
    await getMatches(formattedDate);
  }


}

