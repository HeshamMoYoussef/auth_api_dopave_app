import 'package:get/get.dart';
import 'package:auth_api_dopave_app/config/api_constants.dart';
import 'package:auth_api_dopave_app/features/matches/model/match_info_model.dart';
import 'package:auth_api_dopave_app/services/api_service.dart';

class MatchDetailsController extends GetxController {
  final String matchId;
  final ApiService _apiService = Get.find<ApiService>();

  final Rx<MatchInfoModel?> match = Rx<MatchInfoModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  MatchDetailsController({required this.matchId});

  @override
  void onInit() {
    super.onInit();
    getMatchDetails();
  }

  Future<void> getMatchDetails() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.postRequest(
        '${ApiConstants.matchDetailsEndpoint}/$matchId',{}
      );

      if (response.status) {
        match.value = MatchInfoModel.fromJson(response.data);
      } else {
        errorMessage.value = response.message ?? 'فشل تحميل بيانات المباراة';
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات';
    } finally {
      isLoading.value = false;
    }
  }

  
}
