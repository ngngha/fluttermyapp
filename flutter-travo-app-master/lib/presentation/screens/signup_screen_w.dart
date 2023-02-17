import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/core/helpers/asset_helper.dart';

import '../widgets/login_header_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: const [
            FormHeaderWidget(
              image: AssetHelper.logo,
              title: 'Welcome',
              subTitle: 'Please log in to continue',
            ),
          ],
        ),
      ),
    ));
  }
}
