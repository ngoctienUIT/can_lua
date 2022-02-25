import 'package:can_lua/pages/change_password/change_password_succes_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const ChangePasswordPage({Key? key, required this.openDrawer})
      : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = false;
  bool checkCurrentPassword = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/welcome.jpg',
                      height: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: !_isHidden,
                    obscuringCharacter: '●',
                    style: TextStyle(
                      decorationColor: Colors.black.withOpacity(0.01),
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      label: Text('Mật khẩu hiện tại'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    validator: (val) => checkCurrentPassword
                        ? null
                        : 'Mật khẩu không chính xác',
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _newPassController,
                    obscureText: !_isHidden,
                    obscuringCharacter: '●',
                    style: TextStyle(
                      decorationColor: Colors.black.withOpacity(0.01),
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      label: Text('Mật khẩu mới'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    validator: (val) => val!.length < 6
                        ? 'Mật khẩu tối thiểu là 6 ký tự'
                        : null,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _confirmPassController,
                    obscureText: !_isHidden,
                    obscuringCharacter: '●',
                    style: TextStyle(
                      decorationColor: Colors.black.withOpacity(0.01),
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outlined),
                      label: Text('Xác nhận mật khẩu mới'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    validator: (val) => val! != _newPassController.text
                        ? 'Mật khẩu không trùng khớp'
                        : null,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                          activeColor: Colors.red,
                          value: _isHidden,
                          onChanged: (value) {
                            setState(() {
                              _isHidden = value!;
                            });
                          }),
                      const Text('Hiện mật khẩu')
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: 170,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        checkCurrentPassword =
                            await checkPass(_currentPasswordController.text);

                        if (_formKey.currentState!.validate() &&
                            checkCurrentPassword) {
                          final user = FirebaseAuth.instance.currentUser;
                          user!
                              .updatePassword(_newPassController.text)
                              .then((value) {})
                              .catchError((onError) {
                            print(onError);
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangeSuccesPage(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Đổi Mật Khẩu',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkPass(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email.toString(), password: currentPassword);
    try {
      var result = await user.reauthenticateWithCredential(cred);

      return result.user != null;
    } catch (e) {
      return false;
    }
  }
}
