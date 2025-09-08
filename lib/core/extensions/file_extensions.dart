import 'dart:io';

extension FileExtension on FileSystemEntity {
  String get name {
    return this?.path?.split("/")?.last;
  }
}
