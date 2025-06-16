import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zameel/core/networking/fetch_posts_service.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';
import 'package:zameel/core/functions/get_color_by_ext.dart';
import 'package:zameel/core/models/post_model.dart';
import 'package:zameel/features/home/posts/publish_post.dart';
import 'package:zameel/features/home/posts/shimmer_effect.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();
  final PostService _postService = PostService();

  List<PostModel> posts = [];
  bool isLoading = false;
  bool erorOccurred = false;
  bool hasMore = true;
  String? lastCursor;
  int? roll;
  @override
  void initState() {
    super.initState();
    getRoll();
    getPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        getPosts();
      }
    });
  }

  Future<void> getRoll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    roll = prefs.getInt('roll');
  }

  Future<void> refreshPosts() async {
    setState(() {
      posts.clear();
      lastCursor = null;
      hasMore = true;
    });
    await getPosts();
  }

  String formatDateForCursor(DateTime dateTime) {
    return "${dateTime.year.toString().padLeft(4, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}:"
        "${dateTime.second.toString().padLeft(2, '0')}";
  }

  Future<void> getPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await _postService.fetchPostsService(
        token: token,
        cursor: lastCursor,
        before: true,
      );

      if (result['success'] == true) {
        final List<PostModel> newPosts = result['data'] as List<PostModel>;
        setState(() {
          posts.addAll(newPosts);
          if (newPosts.isNotEmpty) {
            lastCursor = formatDateForCursor(newPosts.last.createdAt);
          } else {
            hasMore = false;
          }
        });
      } else {
        setState(() {
          erorOccurred = true;
          hasMore = false;

          // print("Error fetching posts: ");
        });
      }
    } catch (e) {
      customSnackBar(context, "$e", Colors.red);
      setState(() {
        erorOccurred = true;
        hasMore = false;
        // print("Error fetching posts: $e");
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getPosition(int number) {
    switch (number) {
      case 1:
        return "مشرف";
      case 2:
        return "اداري";
      case 3:
        return "اكاديمي";
      case 4:
        return "مندوب";
      case 5:
        return "طالب";
      default:
        return "غير معروف";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Column(
          children: [
            CustomTextField(
              contentHeight: 16,
              hasPrefix: true,
              prefixIcon: LucideIcons.search,
              hintText: "ملزمة قواعد البيانات",
              isPassword: false,
              controller: SearchController(),
            ),
          ],
        ),
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body:
          erorOccurred
              ? Center(
                child: Text(
                  "حدث خطأ أثناء تحميل المنشورات",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 16,
                  ),
                ),
              )
              : RefreshIndicator(
                onRefresh: refreshPosts,
                child:
                    posts.isEmpty && isLoading
                        ? ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            if (index == 1) {
                              return ShimmerItem(hasImage: true);
                            }
                            return ShimmerEffect();
                          },
                        )
                        : ListView.builder(
                          controller: _scrollController,
                          itemCount: posts.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == posts.length) {
                              return Center(
                                child:
                                    hasMore
                                        ? Column(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              child: const LoadingIndicator(
                                                indicatorType:
                                                    Indicator.ballPulse,
                                                colors: [
                                                  AppColors.primaryColor,
                                                ],
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        )
                                        : Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              "لا توجد منشورات جديدة",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                              );
                            }

                            final post = posts[index];

                            return Container(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                              margin: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // الكاتب
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      right: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/avatar.png",
                                          width: 40,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  post.authorName,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                const Text("•"),
                                                const SizedBox(width: 5),
                                                Text(
                                                  getPosition(
                                                    post.authorRollID,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              post.formattedDate,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // المحتوى
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 18,
                                      left: 12,
                                    ),
                                    child: Text(
                                      post.content,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // الصور
                                  if (post.hasImages)
                                    post.imageFiles.length == 1
                                        ? CachedNetworkImage(
                                          imageUrl:
                                              'https://zameel.s3.amazonaws.com/${post.imageFiles[0].urls[0]}',
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (_, __) => Shimmer.fromColors(
                                                baseColor:
                                                    Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.light
                                                        ? Colors.grey[300]!
                                                        : Colors.grey[800]!,
                                                highlightColor:
                                                    Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.light
                                                        ? Colors.grey[100]!
                                                        : Colors.grey[800]!
                                                            .withValues(
                                                              alpha: 0.9,
                                                            ),
                                                child: Container(
                                                  color: Colors.white,
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Icon(LucideIcons.cloudOff),
                                        )
                                        : ImageSlideshow(
                                          width: double.infinity,
                                          height: 320,
                                          children: [
                                            ...post.imageFiles.asMap().entries.map((
                                              entry,
                                            ) {
                                              final index = entry.key;
                                              final file = entry.value;

                                              return Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (_) => Dialog(
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withValues(
                                                                      alpha:
                                                                          0.2,
                                                                    ),
                                                            insetPadding:
                                                                EdgeInsets.zero,
                                                            child: PhotoViewGallery.builder(
                                                              itemCount:
                                                                  post
                                                                      .imageFiles
                                                                      .length,
                                                              pageController:
                                                                  PageController(
                                                                    initialPage:
                                                                        index,
                                                                  ),
                                                              backgroundDecoration:
                                                                  const BoxDecoration(
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                              builder: (
                                                                context,
                                                                i,
                                                              ) {
                                                                final imageFile =
                                                                    post.imageFiles[i];
                                                                return PhotoViewGalleryPageOptions(
                                                                  imageProvider:
                                                                      CachedNetworkImageProvider(
                                                                        'https://zameel.s3.amazonaws.com/${imageFile.urls[0]}',
                                                                      ),
                                                                  heroAttributes:
                                                                      PhotoViewHeroAttributes(
                                                                        tag:
                                                                            imageFile.urls[0],
                                                                      ),
                                                                  errorBuilder:
                                                                      (
                                                                        context,
                                                                        error,
                                                                        stackTrace,
                                                                      ) => const Center(
                                                                        child: Icon(
                                                                          LucideIcons
                                                                              .cloudOff,
                                                                        ),
                                                                      ),
                                                                );
                                                              },
                                                              loadingBuilder:
                                                                  (
                                                                    context,
                                                                    event,
                                                                  ) => const Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  ),
                                                            ),
                                                          ),
                                                    );
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://zameel.s3.amazonaws.com/${file.urls[0]}',
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (
                                                          _,
                                                          __,
                                                        ) => Shimmer.fromColors(
                                                          baseColor:
                                                              Theme.of(
                                                                        context,
                                                                      ).brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors
                                                                      .grey[300]!
                                                                  : Colors
                                                                      .grey[800]!,
                                                          highlightColor:
                                                              Theme.of(
                                                                        context,
                                                                      ).brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colors
                                                                      .grey[100]!
                                                                  : Colors
                                                                      .grey[700]!,
                                                          child: Container(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                            ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),

                                  // عرض الملفات إذا كانت موجودة
                                  if (post.hasDocuments)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        children:
                                            post.documentFiles.map((file) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 8.0,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? Colors.black45
                                                            : Theme.of(
                                                              context,
                                                            ).scaffoldBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      // مربع نوع الملف
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color:
                                                              getColorByExtension(
                                                                file.ext,
                                                              ).withValues(
                                                                alpha: 0.2,
                                                              ),
                                                          borderRadius:
                                                              const BorderRadius.only(
                                                                topRight:
                                                                    Radius.circular(
                                                                      10,
                                                                    ),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                      10,
                                                                    ),
                                                              ),
                                                        ),
                                                        width: 60,
                                                        height: 60,
                                                        child: Center(
                                                          child: Text(
                                                            file.ext
                                                                .toUpperCase(), // مثل PDF, DOCX, PPTX
                                                            style: TextStyle(
                                                              color:
                                                                  getColorByExtension(
                                                                    file.ext,
                                                                  ),
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      // اسم الملف
                                                      Expanded(
                                                        child: Text(
                                                          file.name,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                              ),
                                                        ),
                                                      ),
                                                      // زر التحميل
                                                      IconButton(
                                                        icon: Icon(
                                                          LucideIcons.download,
                                                          color:
                                                              Theme.of(
                                                                        context,
                                                                      ).brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .black,
                                                          size: 20,
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                      SizedBox(width: 5),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
      floatingActionButton:
          (roll == 1 || roll == 2 || roll == 3 || roll == 4)
              ? FloatingActionButton(
                heroTag: "publishPost",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PublishPost()),
                  );
                },
                child: Icon(LucideIcons.plus),
              )
              : null,
    );
  }
}
