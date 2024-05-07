import 'package:flutter/material.dart';
import 'package:hive/core/utlis/image_constant.dart';
import 'package:hive/core/utlis/size_utlis.dart';
import 'package:hive/theme/app_style.dart';
import 'package:hive/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Listunsplashfr2iwkpsiyItemWidget extends StatelessWidget {
  Listunsplashfr2iwkpsiyItemWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgUnsplashfr2iwkpsiy50x501,
          height: getSize(
            50,
          ),
          width: getSize(
            50,
          ),
          radius: BorderRadius.circular(
            getHorizontalSize(
              6,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: getPadding(
              left: 16,
              top: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtGilroySemiBold18,
                ),
                Padding(
                  padding: getPadding(
                    top: 5,
                  ),
                  child: Text(
                    "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtGilroyRegular14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
