import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_manager/presentation/screens/main_app.dart';
import 'package:job_manager/presentation/screens/signup_screen.dart';

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

    final theme = Theme.of(context);
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
                Text(
                  'Hello,',
                  style: theme.textTheme.headlineMedium,
                  // TextStyle(
                  //   color: Colors.teal,
                  //   fontSize: 26,
                  // ),
                ),
                Text(
                  'Please log in to continue',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _emailController,
                      validator: (val) => val!.isEmpty || !val.contains("@")
                          ? 'Must be a valid email'
                          : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15),
                        border: OutlineInputBorder(),
                        label: Text("Email"),
                        // hintText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
                //380938
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: _passwordController,
                      validator: (val) =>
                          val!.length <= 6 ? 'Must have 6+ character' : null,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(top: 15),
                          label: Text("Password"),
                          // hintText: "Password",
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
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      child: Text(
                        "Forgot password?",
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            textStyle: theme.textTheme.titleLarge),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            signUserEmailAndPassword();
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          "Does not have a account?",
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignUpScreen.routeName);
                          },
                          child: const Text("Sign Up",
                              style: TextStyle(
                                color: Colors.teal,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    ));
  }

  void signUserEmailAndPassword() async {
    // if (mounted) {
      try {
        var userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        if (userCredential.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thành công')),
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('displayName', userCredential.user!.displayName!);

          Navigator.of(context).pushReplacementNamed(MainApp.routeName);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Tài khoản không tồn tại, hãy đăng ký để có thể đăng nhập')),
          );
        }
        debugPrint(e.toString());
      }
    // }
  }
}
