import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travo_app_source/representation/screen/main_app.dart';
import 'package:travo_app_source/representation/screen/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String routeName = '/signin_screen';

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpg', height: 150, width: 200),
                const Text(
                  'Xin chào,',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 26,
                  ),
                ),
                const Text(
                  'Hãy đăng nhập để tiếp tục',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    // height: 70,
                    child: TextFormField(
                      controller: _emailController,
                      validator: (val) => val!.isEmpty || !val.contains("@")
                          ? 'Phải là email hợp lệ'
                          : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15),
                        border: OutlineInputBorder(),
                        hintText: "Email đăng nhập",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: 350,
                    // height: 70,
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: _passwordController,
                      validator: (val) => val!.length < 6
                          ? 'Mật khẩu phải có ít nhất 6 kí tự'
                          : null,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(top: 15),
                          hintText: "Mật khẩu",
                          prefixIcon: const Icon(Icons.key, color: Colors.teal),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              signUserEmailAndPassword();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đăng nhập thành công')),
                              );
                            }
                          },
                          child: const Text('Đăng nhập'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            "Chưa có tài khoản?",
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SignUpScreen.routeName);
                            },
                            child: const Text("Đăng ký",
                                style: TextStyle(
                                  color: Colors.teal,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    ));
  }

  void signUserEmailAndPassword() async {
    try {
      var userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      debugPrint(userCredential.toString());
      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('displayName', userCredential.user!.displayName!);
        Navigator.of(context).pushReplacementNamed(MainApp.routeName);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
