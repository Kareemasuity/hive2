import 'package:flutter/material.dart';
import 'package:hive/core/utlis/image_constant.dart';
import 'package:hive/core/utlis/size_utlis.dart';
import 'package:hive/theme/app_decoration.dart';
import 'package:hive/theme/app_style.dart';
import 'package:hive/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class Listrectangle1312ItemWidget extends StatelessWidget {
  Listrectangle1312ItemWidget();

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: getMargin(
            right: 16,
          ),
          padding: getPadding(
            all: 8,
          ),
          decoration: AppDecoration.outlineBlueA700.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgRectangle1312160x1601,
                height: getSize(
                  160,
                ),
                width: getSize(
                  160,
                ),
                radius: BorderRadius.circular(
                  getHorizontalSize(
                    3,
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  top: 10,
                  bottom: 3,
                ),
                child: Text(
                  "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtGilroySemiBold16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
