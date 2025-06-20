import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zameel/core/functions/get_color_by_ext.dart';
import 'package:zameel/core/networking/assignments/fetch_deliveries.dart';
import 'package:zameel/core/networking/constant.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';

class AssignmentTeacher extends StatefulWidget {
  final Map<String, dynamic> assignment;
  final String token;

  const AssignmentTeacher({
    super.key,
    required this.assignment,
    required this.token,
  });

  @override
  State<AssignmentTeacher> createState() => _AssignmentTeacherState();
}

class _AssignmentTeacherState extends State<AssignmentTeacher> {
  List deliveries = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool hasError = false;

  Future<void> fetchDeliveries({int page = 1}) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    final result = await fetchAssignmentDelivereis(
      token: widget.token,
      assignmentID: widget.assignment['id'],
      page: page,
    );

    if (result['success']) {
      final data = result['data'] as List;
      final meta = result['meta'];

      setState(() {
        currentPage = meta['current_page'];
        lastPage = meta['last_page'];
        deliveries = data;
        hasError = false;
      });
    } else {
      setState(() {
        hasError = true;
      });
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchDeliveries();
  }

  Widget _buildDeliveryCard(Map delivery) {
    final user = delivery['user'];
    final fileUrl = delivery['content'] ?? '';
    final fileName = fileUrl.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "اسم الطالب:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 5),
              Text(
                user['name'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black45
                      : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: getColorByExtension(ext).withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  width: 60,
                  height: 60,
                  child: Center(
                    child: Text(
                      ext.toUpperCase(),
                      style: TextStyle(
                        color: getColorByExtension(ext),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    LucideIcons.download,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey
                            : Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    FileDownloader.downloadFile(
                      url: "$cloudeBaseUrl$fileUrl",
                      name: "تكليف الطالب ${user['name']}",
                      onDownloadCompleted: (path) {
                        customSnackBar(
                          context,
                          "تم تحميل الملف بنجاح",
                          Colors.green,
                        );
                      },
                      onDownloadError: (error) {
                        customSnackBar(context, "تعذر التحميل", Colors.red);
                      },
                    );
                  },
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed:
                currentPage > 1 && !isLoading
                    ? () => fetchDeliveries(page: currentPage - 1)
                    : null,
            child: Text(
              "السابق",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryColor,
                fontFamily: AppFonts.mainFontName,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "الصفحة $currentPage من $lastPage",
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed:
                currentPage < lastPage && !isLoading
                    ? () => fetchDeliveries(page: currentPage + 1)
                    : null,
            child: Text(
              "التالي",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryColor,
                fontFamily: AppFonts.mainFontName,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          title: Text(
            "تسليمات التكليف",
            style: TextStyle(
              fontSize: 20,
              fontFamily: AppFonts.mainFontName,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            if (isLoading && deliveries.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (hasError && deliveries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.cloudOff, size: 48, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      "تعذر تحميل البيانات",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppFonts.mainFontName,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => fetchDeliveries(page: currentPage),
                      child: const Text("إعادة المحاولة" , style: TextStyle(fontFamily: AppFonts.mainFontName , fontSize: 12),),
                    ),
                  ],
                ),
              );
            } else if (deliveries.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد أي تسليمات حتى الآن",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.mainFontName,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => fetchDeliveries(page: currentPage),
                      child: ListView.builder(
                        itemCount: deliveries.length,
                        itemBuilder:
                            (context, index) =>
                                _buildDeliveryCard(deliveries[index]),
                      ),
                    ),
                  ),
                  _buildPaginationControls(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
