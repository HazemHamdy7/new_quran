import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_quran/constants/app_colors.dart';
import 'package:new_quran/constants/assets.dart';
import 'package:new_quran/widget/custom_text.dart';

AppBar customAppBar({required VoidCallback? onPressed}) => AppBar(
      centerTitle: true,
      backgroundColor: AppColors.background.withOpacity(0.7),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(Assets.svgsMenuIcon),
            color: Colors.white,
          ),
          CustomText(
              text: "القران الكريم",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.bookmarks),
            color: Colors.white,
            isSelected: true,
            style: IconButton.styleFrom(),
          ),
        ],
      ),
    );