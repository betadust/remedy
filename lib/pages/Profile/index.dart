// pages/Profile/index.dart

import 'package:flutter/material.dart';
import 'package:remedy/components/Profile/UserAvatarCard.dart';
import 'package:remedy/components/Profile/UtilCard.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 用户信息卡片 - 点击跳转登录/切换账号
          UserAvatarCard(),
          const SizedBox(height: 16),
          // 功能列表（保持不变）
          UtilCard(),
        ],
      ),
    );
  }
}