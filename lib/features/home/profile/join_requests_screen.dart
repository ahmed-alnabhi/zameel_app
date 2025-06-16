import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:zameel/core/functions/format_time_ago.dart';
import 'package:zameel/core/networking/join_class/accept_request.dart';
import 'package:zameel/core/networking/join_class/fetch_join_requests.dart';
import 'package:zameel/core/networking/join_class/reject_request.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';

class JoinRequestsScreen extends StatefulWidget {
  final String token;
  final int groupId;

  const JoinRequestsScreen({
    super.key,
    required this.token,
    required this.groupId,
  });

  @override
  State<JoinRequestsScreen> createState() => _JoinRequestsScreenState();
}

class _JoinRequestsScreenState extends State<JoinRequestsScreen> {
  List<dynamic> requests = [];
  bool isLoading = false;
  bool isAccepting = false;
  bool isRejecting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final result = await fetchJoinRequests(
      token: widget.token,
      groupId: widget.groupId,
    );

    if (result['success'] == true) {
      final List<dynamic> fetched = result['data'];
      // فلترة الطلبات حسب status_id == 2 فقط
      final filtered = fetched.where((req) => req['status_id'] == 2).toList();
      setState(() {
        requests = filtered.reversed.toList(); // الأحدث أولاً
      });
    } else {
      print('حدث خطأ أثناء تحميل الطلبات: ${result['message']}');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          toolbarHeight: 60,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text(
            "طلبات الإنضمام",
            style: TextStyle(
              fontSize: 24,
              fontFamily: AppFonts.mainFontName,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
        ),
        body:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                  child: RefreshIndicator(
                    onRefresh: fetchRequests,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final user = request['user'] ?? {};

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 5,
                            right: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              user['name'] ?? 'اسم غير معروف',
                              style: TextStyle(
                                fontFamily: AppFonts.mainFontName,
                                fontSize: 16,
                                height: 2.2,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  user['email'] ?? '',
                                  style: TextStyle(
                                    fontFamily: AppFonts.mainFontName,
                                    fontSize: 11,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  formatTimeAgo(requests[index]['created_at']),
                                  style: TextStyle(
                                    fontFamily: AppFonts.mainFontName,
                                    fontSize: 11,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    LucideIcons.check,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: AlertDialog(
                                              title: Text(
                                                'تأكيد الإنضمام',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.green,
                                                  fontFamily:
                                                      AppFonts.mainFontName,
                                                ),
                                              ),

                                              content: Text(
                                                'هل انت متأكد من ضم ${user['name']} للمجموعة؟',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.onPrimary,
                                                  height: 1.9,
                                                  fontFamily:
                                                      AppFonts.mainFontName,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'الغاء',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                      fontFamily:
                                                          AppFonts.mainFontName,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isAccepting = true;
                                                    });
                                                    final response =
                                                        await acceptRequest(
                                                          token: widget.token,
                                                          requestId:
                                                              requests[index]['id'],
                                                        );
                                                    if (response['success']) {
                                                      setState(() {
                                                        requests.removeAt(
                                                          index,
                                                        );
                                                      });
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                      customSnackBar(
                                                        context,
                                                        "تم اضافة العضو بنجاح",
                                                        Colors.green,
                                                      );
                                                    } else {
                                                      setState(() {
                                                        isAccepting = false;
                                                      });
                                                      customSnackBar(
                                                        context,
                                                        " $responseحدث خطأ أثناء اضافة العضو",
                                                        Colors.red,
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    'تأكيد',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                      fontFamily:
                                                          AppFonts.mainFontName,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    );
                                  },
                                  tooltip: 'قبول الطلب',
                                ),
                                IconButton(
                                  icon: Icon(LucideIcons.x, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: AlertDialog(
                                              title: Text(
                                                'تأكيد الرفض',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontFamily:
                                                      AppFonts.mainFontName,
                                                ),
                                              ),

                                              content: Text(
                                                'هل انت متأكد من رفض طلب  ${user['name']} للانضمام للمجموعة؟',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.onPrimary,
                                                  height: 1.9,
                                                  fontFamily:
                                                      AppFonts.mainFontName,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'الغاء',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                      fontFamily:
                                                          AppFonts.mainFontName,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isRejecting = true;
                                                    });
                                                    final response =
                                                        await rejectRequest(
                                                          token: widget.token,
                                                          requestId:
                                                              requests[index]['id'],
                                                        );
                                                    setState(() {
                                                      isRejecting = false;
                                                    });
                                                    if (response['success']) {
                                                      setState(() {
                                                        requests.removeAt(
                                                          index,
                                                        );
                                                      });

                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                      customSnackBar(
                                                        context,
                                                        "تم رفض اضافة العضو بنجاح",
                                                        Colors.green,
                                                      );
                                                    } else {
                                                     
                                                      customSnackBar(
                                                        context,
                                                        " $responseحدث خطأ أثناء اضافة العضو",
                                                        Colors.red,
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    isRejecting
                                                        ? 'جاري الرفض...'
                                                        : 'تأكيد',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                      fontFamily:
                                                          AppFonts.mainFontName,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    );
                                  },
                                  tooltip: 'رفض الطلب',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
      ),
    );
  }
}
