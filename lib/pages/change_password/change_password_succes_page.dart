import 'package:can_lua/pages/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeSuccesPage extends StatefulWidget {
  const ChangeSuccesPage({Key? key}) : super(key: key);

  @override
  _ChangeSuccesState createState() => _ChangeSuccesState();
}

class _ChangeSuccesState extends State<ChangeSuccesPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/welcome.jpg',
                      height: 300,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Đăng ký tài khoản thành công',
                      style: TextStyle(fontSize: 28),
                    ),
                    const Text(
                      'Vui lòng đăng nhập lại!',
                      style: TextStyle(fontSize: 20, color: Colors.black38),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 200,
                      height: 55,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.arrow_back_ios),
                            Text(
                              'Trở Về Đăng Nhập',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
