import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/networking/resources_services/fetch_all_books.dart';
import 'package:zameel/core/networking/resources_services/fetch_student_groups.dart';
import 'package:zameel/core/networking/resources_services/get_subject_name.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';
import 'package:zameel/features/home/resources/subject_book_screen.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});
  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  List<int> groupIds = [];
  List<int> semester1SubjectIds = [];
  List<int> semester2SubjectIds = [];
  Map<int, String> subjectNames = {};
  bool isLoading = false;
  bool hasError = false;
  int? roll;
  bool noGroupId = false;

  Future<void> _fetchBooks() async {
    // Ensure that loading state is true at the start of a manual refresh
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final result = await fetchStudentGroups(token: token);

    if (result['success']) {
      if (result['data'].isEmpty) {
        setState(() {
          noGroupId = true;
          isLoading = false; // Stop loading if no group ID
        });
        return;
      }
      groupIds = List<int>.from(result['data']); // Ensure type correctness
      final bookResult = await fetchAllBooks(
        token: token,
        groupId: groupIds.first,
      );

      if (bookResult['success']) {
        final response = bookResult['data'] as Response;
        final books = response.data['data'] as List;
      
        // Clear previous data before fetching new data
        semester1SubjectIds.clear();
        semester2SubjectIds.clear();
        subjectNames.clear();

        semester1SubjectIds =
            books
                .where((book) => book['semester'] == 1)
                .map<int>((book) => book['subject_id'])
                .toSet()
                .toList();

        semester2SubjectIds =
            books
                .where((book) => book['semester'] == 2)
                .map<int>((book) => book['subject_id'])
                .toSet()
                .toList();

        await _fetchSubjectNames([
          ...semester1SubjectIds,
          ...semester2SubjectIds,
        ], token);

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false; // Stop loading on error
        });
      }
    } else {
      setState(() {
        hasError = true;
        isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> getRoll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    roll = prefs.getInt('roll');
  }

  Future<void> _fetchSubjectNames(List<int> subjectIds, String? token) async {
    for (final id in subjectIds) {
      final result = await getSubjectName(subjectId: id, token: token);
      if (result.containsKey('name')) {
        subjectNames[id] = result['name'] as String;
      } else {
        subjectNames[id] = "مادة غير معروفة";
      }
    }
    // No need for setState here as it's called in _fetchBooks after this completes
  }

  @override
  void initState() {
    super.initState();
    getRoll();
    _fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: CustomTextField(
          contentHeight: 16,
          hasPrefix: true,
          prefixIcon: LucideIcons.search,
          hintText: "ملزمة قواعد البيانات",
          isPassword: false,
          controller: SearchController(),
        ),
      ),
      body:
          noGroupId
              ? Center(child: Text("لم يتم تأكيد انضمامك لدفعة"))
              : DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      dividerHeight: 0,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onPrimary,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.mainFontName,
                      ),
                      tabs: [
                        Tab(text: 'الفصل الاول'),
                        Tab(text: 'الفصل الثاني'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Wrap the content of the first tab with RefreshIndicator
                          RefreshIndicator(
                            onRefresh: _fetchBooks,
                            child:
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : semester1SubjectIds.isEmpty
                                    ? Stack(
                                      children: [
                                        ListView(), // Ensures refresh works even when content is small
                                        Center(
                                          child: Text(
                                            "لا يوجد مواد لهذا الفصل",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.error,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                            ),
                                        itemCount: semester1SubjectIds.length,
                                        itemBuilder: (
                                          BuildContext context,
                                          int index,
                                        ) {
                                          final subjectId =
                                              semester1SubjectIds[index];
                                          final subjectName =
                                              subjectNames[subjectId] ??
                                              "جاري التحميل...";
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => SubjectBooksScreen(
                                                        groupId: groupIds.first,
                                                        semester: 1,
                                                        subjectId: subjectId,
                                                        subjectName:
                                                            subjectName,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/images/folder.svg",
                                                      height: 90,
                                                      width: 90,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            Theme.of(
                                                                      context,
                                                                    ).brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Color(
                                                                  0xff333333,
                                                                )
                                                                : Color(
                                                                  0xff999999,
                                                                ),
                                                            BlendMode.srcIn,
                                                          ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      subjectName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            AppFonts
                                                                .mainFontName,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                          ),
                          // Wrap the content of the second tab with RefreshIndicator
                          RefreshIndicator(
                            onRefresh: _fetchBooks,
                            child:
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : semester2SubjectIds.isEmpty
                                    ? Stack(
                                      children: [
                                        ListView(), // Ensures refresh works even when content is small
                                        Center(
                                          child: Text(
                                            "لا يوجد مواد لهذا الفصل",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                            ),
                                        itemCount: semester2SubjectIds.length,
                                        itemBuilder: (
                                          BuildContext context,
                                          int index,
                                        ) {
                                          final subjectId =
                                              semester2SubjectIds[index];
                                          final subjectName =
                                              subjectNames[subjectId] ??
                                              "جاري التحميل...";
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => SubjectBooksScreen(
                                                        groupId: groupIds.first,
                                                        semester: 2,
                                                        subjectId: subjectId,
                                                        subjectName:
                                                            subjectName,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 50,
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/images/folder.svg",
                                                      height: 90,
                                                      width: 90,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            Theme.of(
                                                                      context,
                                                                    ).brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Color(
                                                                  0xff333333,
                                                                )
                                                                : Color(
                                                                  0xff999999,
                                                                ),
                                                            BlendMode.srcIn,
                                                          ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      subjectName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            AppFonts
                                                                .mainFontName,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
