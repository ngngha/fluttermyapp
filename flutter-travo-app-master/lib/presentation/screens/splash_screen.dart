// import 'package:flutter/material.dart';
// import 'package:travo_app_source/core/helpers/asset_helper.dart';
// import 'package:travo_app_source/core/helpers/image_helper.dart';
// import 'package:travo_app_source/presentation/screens/intro_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//   static const String routeName = '/splash_screen';

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   bool animate = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 1600),
//             bottom: animate ? 1 : -100,
//             child: ImageHelper.loadFromAsset(AssetHelper.logo),
//           ),
//           AnimatedPositioned(
//             duration: Duration(milliseconds: 1600),
//             top: 80,
//             left: animate ? 1 : -80,
//             child: AnimatedOpacity(
//               duration: Duration(milliseconds: 1600),
//               opacity: animate ? 1 : 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '.appable',
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   Text(
//                     'Free For Everyone',
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                 ],
//               ),
//             ),
//             // Positioned(
//             //   top: 40,
//             //   child: Column(
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: [
//             //       Text(
//             //         '.appable',
//             //         style: Theme.of(context).textTheme.headlineMedium,
//             //       ),
//             //       Text(
//             //         'Free For Everyone',
//             //         style: Theme.of(context).textTheme.headlineLarge,
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           )
//         ],
//       ),
//     );
//   }

//   Future startAnimation() async {
//     await Future.delayed(Duration(milliseconds: 500));
//     setState(() => animate = true);
//     await Future.delayed(Duration(milliseconds: 5000));
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => IntroScreen()));
//   }
// }

import 'package:flutter/material.dart';
import 'package:travo_app_source/core/helpers/local_storage_helper.dart';
import 'package:travo_app_source/presentation/screens/intro_screen.dart';
import 'package:travo_app_source/presentation/screens/main_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String routeName = '/splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _routeToIntroScreen();
  }

  void _routeToIntroScreen() async {
    final ignoreIntro = LocalStorageHelper.getValue('ignoreIntro') as bool?;
    await Future.delayed(Duration(milliseconds: 1000));
    if (ignoreIntro ?? false) {
      Navigator.of(context).pushReplacementNamed(MainApp.routeName);
    } else {
      LocalStorageHelper.setValue('ignoreIntro', true);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(IntroScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 24,
          ),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 24),
          )
        ],
      )),
    );
  }
}
