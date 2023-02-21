import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_manager/data/model/user_model.dart';
import 'package:job_manager/presentation/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = '/signup_screen';

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
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpg', height: 150, width: 200),
                Text(
                  'Create Account',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(top: 15),
                        label: Text("Username"),
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: emailController,
                      validator: (val) => val!.isEmpty || !val.contains("@")
                          ? 'Must be a valid email'
                          : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(top: 15),
                        label: Text("Email"),
                        prefixIcon: Icon(Icons.mail, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: passwordController,
                      validator: (val) =>
                          val!.length < 6 ? 'Must have 6+ character' : null,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(top: 15),
                          label: Text("Password"),
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
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: repasswordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Must have 6+ character';
                        } else if (value != passwordController.text) {
                          return 'Not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(top: 15),
                          label: Text("Resign-password"),
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
                  padding: EdgeInsets.symmetric(vertical: 30),
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
                              textStyle:
                                  theme.textTheme.titleLarge),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              createUserEmailAndPassword();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sucess')),
                              );
                            }
                          },
                          child: const Text('Sign Up'),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            "Already have a account?",
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SignInScreen.routeName);
                            },
                            child: const Text("Sign In",
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
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      final user = FirebaseAuth.instance.currentUser;
      final name = usernameController.text;
      await userCredential.user!.updateDisplayName(name);
      user!.updateDisplayName(usernameController.text);
      final docUser = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid);
      final userInfo = UserModel(
        id: auth.currentUser!.uid,
        username: name,
        email: emailController.text,
        detail: '',
        gender: '',
        phoneNumber: '',
      );
      final json = userInfo.toJson();
      await docUser.set(json);
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user?.sendEmailVerification();
        Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
      } else {
        debugPrint('User mail is confirmed');
      }
      debugPrint(userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
