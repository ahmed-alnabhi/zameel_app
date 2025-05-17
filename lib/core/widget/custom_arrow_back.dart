  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customArrowBack(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 30.w) ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("assets/images/back.png", width: 24, height: 24),
          ),
        ],
      ),
    );
  }