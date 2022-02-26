import 'package:can_lua/pages/main_page/main_page.dart';
import 'package:can_lua/pages/signup/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return const MainPage();
    } else {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          decoration: const BoxDecoration(),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                      label: const Text('Mật Khẩu'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Quên Mật Khẩu?"),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 170,
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
                        if (_formKey.currentState!.validate()) {
                          UserCredential? userCredential;
                          try {
                            userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          } on FirebaseAuthException catch (e) {
                            // print(e);
                            if (e.code == 'user-not-found') {
                              print('không tìm thấy user');
                            } else if (e.code == 'wrong-password') {
                              print('sai mật khẩu');
                            }
                          }
                          if (userCredential != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Đăng Nhập',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Hoặc đăng nhập bằng',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SignInButton(
                            'Facebook', FontAwesomeIcons.facebook, Colors.blue,
                            () async {
                          try {
                            final LoginResult loginResult =
                                await FacebookAuth.instance.login();

                            // Create a credential from the access token
                            final OAuthCredential facebookAuthCredential =
                                FacebookAuthProvider.credential(
                                    loginResult.accessToken!.token);

                            // Once signed in, return the UserCredential
                            await FirebaseAuth.instance
                                .signInWithCredential(facebookAuthCredential);

                            if (FirebaseAuth.instance.currentUser != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainPage()),
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                        }),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: SignInButton(
                            'Google', FontAwesomeIcons.google, Colors.red,
                            () async {
                          final GoogleSignInAccount? googleUser =
                              await GoogleSignIn().signIn();

                          final GoogleSignInAuthentication? googleAuth =
                              await googleUser?.authentication;

                          final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth?.accessToken,
                            idToken: googleAuth?.idToken,
                          );
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);

                          if (FirebaseAuth.instance.currentUser != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                            );
                          }
                        }),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Bạn chưa có tài khoản?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()));
                        },
                        child: const Text('Đăng ký'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget SignInButton(
      String text, IconData icon, Color color, Function onClick) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          onClick();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(
              width: 15,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
