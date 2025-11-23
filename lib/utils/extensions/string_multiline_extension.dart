/// Extension for handling multiline strings from Remote Config
///
/// Provides utilities for working with strings that contain escaped newlines (\n)
/// from Firebase Remote Config or other sources.
extension StringMultilineExtension on String {
  /// Checks if this string contains newline characters
  ///
  /// Returns true if the string contains `\n` (actual newline or escaped)
  bool get hasNewlines => contains('\n') || contains(r'\n');

  /// Gets the number of lines in this string
  ///
  /// Counts actual newlines (\n), not escaped ones (\\n)
  int get lineCount => split('\n').length;

  /// Splits string into lines
  ///
  /// Returns a list of strings, one for each line
  List<String> get lines => split('\n');

  /// Checks if a line is a numbered list item (e.g., "1. Item")
  ///
  /// Matches patterns like: "1. ", "2. ", "10. ", etc.
  bool get isNumberedListItem => RegExp(r'^\s*\d+\.\s').hasMatch(this);

  /// Checks if a line is a bullet point (e.g., "• Item" or "- Item")
  ///
  /// Matches patterns like: "• ", "- ", "* ", "○ "
  bool get isBulletPoint =>
      RegExp(r'^\s*[•\-*○]\s').hasMatch(this) || startsWith('  ');

  /// Checks if this line is empty or contains only whitespace
  bool get isEmptyLine => trim().isEmpty;

  /// Gets indentation level of the line
  ///
  /// Returns number of leading spaces
  int get indentationLevel {
    final match = RegExp(r'^(\s*)').firstMatch(this);
    return match?.group(1)?.length ?? 0;
  }

  /// Removes numbered list prefix (e.g., "1. Item" -> "Item")
  String get withoutListNumber => replaceFirst(RegExp(r'^\s*\d+\.\s*'), '');

  /// Removes bullet point prefix (e.g., "• Item" -> "Item")
  String get withoutBulletPoint => replaceFirst(RegExp(r'^\s*[•\-*○]\s*'), '');

  /// Detects the line type for formatting purposes
  LineType get lineType {
    if (isEmptyLine) return LineType.empty;
    if (isNumberedListItem) return LineType.numberedItem;
    if (isBulletPoint) return LineType.bulletPoint;
    return LineType.text;
  }

  /// Normalizes a multiline string for display
  ///
  /// Handles both escaped (\\n) and actual (\n) newlines
  String get normalized {
    // Replace escaped newlines with actual newlines
    String result = replaceAll(r'\n', '\n');
    // Remove excessive blank lines (more than 2 consecutive)
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    // Trim trailing/leading whitespace
    return result.trim();
  }

  /// Formats as rich text with proper line spacing
  ///
  /// Returns a formatted string with consistent spacing:
  /// - Empty lines become single newlines
  /// - List items get proper indentation
  String get formatted {
    final normalizedText = normalized;
    final textLines = normalizedText.split('\n');

    return textLines
        .map((line) {
          final trimmedLine = line.trim();
          if (trimmedLine.isEmpty) return '';

          // Add spacing for numbered items
          if (trimmedLine.isNumberedListItem) {
            return '  $trimmedLine';
          }

          return trimmedLine;
        })
        .join('\n');
  }
}

/// Enum representing different line types in multiline text
enum LineType {
  /// Empty line (blank line for spacing)
  empty,

  /// Regular text line
  text,

  /// Numbered list item (e.g., "1. Item")
  numberedItem,

  /// Bullet point item (e.g., "• Item")
  bulletPoint,
}

/// Helper class for working with multiline Remote Config strings
class MultilineStringHelper {
  /// Parses a multiline string into structured line data
  ///
  /// Returns a list of [LineData] objects with metadata about each line
  static List<LineData> parse(String text) {
    final normalized = text.normalized;
    final lines = normalized.split('\n');

    return lines.asMap().entries.map((entry) {
      final index = entry.key;
      final line = entry.value;
      final trimmed = line.trim();

      return LineData(
        index: index,
        content: line,
        trimmedContent: trimmed,
        type: trimmed.lineType,
        indentLevel: line.indentationLevel,
        isEmpty: trimmed.isEmpty,
      );
    }).toList();
  }

  /// Checks if text contains instructions or steps
  ///
  /// Returns true if text has numbered items suggesting step-by-step instructions
  static bool hasInstructions(String text) {
    final lines = text.normalized.split('\n');
    return lines.any((line) => line.trim().isNumberedListItem);
  }

  /// Extracts just the instruction steps from text
  ///
  /// Returns only the numbered list items
  static List<String> extractInstructions(String text) {
    final lines = text.normalized.split('\n');
    return lines
        .where((line) => line.trim().isNumberedListItem)
        .map((line) => line.trim())
        .toList();
  }

  /// Formats text for display in dialogs or alerts
  ///
  /// Optimizes spacing and formatting for better readability
  static String formatForDialog(String text) {
    return text.formatted;
  }

  /// Estimates the height needed to display this text
  ///
  /// Uses average line height and character count
  /// [fontSize] - Font size in logical pixels
  /// [lineHeight] - Line height multiplier (e.g., 1.5)
  /// [maxWidth] - Maximum width available for text
  ///
  /// Returns estimated height in logical pixels
  static double estimateHeight({
    required String text,
    required double fontSize,
    double lineHeight = 1.5,
    double maxWidth = 300,
  }) {
    final lines = text.normalized.split('\n');
    final totalLines = lines.length;
    final avgCharsPerLine = maxWidth / (fontSize * 0.6); // Rough estimate

    // Count wrapped lines
    int wrappedLines = 0;
    for (final line in lines) {
      if (line.length > avgCharsPerLine) {
        wrappedLines += (line.length / avgCharsPerLine).ceil();
      }
    }

    final effectiveLines = totalLines + wrappedLines;
    return effectiveLines * fontSize * lineHeight;
  }
}

/// Data class representing a parsed line of text
class LineData {
  const LineData({
    required this.index,
    required this.content,
    required this.trimmedContent,
    required this.type,
    required this.indentLevel,
    required this.isEmpty,
  });

  /// Line index (0-based)
  final int index;

  /// Original line content (with whitespace)
  final String content;

  /// Trimmed line content
  final String trimmedContent;

  /// Type of line
  final LineType type;

  /// Indentation level (number of leading spaces)
  final int indentLevel;

  /// Whether the line is empty
  final bool isEmpty;

  /// Whether this line is a list item (numbered or bullet)
  bool get isListItem =>
      type == LineType.numberedItem || type == LineType.bulletPoint;

  @override
  String toString() =>
      'LineData(#$index, type=$type, content="$trimmedContent")';
}
