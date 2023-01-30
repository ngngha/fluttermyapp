import 'package:flutter/material.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);
  static String routeName = '/addproject_screen';

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  TextEditingController userController = TextEditingController();
  TextEditingController projectDetailController = TextEditingController();
  TextEditingController dateCreateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thêm mới dự án'),
        ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: 350,
                        height: 50,
                        child: TextFormField(
                          controller: userController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            // labelText: 'Email',
                            hintText: "Tên dự án",
                            prefixIcon: Icon(Icons.task, color: Colors.teal),
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
                          controller: userController,
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
                            border: OutlineInputBorder(),
                            // labelText: 'Email',
                            hintText: "Người phụ trách",
                            prefixIcon: Icon(Icons.person, color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: 350,
                        // height: 50,
                        child: TextFormField(
                          minLines: 4,
                          maxLines: 4,
                          // obscureText: _isObscure,
                          controller: projectDetailController,
                          // validator: ,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Nội dung của dự án",
                          ),
                        ),
                      ),
                    ),
                    
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: SizedBox(
                    //     width: 350,
                    //     height: 50,
                    //     child: TextFormField(
                    //       // obscureText: _isObscure,
                    //       controller: repasswordController,
                    //       validator: (val) => val != passwordController.text
                    //           ? 'Mật khẩu không khớp'
                    //           : null,
                          // decoration: InputDecoration(
                          //     border: const UnderlineInputBorder(),
                          //     hintText: "Nhập lại mật khẩu",
                          //     prefixIcon: const Icon(Icons.key, color: Colors.teal),
                          //     suffixIcon: IconButton(
                          //       icon: Icon(_isObscure
                          //           ? Icons.visibility
                          //           : Icons.visibility_off),
                          //       onPressed: () {
                          //         setState(() {
                          //           _isObscure = !_isObscure;
                          //         });
                          //       },
                          //     )),
                    //     ),
                    //   ),
                    // ),
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
                                  // createUserEmailAndPassword();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Thêm thành công dự án')),
                                  );
                                }
                              },
                              child: const Text('Thêm'),
                            ),
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
  void pickDateDialog() async{
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),

      ),
      lastDate: DateTime(2050),
      
    );
    if(picked!=null){
      setState(() {
        
      });
    }
  }
}
