import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Favorite/index.dart';
import '../Home/index.dart';
import '../Profile/index.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 当前选中的 Tab 索引
  int _currentIndex = 0;
  //页面列表（按顺序对应底部导航的每一项）
  final List<Widget> _pages = const [
    HomePage(),      // 首页
    FavoritePage(),  // 收藏
    ProfilePage(),   // 我的
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("主页"),
      // ),
      body:
        SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
        ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // 3个以上Tab时使用
          items: _getTabBarWidget(),
      ),
    );
  }
}


List<BottomNavigationBarItem> _getTabBarWidget(){
  return [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: '首页',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star_border),
      activeIcon: Icon(Icons.star),
      label: '收藏',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: '我的',
    ),
  ];
}