import 'package:flutter/material.dart';
import 'package:job_manager/core/constants/color_palatte.dart';
import 'package:job_manager/core/constants/dimension_constants.dart';
import 'package:job_manager/core/constants/textstyle_ext.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarContainer extends StatelessWidget {
  const AppBarContainer({
    Key? key,
    required this.child,
    this.title,
    this.titleString,
    this.subTitleString,
    this.implementTraling = false,
    this.implementLeading = true,
    this.paddingContent = const EdgeInsets.symmetric(
      horizontal: kMediumPadding,
    ),
  })  : assert(title != null || titleString != null,
            'title or titleString can\'t be null'),
        super(key: key);

  final Widget child;
  final Widget? title;
  final String? titleString;
  final String? subTitleString;
  final bool implementTraling;
  final bool implementLeading;
  final EdgeInsets? paddingContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 100,
            child: AppBar(
              title: title ??
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (implementLeading)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(
                              //     kDefaultPadding,
                              //   ),
                              //   color: Colors.white,
                              // ),
                              padding: EdgeInsets.all(kItemPadding),
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                size: kBottomBarIconSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  titleString ?? '',
                                  style: TextStyles.defaultStyle.fontHeader
                                      .whiteTextColor.bold,
                                ),
                                if (subTitleString != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: kMediumPadding),
                                    child: Text(
                                      subTitleString!,
                                      style: TextStyles.defaultStyle.fontCaption
                                          .whiteTextColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (implementTraling)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                kDefaultPadding,
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(kItemPadding),
                            child: Icon(
                              FontAwesomeIcons.bars,
                              size: kDefaultPadding,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
              flexibleSpace: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.teal,
                          Color.fromARGB(255, 57, 128, 111)
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 90,
              backgroundColor: ColorPalette.backgroundScaffoldColor,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 130),
            padding: paddingContent,
            child: child,
          ),
        ],
      ),
    );
  }
}
