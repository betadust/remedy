// pages/Settings/index.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
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
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
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
                      Text('1', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      Text('20', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
