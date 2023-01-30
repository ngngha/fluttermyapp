import 'package:flutter/material.dart';
import 'package:travo_app_source/core/constants/textstyle_ext.dart';
import 'package:travo_app_source/core/helpers/asset_helper.dart';
import 'package:travo_app_source/core/helpers/image_helper.dart';
import 'package:travo_app_source/representation/screen/listproject.dart';
import 'package:travo_app_source/representation/widgets/app_bar_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/dimension_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildItemCategory(
      Widget icon, Color color, Function() onTap, String title) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: kMediumPadding,
            ),
            child: icon,
            decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(kItemPadding)),
          ),
          SizedBox(
            height: kItemPadding,
          ),
          Text(title)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      titleString: 'home',
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kItemPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Xin chào, !',
                    style:
                        TextStyles.defaultStyle.fontHeader.whiteTextColor.bold),
                // SizedBox(
                //   height: 10,
                // ),
                // Text(
                //   'Chào mừng bạn',
                //   style: TextStyles.defaultStyle.fontCaption.whiteTextColor,
                // )
              ],
            ),
            Spacer(),
            Icon(
              FontAwesomeIcons.bell,
              size: kDefaultIconSize,
              color: Colors.white,
            ),
            SizedBox(
              width: kMinPadding,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  kItemPadding,
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(kItemPadding),
              child: ImageHelper.loadFromAsset(
                AssetHelper.person,
              ),
            ),
          ],
        ),
      ),
      implementLeading: false,
      child: Column(
        children: [
          SizedBox(
            height: kDefaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: _buildItemCategory(
                    SizedBox(
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                      child:
                          Icon(FontAwesomeIcons.listCheck, color: Colors.teal),
                    ),
                    Colors.teal, () {
                  Navigator.of(context).pushNamed(ListProject.routeName);
                }, 'Dự án'),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: _buildItemCategory(
                    SizedBox(
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                      child:
                          Icon(FontAwesomeIcons.thumbtack, color: Colors.teal),
                    ),
                    Colors.teal,
                    () {},
                    'Task'),
              ),
              SizedBox(width: kDefaultPadding),
              Expanded(
                child: _buildItemCategory(
                    SizedBox(
                      width: kDefaultIconSize,
                      height: kDefaultIconSize,
                      child: Icon(FontAwesomeIcons.user, color: Colors.teal),
                    ),
                    Colors.teal,
                    () {},
                    'Nhân viên'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
