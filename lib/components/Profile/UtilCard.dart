// components/Profile/UtilCard.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stores/user_store.dart';

class UtilCard extends StatelessWidget {
  const UtilCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();

    return Card(
      child: Column(
        children: [
          _buildMenuItem(Icons.history, '历史记录'),
          _buildMenuItem(Icons.download_outlined, '离线缓存'),
          _buildMenuItem(Icons.settings_outlined, '设置'),
          const Divider(height: 1),
          _buildMenuItem(
            Icons.logout,
            '切换账号',
            color: Colors.blue,
            onTap: () {
              userStore.logout();
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  //作为私有静态方法
  static Widget _buildMenuItem(
      IconData icon,
      String title, {
        Color color = Colors.black87,
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap ?? () {},
    );
  }
}