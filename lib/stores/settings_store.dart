// stores/settings_store.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App 级设置（不依赖登录态）
class SettingsStore extends ChangeNotifier {
  static const String _watchLaterCountKey = 'watch_later_count';
  static const String _homeFeedDaysKey = 'home_feed_days';

  int _watchLaterCount = 10;
  int _homeFeedDays = 7;

  int get watchLaterCount => _watchLaterCount;
  int get homeFeedDays => _homeFeedDays;

  /// 启动时从本地恢复设置
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _watchLaterCount = (prefs.getInt(_watchLaterCountKey) ?? 10).clamp(1, 20);
    _homeFeedDays = (prefs.getInt(_homeFeedDaysKey) ?? 7).clamp(1, 30);
    notifyListeners();
  }

  /// 更新推荐数量并持久化
  Future<void> setWatchLaterCount(int count) async {
    _watchLaterCount = count.clamp(1, 20);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_watchLaterCountKey, _watchLaterCount);
  }

  /// 更新首页动态显示天数并持久化
  Future<void> setHomeFeedDays(int days) async {
    _homeFeedDays = days.clamp(1, 30);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_homeFeedDaysKey, _homeFeedDays);
  }
}
