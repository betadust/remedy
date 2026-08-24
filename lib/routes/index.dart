//管理路由
import 'package:flutter/material.dart';
import 'package:remedy/pages/Login/index.dart';
import 'package:remedy/pages/Main/index.dart';

// 返回App根级组件
Widget getRootWidget() {
  return MaterialApp(
    //命名路由
    initialRoute: "/",
    routes: getRootRoutes(),
  );
}

Map<String, Widget Function(BuildContext)> getRootRoutes() {
  return {
    "/": (context) => MainPage(), //主页路由
    "/login": (context) => LoginPage() //登录路由
  };
}