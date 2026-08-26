// components/Login/LoginStatusCard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stores/user_store.dart';

class LoginStatusCard extends StatelessWidget {
  const LoginStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();
    final status = userStore.qrLoginStatus;

    final needRefresh =
        status.contains('过期') || status.contains('失败') || status.contains('异常');

    return Column(
      children: [
        Text(
          status.isNotEmpty ? status : '请打开哔哩哔哩App扫码',
          style: TextStyle(
            fontSize: 16,
            color: status.contains('成功') ? Colors.green : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        if (needRefresh) ...[
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => userStore.generateQrCode(),
            child: const Text('重新获取二维码'),
          ),
        ],
      ],
    );
  }
}
