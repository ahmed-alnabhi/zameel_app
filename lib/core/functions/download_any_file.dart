
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

donloadAnyfile() {
     FileDownloader.downloadFile(
                      name: "My Book",
                      subPath: " /storage/emulated/0/Download/zameel",
                      url:
                          'https://zameel.s3.amazonaws.com/books/5IsWJQgfXktyj7bXN9ykY7wcxr7sv69vwx1FwQSP.pdf',
                      onProgress: (fileName, progress) {
                        print("Progress: $progress");
                      },
                      onDownloadCompleted: (value) {
                        print("Download completed: $value");
                      },
                    );
}