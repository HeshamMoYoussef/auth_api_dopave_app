import 'package:auth_api_dopave_app/config/api_constants.dart';
import 'package:auth_api_dopave_app/features/gold_price/model/gold_price_model.dart';
import 'package:auth_api_dopave_app/services/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GoldPriceController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<GoldPriceModel> goldPrices = <GoldPriceModel>[].obs;
  final RxString lastUpdated = ''.obs;
  final RxMap<String, double> previousPrices = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGoldPrices();
  }

  Future<void> fetchGoldPrices() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Store current prices as previous prices before updating
      for (var price in goldPrices) {
        previousPrices[price.name] = double.tryParse(price.sell) ?? 0;
      }

      final response = await _apiService.postRequest(
        ApiConstants.goldPricesEndpoint,
        {},
      );

      if (response.status) {
        final pricesData = response.data as List<dynamic>;
        goldPrices.assignAll(
          pricesData.map((json) => GoldPriceModel.fromJson(json)).toList(),
        );
        lastUpdated.value = DateFormat('HH:mm:ss').format(DateTime.now());
      } else {
        errorMessage.value = response.message ?? 'Failed to load gold prices';
      }
    } catch (e) {
      errorMessage.value = 'Network error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  // Helper to check if price increased
  bool hasPriceIncreased(String goldType) {
    final current =
        double.tryParse(
          goldPrices.firstWhere((p) => p.name == goldType).sell,
        ) ??
        0;
    final previous = previousPrices[goldType] ?? 0;
    return current > previous;
  }

  Future<void> refreshPrices() async {
    await fetchGoldPrices();
  }
}
