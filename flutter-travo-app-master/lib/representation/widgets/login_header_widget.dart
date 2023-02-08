import 'package:flutter/material.dart';
import 'package:travo_app_source/core/helpers/asset_helper.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.subTitle})
      : super(key: key);
  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: AssetImage(image),
          height: size.height * 0.2,
        ),
        // Image.asset(
        //   AssetHelper.logo,
        // height: size.height * 0.2,
        // ),
        Text(
          title,
          style: theme.textTheme.headlineMedium,
        ),
        Text(
          subTitle,
          style: theme.textTheme.bodyMedium,
        ),
        // const SizedBox(
        //   height: 30,
        // ),
      ],
    );
  }
}
