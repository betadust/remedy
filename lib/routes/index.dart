//管理路由
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remedy/pages/Login/index.dart';
import 'package:remedy/pages/Main/index.dart';
import 'package:remedy/pages/Profile/index.dart';
import '../stores/user_store.dart';


// 返回App根级组件（已注册 Provider）
Widget getRootWidget() {
  return ChangeNotifierProvider(
    create: (_) => UserStore(), // 创建 UserStore 实例
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
    "/profile" : (context) => ProfilePage(), //“我的”路由
  };
}