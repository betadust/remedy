// stores/settings_store.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App 级设置（不依赖登录态）
class SettingsStore extends ChangeNotifier {
  static const String _watchLaterCountKey = 'watch_later_count';

  int _watchLaterCount = 10;

  int get watchLaterCount => _watchLaterCount;

  /// 启动时从本地恢复设置
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _watchLaterCount = (prefs.getInt(_watchLaterCountKey) ?? 10).clamp(1, 20);
    notifyListeners();
  }

  /// 更新推荐数量并持久化
  Future<void> setWatchLaterCount(int count) async {
    _watchLaterCount = count.clamp(1, 20);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_watchLaterCountKey, _watchLaterCount);
  }
}
