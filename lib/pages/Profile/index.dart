// pages/Profile/index.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../stores/user_store.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();
    final user = userStore.user;

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
          GestureDetector(
            onTap: () {
              if (!userStore.isLoggedIn) {
                // 未登录 → 跳转登录页
                Navigator.pushNamed(context, '/login');
              } else {
                // 已登录 → 可跳转个人主页或切换账号（此处可自定义）
                // 暂时不做操作，或者弹出对话框
              }
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: user != null
                          ? NetworkImage(user.avatar) as ImageProvider
                          : const AssetImage('lib/assets/images/default_avatar.png'),
                      // child: user == null
                      //     ? const Icon(Icons.person, size: 30, color: Colors.grey)
                      //     : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? '未登录',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user != null ? '已登录' : '点击登录',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (user != null)
                      IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () {
                          // 退出登录
                          userStore.logout();
                          // 可显示提示
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已退出登录')),
                          );
                        },
                        tooltip: '退出登录',
                      )
                    else
                      const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 功能列表（保持不变）
          Card(
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
                    // 切换账号：先退出，再跳转登录页
                    userStore.logout();
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title,
      {Color color = Colors.black87, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap ?? () {},
    );
  }
}