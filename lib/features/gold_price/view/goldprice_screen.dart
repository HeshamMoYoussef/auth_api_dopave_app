import 'package:auth_api_dopave_app/features/gold_price/controller/gold_price_controller.dart';
import 'package:auth_api_dopave_app/features/gold_price/model/gold_price_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoldPriceScreen extends GetView<GoldPriceController> {
  const GoldPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<GoldPriceController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('أسعار الذهب'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshPrices(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.fetchGoldPrices(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Last updated time
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '  آخر تحديث:  ${controller.lastUpdated.value}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            // Prices list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshPrices(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.goldPrices.length,
                  itemBuilder: (context, index) {
                    final goldPrice = controller.goldPrices[index];
                    return _buildPriceCard(controller, goldPrice);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPriceCard(
    GoldPriceController controller,
    GoldPriceModel goldPrice,
  ) {
    final hasIncreased = controller.hasPriceIncreased(goldPrice.name);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gold type name
            Text(
              goldPrice.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Prices row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriceColumn(
                  'البيع',
                  goldPrice.sell,
                  Colors.red,
                  hasIncreased,
                ),
                _buildPriceColumn(
                  'الشراء',
                  goldPrice.buy,
                  Colors.green,
                  hasIncreased,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceColumn(
    String label,
    String price,
    Color color,
    bool? hasIncreased,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (hasIncreased != null) ...[
              const SizedBox(width: 4),
              Icon(
                hasIncreased ? Icons.arrow_upward : Icons.arrow_downward,
                color: hasIncreased ? Colors.green : Colors.red,
                size: 20,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
