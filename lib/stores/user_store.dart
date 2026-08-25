// stores/user_store.dart
import 'package:flutter/material.dart';

// 用户信息模型（简化版）
class UserInfo {
  final String name;
  final String avatar;
  final String uid;

  UserInfo({required this.name, required this.avatar, required this.uid});

  // 模拟从 JSON 解析
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] ?? 'B站用户',
      avatar: json['avatar'] ?? 'assets/images/default_avatar.png',
      uid: json['uid'] ?? '',
    );
  }
}

class UserStore extends ChangeNotifier {
  UserInfo? _user;

  bool get isLoggedIn => _user != null;

  UserInfo? get user => _user;

  // 登录方法（模拟异步请求）
  Future<void> login(String username, String password) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    // 模拟验证：只接受特定账号
    if (username == 'bili' && password == '123456') {
      // 模拟从接口返回的用户信息
      _user = UserInfo(
        name: 'B站用户_' + DateTime.now().millisecond.toString(),
        avatar: 'assets/images/74330797_p0.png', // ✅ 改用本地图片路径
        uid: '10086',
      );
    } else {
      throw Exception('账号或密码错误');
    }
    notifyListeners();
  }

  // 登出方法
  void logout() {
    _user = null;
    notifyListeners();
  }

  // 切换账号（直接登出，由 UI 引导重新登录）
  void switchAccount() {
    logout();
  }
}