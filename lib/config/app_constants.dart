class AppConstants {
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String matchesDataKey = 'matches_data';
  static const String articlesDataKey = 'articles_data';

  // App messages
  static const String networkError = 'تحقق من اتصالك بالإنترنت';
  static const String serverError = 'حدث خطأ في الخادم';
  static const String unknownError = 'حدث خطأ غير متوقع';

  // Validation messages
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidPhone = 'رقم الهاتف غير صالح';
  static const String invalidCode = 'الكود غير صالح';
  static const String passwordTooShort = 'كلمة المرور قصيرة جدًا';
}
