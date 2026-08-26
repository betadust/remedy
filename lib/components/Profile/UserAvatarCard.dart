// components/Profile/UserAvatarCard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_info.dart';
import '../../stores/user_store.dart';

class UserAvatarCard extends StatelessWidget {
  const UserAvatarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();
    final user = userStore.user;

    return GestureDetector(
      onTap: () {
        if (!userStore.isLoggedIn) {
          Navigator.pushNamed(context, '/login');
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _AvatarImage(user: user),
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
                    userStore.logout();
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
    );
  }
}

/// 头像组件：网络图片加载失败时降级显示默认头像
class _AvatarImage extends StatelessWidget {
  final UserInfo? user;
  const _AvatarImage({required this.user});

  @override
  Widget build(BuildContext context) {
    final avatar = user?.avatar ?? '';

    return ClipOval(
      child: SizedBox(
        width: 60,
        height: 60,
        child: avatar.isEmpty
            ? Image.asset(
                'assets/images/default_avatar.png',
                fit: BoxFit.cover,
              )
            : Image.network(
                avatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/default_avatar.png',
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}