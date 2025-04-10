import 'package:auth_api_dopave_app/config/api_constants.dart';
import 'package:auth_api_dopave_app/config/app_constants.dart';
import 'package:auth_api_dopave_app/services/api_response_model.dart';
import 'package:auth_api_dopave_app/services/storage_service.dart';
import 'package:auth_api_dopave_app/utils/connectivity_checker.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiService extends GetConnect implements GetxService {
  late Dio _dio;
  final ConnectivityChecker _connectivityChecker =
      Get.find<ConnectivityChecker>();
  final RxBool isLoading = false.obs;

  // Initialize API service
  Future<ApiService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    // Add request interceptor for authentication token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Get token from storage service
          final token = Get.find<StorageService>().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized error (logout user)
            Get.find<StorageService>().clearAll();
            // Navigate to login screen
            Get.offAllNamed('/login');
            return handler.next(error);
          }
          return handler.next(error);
        },
      ),
    );

    return this;
  }

  // Generic POST method for all API requests
  Future<ApiResponse> postRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    isLoading.value = true;

    try {
      // Check connectivity before making request
      if (!await _connectivityChecker.checkConnectivity()) {
        isLoading.value = false;
        return ApiResponse(status: false, message: AppConstants.networkError);
      }

      final response = await _dio.post(endpoint, data: data);
      isLoading.value = false;

      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      isLoading.value = false;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiResponse(status: false, message: AppConstants.networkError);
      }

      if (e.response != null) {
        return ApiResponse.fromJson(e.response!.data);
      }

      return ApiResponse(status: false, message: AppConstants.serverError);
    } catch (e) {
      isLoading.value = false;
      return ApiResponse(status: false, message: AppConstants.unknownError);
    }
  }
}
