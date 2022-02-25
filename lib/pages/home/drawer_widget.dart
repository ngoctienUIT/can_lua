import 'package:can_lua/pages/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<int> onSelectedItem;

  const DrawerWidget({Key? key, required this.onSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(21, 30, 80, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/welcome.jpg'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trần Ngọc Tiến',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 16),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              DrawerItem(Icons.home, 'Home', () {
                onSelectedItem(0);
              }),
              DrawerItem(Icons.person, 'Tài Khoản', () {
                onSelectedItem(1);
              }),
              DrawerItem(Icons.settings, 'Cài Đặt', () {
                onSelectedItem(2);
              }),
              DrawerItem(Icons.lock_outline, 'Đổi Mật Khẩu', () {
                onSelectedItem(3);
              }),
              DrawerItem(Icons.logout, 'Đăng Xuất', () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget DrawerItem(IconData icon, String title, Function onclick) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        onclick();
      },
    );
  }
}
