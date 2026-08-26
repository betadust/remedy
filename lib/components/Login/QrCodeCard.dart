// components/Login/QrCodeCard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../stores/user_store.dart';

class QrCodeCard extends StatelessWidget {
  const QrCodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();
    final qrUrl = userStore.qrUrl;

    Widget content;
    if (userStore.isGenerating) {
      content = const CircularProgressIndicator();
    } else if (qrUrl != null && qrUrl.isNotEmpty) {
      content = QrImageView(
        data: qrUrl,
        version: QrVersions.auto,
        size: 200,
        gapless: false,
      );
    } else {
      content = const Text('无法生成二维码，请重试');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: content),
      ),
    );
  }
}
