import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/networking/posts_services/send_post_with_Images.dart';
import 'package:zameel/core/networking/posts_services/send_post_with_file.dart';
import 'package:zameel/core/networking/resources_services/fetch_student_groups.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';

class PublishPost extends StatefulWidget {
  const PublishPost({super.key});

  @override
  State<PublishPost> createState() => _PublishPostState();
}

class _PublishPostState extends State<PublishPost> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _contentController = TextEditingController();
  List<XFile> _imageFiles = [];
  XFile? _selectedFile;
  List<int> groupIds = [];
  Future<void> _pickAndCropImages() async {
    if (_selectedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ لا يمكنك اختيار صور إذا كان هناك ملف مرفق" , style: TextStyle(fontSize: 14))),
      );
      return;
    }

    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(title: 'قص الصورة'),
          ],
        );
        if (croppedFile != null) {
          setState(() {
            _imageFiles.add(XFile(croppedFile.path));
          });
        }
      }
    }
  }

  Future<void> _pickFile() async {
    if (_imageFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ لا يمكنك اختيار ملف إذا كانت هناك صور مضافة" , style: TextStyle(fontSize: 14),),
        ),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = XFile(result.files.single.path!);
      });
    }
  }

  Future<void> _publishPost(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final content = _contentController.text.trim();

    if (content.isEmpty && _imageFiles.isEmpty && _selectedFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("لا يمكن نشر منشور فارغ" , style: TextStyle(fontSize: 14),)));
      return;
    }
    final result = await fetchStudentGroups(token: token);
    if (result['success']) {
      
      groupIds = await result['data'];
       showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    try {
      if (_selectedFile != null) {
        final resultPostFile = await sendPostWithFile(
          token: token!,
          taggableId: groupIds.first,
          file: File(_selectedFile!.path),
          content: content,
        );

        Navigator.pop(context);
        if (resultPostFile['success']) {
          customSnackBar(context, resultPostFile['message'], Colors.green);
        } else {
          customSnackBar(context, resultPostFile['message'], Colors.red);
        }
      } else {
        final resultPostImages = await sendPostWithImages(
          token: token!,
          taggableId: groupIds.first,
          files: _imageFiles.map((e) => File(e.path)).toList(),
          content: content,
        );
        Navigator.pop(context);
        if (resultPostImages['success']) {
          customSnackBar(context, resultPostImages['message'], Colors.green);
        } else {
          customSnackBar(context, resultPostImages['message'], Colors.red);
        }
      }

      setState(() {
        _imageFiles.clear();
        _selectedFile = null;
        _contentController.clear();
      });
    } catch (e) {
      Navigator.pop(context);
      
      customSnackBar(context, "تعذر الارسال $e $groupIds", Colors.red);
    }

    } else {
      customSnackBar(context, "حدث خطأ", Colors.red);
      return;
    }
   
  }

  @override
  void initState() {
    super.initState();
    // getToken() async{
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    //  token = prefs.getString('token');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 24,
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      LucideIcons.x,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  width: double.infinity,
                  child: TextField(
                    controller: _contentController,
                    style: TextStyle(
                      fontFamily: AppFonts.mainFontName,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "أكتب منشورك هنا ...",
                      hintStyle: Theme.of(context).textTheme.displayMedium,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // ✅ عرض الصور المختارة
              if (_imageFiles.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageFiles.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_imageFiles[index].path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _imageFiles.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              // ✅ عرض اسم الملف إن وُجد
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedFile!.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() => _selectedFile = null);
                        },
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: _pickAndCropImages,
                    icon: Icon(
                      LucideIcons.imagePlus,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: _pickFile,
                    icon: Icon(
                      LucideIcons.filePlus,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: "نشر",
                      onPressed: () => _publishPost(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}