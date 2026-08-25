// components/Profile/UserAvatarCard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../stores/user_store.dart';

class UserAvatarCard extends StatelessWidget {
  const UserAvatarCard({super.key});

  /// 根据头像路径返回对应的 ImageProvider
  ImageProvider _getAvatarImage(UserInfo? user) {
    // 未登录或头像为空 → 使用默认头像
    if (user == null || user.avatar.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    }

    final avatarPath = user.avatar;

    // 如果是本地资源路径（以 assets/ 开头）→ 使用 AssetImage
    if (avatarPath.startsWith('assets/')) {
      return AssetImage(avatarPath);
    }

    // 否则当作网络 URL → 使用 NetworkImage
    return NetworkImage(avatarPath);
  }

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
              CircleAvatar(
                radius: 30,
                backgroundImage: _getAvatarImage(user), // ✅ 调用工具函数
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