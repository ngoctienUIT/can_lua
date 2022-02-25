import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const AccountPage({Key? key, required this.openDrawer}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/welcome.jpg'),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text('Trần Ngọc Tiến',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          Text(
            FirebaseAuth.instance.currentUser!.email.toString(),
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          )
        ],
      )),
    );
  }
}
