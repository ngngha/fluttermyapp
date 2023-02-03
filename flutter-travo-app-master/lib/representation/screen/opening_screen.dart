import 'package:flutter/material.dart';
import 'package:travo_app_source/core/helpers/local_storage_helper.dart';
import 'package:travo_app_source/representation/screen/intro_screen.dart';
import 'package:travo_app_source/representation/screen/main_app.dart';

class OpeningView extends StatefulWidget {
  const OpeningView({Key? key}) : super(key: key);

  static String routeName = '/opening_screen';

  @override
  State<OpeningView> createState() => _OpeningViewState();
}

class _OpeningViewState extends State<OpeningView> {
  @override
  void initState() {
    super.initState();

    _routeToIntroScreen();
  }

  void _routeToIntroScreen() async {
    final ignoreIntro = LocalStorageHelper.getValue('ignoreIntro') as bool?;
    await Future.delayed(Duration(milliseconds: 1000));
    if (ignoreIntro ?? false) {
      Navigator.of(context).pushNamed(MainApp.routeName);
    } else {
      LocalStorageHelper.setValue('ignoreIntro', true);
      Navigator.of(context).pushNamed(IntroScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [],
    );
  }
}
