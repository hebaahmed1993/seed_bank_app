class FirestorePaths {
  FirestorePaths._(); // يمنع إنشاء نسخة من الكلاس

  // الجداول الأساسية
  static const String users = 'users';
  static const String products = 'products';
  static const String orders = 'orders';
  static const String suppliers = 'suppliers';
  static const String categories = 'categories';
  static const String favorites = 'favorites';
  static const String homeSections = 'home_sections';
  // الإعدادات والثوابت
  static const String appSettings = 'appSettings';
  static const String accountTypes = 'accountTypes';
  static const String cancelReasons = 'cancelReasons';
  static const String cities = 'cities';
  static const String regions = 'regions';
  static const String deliveryFees = 'deliveryFees';
  static const String orderStatuses = 'orderStatuses';
  static const String paymentMethods = 'paymentMethods';
  static const String permissions = 'permissions';

  // السجلات والحركات
  static const String activityLogs = 'activity_logs';
  static const String inventoryMovements = 'inventoryMovements';
}