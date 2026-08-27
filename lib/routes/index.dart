//管理路由
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remedy/pages/Login/index.dart';
import 'package:remedy/pages/Main/index.dart';
import 'package:remedy/pages/Settings/index.dart';
import '../stores/settings_store.dart';
import '../stores/user_store.dart';


// 返回App根级组件（已注册 Provider）
Widget getRootWidget() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingsStore()..load()),
      ChangeNotifierProvider(
        create: (ctx) => UserStore(settingsStore: ctx.read<SettingsStore>()),
      ),
    ],
    child: MaterialApp(
      //命名路由
      initialRoute: "/",
      routes: getRootRoutes(),
    ),
  );
}

Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    "/": (context) => MainPage(), //首页路由
    "/login": (context) => LoginPage(), //登录路由
    "/settings": (context) => SettingsPage(), //设置路由
  };
}
