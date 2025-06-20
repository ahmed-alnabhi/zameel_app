String removeFileExtension(String filename) {
  int dotIndex = filename.lastIndexOf('.');
  if (dotIndex != -1) {
    return filename.substring(0, dotIndex);
  }
  return filename;
}
