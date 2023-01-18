import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
// import 'package:myapp/data/database.dart';
// import 'package:myapp/theme/loading.dart';
// import 'package:myapp/theme/routes.dart';
import 'package:travo_app_source/representation/screen/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  // const SignUpScreen({super.key});
    const SignUpScreen({Key? key}) : super(key: key);
    static String routeName = '/signup_screen';

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  late FirebaseAuth auth;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    //   auth.authStateChanges().listen((User? user) {
    //     if (user == null) {
    //       debugPrint('User is currently signed out!');
    //     } else {
    //       debugPrint('User is signed in!');
    //     }
    //   });
  }

  @override
  Widget build(BuildContext context) {
    // final mq = MediaQuery.of(context);

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
                  'Tạo tài khoản',
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
                    height: 50,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        // labelText: 'Email',
                        hintText: "Họ tên",
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        // labelText: 'Email',
                        hintText: "Email đăng nhập",
                        prefixIcon: Icon(Icons.mail, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: passwordController,
                      validator: (val) => val!.length < 6
                          ? 'Mật khẩu phải có ít nhất 6 kí tự'
                          : null,
                      decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: repasswordController,
                      validator: (val) => val!.length < 6
                          ? 'Mật khẩu phải có ít nhất 6 kí tự'
                          : null,
                      decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: "Nhập lại mật khẩu",
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
                  padding: const EdgeInsets.symmetric(vertical: 60),
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
                            createUserEmailAndPassword();
                          },
                          child: const Text('Đăng kí'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            "Đã có tài khoản?",
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(SignInScreen.routeName);
                            },
                            child: const Text("Đăng nhập",
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

  void createUserEmailAndPassword() async {
    try {
      var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      final name = usernameController.text;
      await userCredential.user?.updateDisplayName(name);
      User? updateUser = FirebaseAuth.instance.currentUser;
      updateUser!.updateDisplayName(usernameController.text);
      // userSetup(usernameController.text);
      // YYNoticeDialog();
      if (userCredential.user != null) {
        // if (!userCredential.user!.emailVerified) {
        //   await userCredential.user?.sendEmailVerification();
        // await myUser.updateDisplayName(usernameController.text);
        Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        // } else {
        //   debugPrint('User mail is confirmed');
      }
      debugPrint(userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
//   YYDialog YYNoticeDialog() {
//   return YYDialog().build()
//     ..width = 120
//     ..height = 110
//     ..backgroundColor = Colors.black.withOpacity(0.8)
//     ..borderRadius = 10.0
//     ..widget(Padding(
//       padding: EdgeInsets.only(top: 21),
//       child: Image.asset(
//         'images/success.png',
//         width: 38,
//         height: 38,
//       ),
//     ))
//     ..widget(Padding(
//       padding: EdgeInsets.only(top: 10),
//       child: Text(
//         "Success",
//         style: TextStyle(
//           fontSize: 15,
//           color: Colors.white,
//         ),
//       ),
//     ))
//     ..animatedFunc = (child, animation) {
//       return ScaleTransition(
//         child: child,
//         scale: Tween(begin: 0.0, end: 1.0).animate(animation),
//       );
//     }
//     ..show();
// }
}
