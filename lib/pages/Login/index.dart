// pages/Login/index.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../stores/user_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _qrUrl;
  bool _isGenerating = false;
  late UserStore _userStore;  // ✅ 保存引用

  @override
  void initState() {
    super.initState();
    _userStore = context.read<UserStore>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateQrCode();
    });
  }

  @override
  void dispose() {
    // 页面销毁时停止轮询，释放资源
    _userStore.stopPolling();
    super.dispose();
  }

  /// 生成二维码（UI 层只调用 Store 的方法）
  Future<void> _generateQrCode() async {
    // 重置 UI 状态
    setState(() {
      _isGenerating = true;
      _qrUrl = null;
    });

    try {

      // 如果有旧轮询先停止
      _userStore.stopPolling();

      // 生成二维码（返回 URL）
      print("MAN！ UI生成二维码");
      final url = await _userStore.generateQrCode();
      print("MAN! URL: $url");
      setState(() {
        _qrUrl = url;
        _isGenerating = false;
      });

      // 二维码显示后启动轮询
      print("MAN！ UI开始轮询");
      Future.microtask(() {
        _userStore.startPolling();
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('生成二维码失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();
    final status = userStore.qrLoginStatus;

    // 登录成功 -> 自动跳转主页
    if (userStore.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/profile');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('扫码登录'),
        backgroundColor: Colors.pink.shade50,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '使用哔哩哔哩App扫码登录',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // 二维码区域
              if (_isGenerating)
                const CircularProgressIndicator()
              else if (_qrUrl != null)
                QrImageView(
                  data: _qrUrl!,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                )
              else
                const Text('无法生成二维码，请重试'),

              const SizedBox(height: 20),

              // 状态文字
              Text(
                status.isNotEmpty ? status : '请打开哔哩哔哩App扫码',
                style: TextStyle(
                  fontSize: 16,
                  color: status.contains('成功') ? Colors.green : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // 重新获取按钮（当过期或失败时显示）
              if (status.contains('过期') || status.contains('失败') || status.contains('异常'))
                ElevatedButton(
                  onPressed: _generateQrCode,
                  child: const Text('重新获取二维码'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}