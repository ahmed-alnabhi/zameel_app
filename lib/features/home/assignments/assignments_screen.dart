import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zameel/core/functions/days_left_or_date.dart';
import 'package:zameel/core/functions/format_time_ago.dart';
import 'package:zameel/core/networking/assignments/delete_assignment.dart';
import 'package:zameel/core/networking/assignments/fetch_all_assignments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/networking/assignments/fetch_subject_by_group.dart';
import 'package:zameel/core/networking/assignments/fetch_teacher_groups_subjects.dart';
import 'package:zameel/core/networking/resources_services/fetch_student_groups.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/features/home/assignments/assignment_details_screen.dart';
import 'package:zameel/features/home/assignments/assignment_teacher.dart';
import 'package:zameel/features/home/assignments/dialog_for_create_assignment_represnter_pov.dart';
import 'package:zameel/features/home/assignments/dialog_for_create_assignment_teacher_pov.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> assignments = [];
  bool isLoading = false;
  bool hasMore = true;
  String? lastCursor;
  final int pageSize = 12;
  int? roll;
  String? token;

  Future<void> getRollID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    roll = prefs.getInt('roll');
  }

  @override
  void initState() {
    super.initState();

    getRollID();

    _fetchAssignments();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        _fetchAssignments();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchAssignments() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    try {
      final result = await fetchAssignmentsService(
        token: token,
        cursor: lastCursor,
        before: true,
      );

      if (result['success'] == true) {
        final List<dynamic> fetched = result['data'];

        setState(() {
          assignments.addAll(fetched);

          if (fetched.isNotEmpty) {
            final lastCreatedAt = DateTime.parse(fetched.last['created_at']);
            lastCursor = formatDateForCursor(lastCreatedAt);

            if (fetched.length < pageSize) {
              hasMore = false;
            }
          } else {
            hasMore = false;
          }
        });
      } else {
        hasMore = false;
      }
    } catch (e) {
      hasMore = false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      assignments.clear();
      lastCursor = null;
      hasMore = true;
    });
    await _fetchAssignments();
  }

  String formatDateForCursor(DateTime dateTime) {
    return "${dateTime.year.toString().padLeft(4, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}:"
        "${dateTime.second.toString().padLeft(2, '0')}";
  }

  TextStyle _dateStyle(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildAssignmentItem(dynamic assignment) {
    final createdAt = assignment['created_at'] ?? '';
    final dueDate = assignment['due_date'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        title: Text(
          assignment['title'] ?? "بدون عنوان",
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "تاريخ الإنشاء:",
                      style: _dateStyle(context).copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(formatTimeAgo(createdAt), style: _dateStyle(context)),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "آخر موعد للتسليم:",
                      style: _dateStyle(context).copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(daysLeftOrDate(dueDate), style: _dateStyle(context)),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "مادة :",
                      style: _dateStyle(context).copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${assignment['subject_id']}",
                      style: _dateStyle(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (roll == 3 || roll == 4)
                IconButton(
                  icon: Icon(LucideIcons.trash, color: Colors.red, size: 24),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: AlertDialog(
                            title: Text(
                              'حذف الواجب',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: AppFonts.mainFontName,
                                fontSize: 18,
                              ),
                            ),
                            content: Text(
                              'هل أنت متأكد من رغبتك في حذف هذا التكليف',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontFamily: AppFonts.mainFontName,
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'إلغاء',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontFamily: AppFonts.mainFontName,
                                    fontSize: 14,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'حذف',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontFamily: AppFonts.mainFontName,
                                    fontSize: 14,
                                  ),
                                ),
                                onPressed: () async {
                                  final resultOfDelete =
                                      await deleteAssignmentService(
                                        token: token,
                                        assignmentID: assignment['id'],
                                      );
                                  if (resultOfDelete['success']) {
                                    customSnackBar(
                                      context,
                                      "تم الحذف ببنجاح",
                                      Colors.green,
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    customSnackBar(
                                      context,
                                      "${resultOfDelete['message']}",
                                      Colors.red,
                                    );
                                    print(token);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              (roll == 4 || roll == 5)
                                  ? AssignmentDetailsScreen(
                                    assignment: assignment,
                                  )
                                  : AssignmentTeacher(
                                    assignment: assignment,
                                    token: token!,
                                  ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:
            roll == 3
                ? null
                : AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  centerTitle: true,
                  toolbarHeight: 40,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Text(
                    "قائمة الواجبات الخاصة بك",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                  ),
                ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child:
                assignments.isEmpty && !isLoading
                    ? const Center(child: Text("لا توجد واجبات حالياً"))
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: assignments.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < assignments.length) {
                          return _buildAssignmentItem(assignments[index]);
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
          ),
        ),
        floatingActionButton:
            (roll == 3 || roll == 4)
                ? FloatingActionButton(
                  heroTag: UniqueKey().toString(),
                  onPressed: () async {
                    if (token != null && roll == 3) {
                      // ✅ إظهار دائرة التحميل
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            ),
                      );
                      final result = await fetchGroupNamesAndSubjectIds(token!);
                      Navigator.of(context, rootNavigator: true).pop();

                      if (result.isNotEmpty && token != null) {
                        showAssignmentFormDialog(
                          context: context,
                          groups: result,
                          token: token!,
                        );
                      }
                    } else if (roll == 4) {
                      final resultGroup = await fetchStudentGroups(
                        token: token!,
                      );
                      if (resultGroup['success']) {
                        final groupId = resultGroup['data'].first;
                        final resultSubject = await fetchSubjectsByGroup(
                          groupId: groupId,
                          token: token!,
                        );
                        if (resultSubject.isNotEmpty) {
                          showDialogForCreateAssignmentRepresnterPov(
                            context: context,
                            token: token!,
                            groups: resultSubject,
                            
                          );
                        }
                      }

                      // print(result);
                    }
                  },
                  child: const Icon(LucideIcons.plus, color: Colors.white),
                )
                : null,
      ),
    );
  }
}
