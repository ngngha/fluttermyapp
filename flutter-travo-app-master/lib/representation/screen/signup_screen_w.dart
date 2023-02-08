import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travo_app_source/core/constants/dimension_constants.dart';
import 'package:travo_app_source/core/helpers/asset_helper.dart';

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
