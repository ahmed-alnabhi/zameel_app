import 'package:flutter/material.dart';
import 'package:zameel/core/functions/get_roll_id.dart';
import 'package:zameel/core/functions/get_token.dart';
import 'package:zameel/core/networking/resources_services/fetch_student_groups.dart';
import 'package:zameel/features/home/profile/join_requests_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? roll;
  String? token;
  List<int> groupIds = [];
  Future<void> getRollAndToken() async {
    roll = await getRoll();
    setState(() {});
    token = await getToken();
    final result = await fetchStudentGroups(token: token);
    groupIds = await result['data'];
  }

  @override
  void initState() {
    super.initState();
    getRollAndToken();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 90,
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(width: 112),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "أحمد فهمي علي سعيد",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "ahmed2004.1436@gmail.com",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -15,
                    bottom: 0,
                    right: 10,
                    child: Image.asset(
                      "assets/images/avatar.png",
                      width: 90,
                      height: 90,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 300),
              if (roll == 4)
                Container(
                  //  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                       if (groupIds.isNotEmpty || token != null) {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => JoinRequestsScreen(
                                    groupId: groupIds.first,
                                    token: token!,
                                  ),
                            ),
                          );
                       }
                        },
                        icon: Icon(Icons.arrow_back_ios_new),
                      ),
                      Text("طلبات الانضمام", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),

              ElevatedButton(
                onPressed: () {
                  //  final result = await fetchJoinRequests(token: "49|JX9bCmlxMGefGihRuHrgHmXwC9TDabwXXPWk5fIn0ee27d0f", groupId: 1);
                },
                child: Text("data"),

              ),
            ],
          ),
        ),
      ),
    );
  }
}


































 

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: erorOccurred
  //         ? Center(
  //             child: Text(
  //               "حدث خطأ أثناء تحميل المنشورات",
  //               style: TextStyle(
  //                 color: Theme.of(context).colorScheme.error,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           )
  //         : RefreshIndicator(
  //             onRefresh: refreshPosts,
  //             child: CustomScrollView(
  //               controller: _scrollController,
  //               slivers: [
  //                 SliverAppBar(
  //                   floating: true,
  //                   scrolledUnderElevation: 0,
  //                  // snap: true,
  //                   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  //                   centerTitle: true,
  //                   toolbarHeight: 60,
  //                   title: CustomTextField(
  //                           contentHeight: 16,
  //                           hasPrefix: true,
  //                           prefixIcon: LucideIcons.search,
  //                           hintText: "ملزمة قواعد البيانات",
  //                           isPassword: false,
  //                           controller: SearchController(),
  //                         ),
  //                   elevation: 0,
  //                 ),
                 
  //                 if (posts.isEmpty && isLoading)
  //                   SliverList(
  //                     delegate: SliverChildBuilderDelegate(
  //                       (context, index) {
  //                         if (index == 1) {
  //                           return ShimmerItem(hasImage: true);
  //                         }
  //                         return ShimmerEffect();
  //                       },
  //                       childCount: 5,
  //                     ),
  //                   )
  //                 else
  //                   SliverList(
  //                     delegate: SliverChildBuilderDelegate(
  //                       (BuildContext context, int index) {
  //                         if (index == posts.length) {
  //                           return Center(
  //                             child: hasMore
  //                                 ? Column(
  //                                     children: [
  //                                       SizedBox(
  //                                         width: 30,
  //                                         child: const LoadingIndicator(
  //                                           indicatorType: Indicator.ballPulse,
  //                                           colors: [
  //                                             AppColors.primaryColor,
  //                                           ],
  //                                           strokeWidth: 2,
  //                                         ),
  //                                       ),
  //                                       const SizedBox(height: 10),
  //                                     ],
  //                                   )
  //                                 : Column(
  //                                     children: [
  //                                       const SizedBox(height: 10),
  //                                       const Text(
  //                                         "لا توجد منشورات جديدة",
  //                                         style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           color: AppColors.primaryColor,
  //                                         ),
  //                                       ),
  //                                       const SizedBox(height: 20),
  //                                     ],
  //                                   ),
  //                           );
  //                         }