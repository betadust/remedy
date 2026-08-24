import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"DIO!",
      home: Container(
        color: Color(0xFFFB7299), // B站粉色,
        alignment: Alignment.center,
        child: Text("简单TEXT"),
      )
    );
  }
}