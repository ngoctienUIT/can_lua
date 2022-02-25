import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const SettingPage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(
        body: Center(
          child: Text('Setting'),
        ),
      ),
    );
  }
}
