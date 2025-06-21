import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/networking/join_class/send_join_request.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/features/home/home_screen.dart';
import 'package:zameel/features/home/profile/profile_screen.dart';
import 'package:zameel/features/join_class/custom_dropdown_feild.dart';

class RequestJoinClassAgainScreen extends StatefulWidget {
  final String token;
  final List<dynamic> majorsData;
  const RequestJoinClassAgainScreen({
    super.key,
    required this.majorsData,
    required this.token,
  });

  @override
  State<RequestJoinClassAgainScreen> createState() =>
      _RequestJoinClassAgainScreenState();
}

class _RequestJoinClassAgainScreenState
    extends State<RequestJoinClassAgainScreen> {
  String? selectedCollege;
  String? selectedProgram;
  int? selectedGroupId;
  bool isLoading = false;
  bool isEnabled = true;

  /// خريطة معرفات الكليات إلى أسمائها
  final Map<int, String> collegeNames = {
    1: "الطب",
    2: "الهندسة",
    3: "العلوم",
    4: "التربية",
  };

  /// استخراج الكليات من البيانات (مع إزالة التكرار)
  List<String> get colleges {
    final ids = widget.majorsData.map((m) => m['college_id']).toSet();
    return ids.map((id) => collegeNames[id] ?? "غير معروف").toList();
  }

  /// استخراج التخصصات بناءً على الكلية المحددة، **ويعرض فقط التي تحتوي على جروبات**
  List<String> get programs {
    if (selectedCollege == null) return [];
    final selectedCollegeId =
        collegeNames.entries
            .firstWhere((entry) => entry.value == selectedCollege)
            .key;
    return widget.majorsData
        .where(
          (m) =>
              m['college_id'] == selectedCollegeId &&
              (m['groups'] as List).isNotEmpty,
        ) // فقط تخصصات تحتوي جروبات
        .map((m) => m['name'] as String)
        .toList();
  }

  /// استخراج المجموعات مع الـ id والنص الوصفي (label)
  List<Map<String, dynamic>> get groups {
    if (selectedProgram == null) return [];
    final major = widget.majorsData.firstWhere(
      (m) => m['name'] == selectedProgram,
      orElse: () => null,
    );
    if (major == null || major['groups'] == null) return [];
    return (major['groups'] as List).map((g) {
      return {'id': g['id'], 'label': "${g['join_year']} - ${g['division']}"};
    }).toList();
  }

  /// الحصول على النص المعروض للمجموعة المختارة بناء على selectedGroupId
  String? get selectedGroupLabel {
    if (selectedGroupId == null) return null;
    final group = groups.firstWhere(
      (g) => g['id'] == selectedGroupId,
      orElse: () => {'label': null},
    );
    return group['label'] as String?;
  }

  @override
  void initState() {
    super.initState();
  }

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
                            "التحاق بالدفعة",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "قم بتحديد بيانات الدفعة",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(height: 20.h),

                          /// حقل الكلية
                          CustomDropdownField(
                            label: "اختر الكلية",
                            value: selectedCollege,
                            options: colleges,
                            onSelected: (val) {
                              setState(() {
                                selectedCollege = val;
                                selectedProgram = null;
                                selectedGroupId = null;
                              });
                            },
                          ),
                          const SizedBox(height: 15),

                          /// حقل التخصص (البرنامج) — مع تمكين/تعطيل حسب اختيار الكلية
                          CustomDropdownField(
                            label: "اختر التخصص",
                            value: selectedProgram,
                            options: programs,
                            enabled: selectedCollege != null,
                            onSelected: (val) {
                              setState(() {
                                selectedProgram = val;
                                selectedGroupId = null;
                              });
                            },
                          ),
                          const SizedBox(height: 15),

                          /// حقل المجموعة — مع تمكين/تعطيل حسب اختيار التخصص
                          CustomDropdownField(
                            label: "اختر المجموعة",
                            value: selectedGroupLabel,
                            options:
                                groups
                                    .map((g) => g['label'] as String)
                                    .toList(),
                            enabled: selectedProgram != null,
                            onSelected: (val) {
                              final group = groups.firstWhere(
                                (g) => g['label'] == val,
                              );
                              setState(() {
                                selectedGroupId = group['id'] as int;
                              });
                            },
                          ),
                          SizedBox(height: 24.h),

                          CustomButton(
                            isLoading: isLoading,
                            isEnabled: isEnabled,
                            text: "طلب التحاق بالدفعة",
                            onPressed: () async {
                              if (selectedCollege != null &&
                                  selectedProgram != null &&
                                  selectedGroupId != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                final result = await sendJoinRequest(
                                  token: widget.token,
                                  groupId: selectedGroupId!,
                                );
                                if (result['success']) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                   
                                  customSnackBar(
                                    context,
                                    "تم إرسال طلب الالتحاق بنجاح",
                                    Colors.green,
                                  );
                                  
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  customSnackBar(
                                    context,
                                    "${result['data']} ",
                                    Colors.red,
                                  );
                                }
                              } else {
                                // customSnackBar(
                                //   context,
                                //   " الرجاء إكمال الاختيارات",
                                //   Colors.red,
                                // );
                                print(" الرجاء إكمال الاختيارات");
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
