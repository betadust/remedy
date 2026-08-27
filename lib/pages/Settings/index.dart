// pages/Settings/index.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../stores/settings_store.dart';
import '../../stores/user_store.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsStore = context.watch<SettingsStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '稍后再看推荐数量',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '每天随机推荐 ${settingsStore.watchLaterCount} 个稍后再看视频',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: settingsStore.watchLaterCount.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: '${settingsStore.watchLaterCount}',
                    onChanged: (value) {
                      settingsStore.setWatchLaterCount(value.round());
                    },
                    onChangeEnd: (value) {
                      final userStore = context.read<UserStore>();
                      if (userStore.isLoggedIn) {
                        userStore.loadWatchLater();
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('20', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '首页动态显示天数',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '首页显示最近 ${settingsStore.homeFeedDays} 天内的特别关注动态',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: settingsStore.homeFeedDays.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '${settingsStore.homeFeedDays}',
                    onChanged: (value) {
                      settingsStore.setHomeFeedDays(value.round());
                    },
                    onChangeEnd: (value) {
                      final userStore = context.read<UserStore>();
                      if (userStore.isLoggedIn) {
                        userStore.loadHomeFeed();
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1天', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('30天', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
