import 'package:auth_api_dopave_app/features/articles/controller/articles_controller.dart';
import 'package:auth_api_dopave_app/features/articles/view/widgets/article_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesScreen extends GetView<ArticlesController> {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ArticlesController>();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.refreshArticles,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.articlesList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshArticles,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.articlesList.isEmpty) {
            return Center(child: Text('No articles available'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.articlesList.length,
            itemBuilder: (context, index) {
              return ArticleCardWidget(
                article: controller.articlesList[index],
                onTap:
                    () => controller.openArticleWebView(
                      controller.articlesList[index].url,
                    ),
              );
            },
          );
        }),
      ),
    );
  }
}
