import 'dart:convert';

import 'package:auth_api_dopave_app/config/app_constants.dart';
import 'package:auth_api_dopave_app/features/articles/model/articles_model.dart';
import 'package:auth_api_dopave_app/features/matches/model/matches_model.dart';
import 'package:auth_api_dopave_app/features/auth/model/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  final _storage = GetStorage();

  // Initialize storage service
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  // Save auth token
  Future<void> saveToken(String token) async {
    await _storage.write(AppConstants.tokenKey, token);
  }

  // Get auth token
  String? getToken() {
    return _storage.read<String>(AppConstants.tokenKey);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return getToken() != null;
  }

  // Save user data
  Future<void> saveUserData(UserModel user) async {
    // convert user object to json string and save to storage
    await _storage.write(AppConstants.userDataKey, jsonEncode(user.toJson()));
  }

  // Get user data
  UserModel? getUserData() {
    final userData = _storage.read<String>(AppConstants.userDataKey);
    if (userData != null) {
      // convert json string to user object and return
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Save matches data
  Future<void> saveMatchesData(List<MatchesModel> matches) async {
    // convert matches object to json string and save to storage
    await _storage.write(
      AppConstants.matchesDataKey,
      jsonEncode(matches.map((match) => match.toJson()).toList()),
    );
  }
  // Save save Articles Data 
  Future<void> saveArticlesData(List<ArticlesModel> articles) async {
    // convert articles object to json string and save to storage
    await _storage.write(
      AppConstants.matchesDataKey,
      jsonEncode(articles.map((article) => article.toJson()).toList()),
    );
  }

    // Save save Articles Data
  List<ArticlesModel> getArticlesData() {
    final articlesData = _storage.read<String>(AppConstants.matchesDataKey);
    if (articlesData != null) {
      // convert json string to articles object and return
      return (jsonDecode(articlesData) as List<dynamic>)
          .map((json) => ArticlesModel.fromJson(json))
          .toList();
    }
    return [];
  }


  
}
