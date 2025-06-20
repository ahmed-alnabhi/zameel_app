import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/networking/join_class/fetch_majors_groups.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/features/home/profile/request_join_again/request_join_class_again_screen.dart';

class JoinClassAgainScreen extends StatefulWidget {
  final String token;
  const JoinClassAgainScreen({super.key, required this.token});

  @override
  State<JoinClassAgainScreen> createState() => _JoinClassAgainScreenState();
}

class _JoinClassAgainScreenState extends State<JoinClassAgainScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 735),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer,
                            ),
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              "assets/images/plus3d.png",
                              width: 70.w,
                              height: 70.h,
                            ),
                          ),
                          SizedBox(height: 60.h),
                          Text(
                            "إضافة دفعة",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "قم بإضافة دفعة لإرسال طلب النضمام",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(height: 20.h),

                          SizedBox(height: 24.h),
                          CustomButton(
                            isLoading: _isLoading,
                            text: _isLoading?"جار التحميل...":"إضافة دفعة",
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              // final SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // final token = prefs.getString('token');
                              final result = await fetchMajorsGroups(
                                token: widget.token,
                              );
                              if (result['success'] == true) {
                                setState(() {
                                _isLoading = false;
                              });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RequestJoinClassAgainScreen(majorsData:result['data'] , token:  widget.token,),
                                  ),
                                );
                              } else {
                                setState(() {
                                _isLoading = false;
                              });
                                customSnackBar(
                                  context,
                                  "${result['message']}",
                                  Colors.red,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
