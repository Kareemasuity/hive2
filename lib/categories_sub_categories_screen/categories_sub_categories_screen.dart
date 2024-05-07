// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hive/categories_sub_categories_screen/widgets/listrectangle1312_item_widget.dart';
import 'package:hive/categories_sub_categories_screen/widgets/listunsplashfr2iwkpsiy_item_widget.dart';
import 'package:hive/core/utlis/color_constant.dart';
import 'package:hive/core/utlis/image_constant.dart';
import 'package:hive/core/utlis/size_utlis.dart';
import 'package:hive/theme/app_style.dart';
import 'package:hive/widgets/app_bar/appbar_image.dart';
import 'package:hive/widgets/app_bar/appbar_title.dart';
import 'package:hive/widgets/app_bar/custom_app_bar.dart';
import 'package:hive/widgets/custom_image_view.dart';
import 'package:hive/widgets/custom_search_view.dart';

class CategoriesSubCategoriesScreen extends StatelessWidget {
  TextEditingController inputFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray50,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
                height: getVerticalSize(53),
                leadingWidth: 40,
                leading: AppbarImage(
                    height: getSize(24),
                    width: getSize(24),
                    svgPath: ImageConstant.imgArrowleft,
                    margin: getMargin(left: 16, top: 12, bottom: 17),
                    onTap: () {
                      onTapArrowleft(context);
                    }),
                centerTitle: true,
                title: AppbarTitle(text: "Comp"),
                actions: [
                  AppbarImage(
                      height: getSize(24),
                      width: getSize(24),
                      svgPath: ImageConstant.imgOverflowmenu,
                      margin:
                          getMargin(left: 16, top: 12, right: 16, bottom: 17))
                ]),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(top: 20, bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: CustomSearchView(
                              focusNode: FocusNode(),
                              controller: inputFieldController,
                              hintText: "Search",
                              margin: getMargin(left: 16, right: 16),
                              alignment: Alignment.center,
                              prefix: Container(
                                  margin: getMargin(
                                      left: 12, top: 12, right: 8, bottom: 12),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgSearch)),
                              prefixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(44)),
                              suffix: Container(
                                  margin: getMargin(
                                      left: 30, top: 12, right: 12, bottom: 12),
                                  child: CustomImageView(
                                      svgPath: ImageConstant.imgMicrophone)),
                              suffixConstraints: BoxConstraints(
                                  maxHeight: getVerticalSize(44)))),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              height: getVerticalSize(234),
                              child: ListView.separated(
                                  padding: getPadding(left: 16, top: 24),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                        height: getVerticalSize(16));
                                  },
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Listrectangle1312ItemWidget();
                                  }))),
                      Padding(
                          padding: getPadding(left: 16, top: 29),
                          child: Text(" Sub-Comp",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtGilroySemiBold18)),
                      Padding(
                          padding: getPadding(left: 16, top: 17, right: 144),
                          child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return Padding(
                                    padding:
                                        getPadding(top: 16.5, bottom: 16.5),
                                    child: SizedBox(
                                        width: getHorizontalSize(396),
                                        child: Divider(
                                            height: getVerticalSize(1),
                                            thickness: getVerticalSize(1),
                                            color: ColorConstant.blueGray100)));
                              },
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Listunsplashfr2iwkpsiyItemWidget();
                              }))
                    ]))));
  }

  onTapArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}
