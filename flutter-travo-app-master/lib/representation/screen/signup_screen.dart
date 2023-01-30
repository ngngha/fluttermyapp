import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travo_app_source/representation/screen/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String routeName = '/signup_screen';

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  bool _isObscure = true;
  // final bool emailValid =
  // RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //   .hasMatch();
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
                      validator: (val) => val!.isEmpty || !val.contains("@")
                          ? 'Phải là email hợp lệ'
                          : null,
                      // keyboardType: _isEmail ? TextInputType.emailAddress : TextInputType.text,
                      // validator: (value) {
                      //   if(!FormFieldValidator.is){
                      //     return 'Nhập email khả dụng'
                      //   }
                      // },
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
                      validator: (value) {
                        if(value!.isEmpty || value.length<6){
                          return 'Mật khẩu phải có ít nhất 6 kí tự';
                        }else if(value != passwordController.text){
                          return 'Mật khẩu không khớp';
                        } return null;
                      },
                      //  (val) => val != passwordController.text
                      //     ? 'Mật khẩu không khớp'
                      //     : null,
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
                            if (_formKey.currentState!.validate()) {
                              createUserEmailAndPassword();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đăng kí thành công')),
                              );
                            }
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
                              Navigator.of(context)
                                  .pushNamed(SignInScreen.routeName);
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
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      final name = usernameController.text;
      await userCredential.user?.updateDisplayName(name);
      User? updateUser = FirebaseAuth.instance.currentUser;
      updateUser!.updateDisplayName(usernameController.text);
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