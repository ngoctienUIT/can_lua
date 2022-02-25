import 'package:can_lua/pages/account/account_page.dart';
import 'package:can_lua/pages/change_password/change_password_page.dart';
import 'package:can_lua/pages/home/drawer_widget.dart';
import 'package:can_lua/pages/home/home_page.dart';
import 'package:can_lua/pages/setting/setting_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  bool isDragging = false;
  late bool isDrawerOpen;
  int index = 0;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() {
    setState(() {
      xOffset = 230;
      yOffset = 150;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [buildDrawer(), buildPage()],
    );
  }

  Widget buildDrawer() {
    return DrawerWidget(
      onSelectedItem: (value) {
        setState(() {
          index = value;
          closeDrawer();
        });
      },
    );
  }

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                  color: isDrawerOpen ? Colors.pinkAccent : Colors.pink,
                  child: getPage(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(openDrawer: openDrawer);
      case 1:
        return AccountPage(openDrawer: openDrawer);
      case 2:
        return SettingPage(
          openDrawer: openDrawer,
        );
      case 3:
        return ChangePasswordPage(
          openDrawer: openDrawer,
        );
      default:
        return HomePage(openDrawer: openDrawer);
    }
  }
}
