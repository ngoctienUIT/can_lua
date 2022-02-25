import 'package:can_lua/pages/signup/signup_succes_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isHiddenRepeat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 30),
                ),
                const Text(
                  'Chào mừng bạn đã quay lại!',
                  style: TextStyle(fontSize: 20, color: Colors.black38),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (val) =>
                      val!.isEmpty ? 'Bạn chưa nhập email' : null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    label: Text('Email'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (val) =>
                      val!.length < 6 ? 'Mật khẩu phải trên 6 kí tự' : null,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outlined),
                    label: const Text('Nhập Mật Khẩu'),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      icon: _isHidden == true
                          ? const Icon(
                              Icons.visibility_outlined,
                              color: Colors.black54,
                            )
                          : const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black54,
                            ),
                    ),
                  ),
                  obscureText: _isHidden,
                  obscuringCharacter: '●',
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _repeatPasswordController,
                  validator: (val) => val != _passwordController.text
                      ? 'Mật khẩu không trùng khớp'
                      : null,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outlined),
                    label: const Text('Nhập Lại Mật Khẩu'),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isHiddenRepeat = !_isHiddenRepeat;
                        });
                      },
                      icon: _isHiddenRepeat == true
                          ? const Icon(
                              Icons.visibility_outlined,
                              color: Colors.black54,
                            )
                          : const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black54,
                            ),
                    ),
                  ),
                  obscureText: _isHiddenRepeat,
                  obscuringCharacter: '●',
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 170,
                  height: 55,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        UserCredential? userCredential;
                        try {
                          userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }
                        if (userCredential != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupSuccesPage()),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Đăng Ký',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Trở về đăng nhập"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
