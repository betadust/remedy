// pages/Login/index.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/Login/LoginStatusCard.dart';
import '../../components/Login/QrCodeCard.dart';
import '../../stores/user_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
    _userStore = context.read<UserStore>();
    // 监听登录状态，成功后跳转主页
    _userStore.addListener(_handleStoreChanged);
    // 延迟到当前 build 结束后再生成二维码，避免在 build 阶段同步 notifyListeners
    Future.microtask(_userStore.generateQrCode);
  }

  void _handleStoreChanged() {
    if (!mounted) return;
    if (_userStore.isLoggedIn) {
      // 只跳转一次：立即移除监听，避免 loadFavorites 等后续 notify 再次触发 pop
      _userStore.removeListener(_handleStoreChanged);
      // 直接返回来源页（MainPage），避免 pushReplacement 压入新的页面实例导致返回箭头
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _userStore.removeListener(_handleStoreChanged);
    _userStore.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫码登录'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '使用哔哩哔哩App扫码登录',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              QrCodeCard(),
              SizedBox(height: 20),
              LoginStatusCard(),
            ],
          ),
        ),
      ),
    );
  }
}
