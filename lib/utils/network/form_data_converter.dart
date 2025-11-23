import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class FormDataConverter {
  /// Converts a Map to FormData with comprehensive type handling
  static Future<FormData> convert(
    Map<String, dynamic> map, {
    bool allowNulls = false,
    String? arrayFormat = 'bracket', // 'bracket', 'index', or 'repeat'
  }) async {
    Map<String, dynamic> formDataMap = {};

    for (final entry in map.entries) {
      await _processEntry(
        entry.key,
        entry.value,
        formDataMap,
        allowNulls: allowNulls,
        arrayFormat: arrayFormat,
      );
    }

    return FormData.fromMap(formDataMap);
  }

  static Future<void> _processEntry(
    String key,
    dynamic value,
    Map<String, dynamic> formDataMap, {
    bool allowNulls = false,
    String? arrayFormat = 'bracket',
  }) async {
    // Handle null values
    if (value == null) {
      if (allowNulls) {
        formDataMap[key] = null;
      }
      return;
    }

    // Handle different types
    if (value is File) {
      formDataMap[key] = await _fileToMultipart(value);
    } else if (value is List<File>) {
      formDataMap[key] = await _filesToMultipart(value);
    } else if (value is MultipartFile) {
      formDataMap[key] = value;
    } else if (value is List<MultipartFile>) {
      formDataMap[key] = value;
    } else if (value is Uint8List) {
      formDataMap[key] = MultipartFile.fromBytes(value, filename: '$key.bin');
    } else if (value is List) {
      _handleList(key, value, formDataMap, arrayFormat: arrayFormat);
    } else if (value is Map) {
      _handleNestedMap(key, value, formDataMap);
    } else if (value is DateTime) {
      formDataMap[key] = value.toIso8601String();
    } else if (value is bool || value is num || value is String) {
      formDataMap[key] = value.toString();
    } else {
      // For custom objects, try to convert to string
      formDataMap[key] = value.toString();
    }
  }

  static Future<MultipartFile> _fileToMultipart(File file) async {
    String fileName = file.path.split('/').last;
    return MultipartFile.fromFile(file.path, filename: fileName);
  }

  static Future<List<MultipartFile>> _filesToMultipart(List<File> files) async {
    List<MultipartFile> multipartFiles = [];
    for (final File file in files) {
      multipartFiles.add(await _fileToMultipart(file));
    }
    return multipartFiles;
  }

  static void _handleList(
    String key,
    List list,
    Map<String, dynamic> formDataMap, {
    String? arrayFormat = 'bracket',
  }) {
    for (int i = 0; i < list.length; i++) {
      String fieldKey;

      switch (arrayFormat) {
        case 'bracket':
          fieldKey = '$key[]';
          break;
        case 'index':
          fieldKey = '$key[$i]';
          break;
        case 'repeat':
          fieldKey = key;
          break;
        default:
          fieldKey = '$key[$i]';
      }

      if (formDataMap.containsKey(fieldKey) && arrayFormat == 'repeat') {
        // If using repeat format and key exists, convert to list
        var existing = formDataMap[fieldKey];
        if (existing is List) {
          existing.add(list[i].toString());
        } else {
          formDataMap[fieldKey] = [existing, list[i].toString()];
        }
      } else {
        formDataMap[fieldKey] = list[i].toString();
      }
    }
  }

  static void _handleNestedMap(
    String key,
    Map map,
    Map<String, dynamic> formDataMap,
  ) {
    map.forEach((nestedKey, nestedValue) {
      String fullKey = '$key[$nestedKey]';
      if (nestedValue != null) {
        formDataMap[fullKey] = nestedValue.toString();
      }
    });
  }
}
