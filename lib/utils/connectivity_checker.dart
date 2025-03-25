import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityChecker extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  // Initialize connectivity service
  Future<ConnectivityChecker> init() async {
    // Check initial connection status
    checkConnectivity();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      isConnected.value = !result.contains(ConnectivityResult.none);
    });

    return this;
  }

  // Check current connectivity status
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    isConnected.value = !result.contains(ConnectivityResult.none);
    return isConnected.value;
  }
}
