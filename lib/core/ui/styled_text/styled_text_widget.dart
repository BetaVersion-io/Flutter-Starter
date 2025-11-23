import 'package:betaversion/theme/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextPiece {
  final String text;
  final TextStyle? style;
  final VoidCallback? onTap;

  const TextPiece({required this.text, this.style, this.onTap});
}

class StyledText extends StatelessWidget {
  final List<TextPiece> pieces;
  final TextAlign textAlign;
  final TextStyle? defaultStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const StyledText({
    super.key,
    required this.pieces,
    this.textAlign = TextAlign.start,
    this.defaultStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
        style: defaultStyle,
        children: pieces.map((piece) {
          return TextSpan(
            text: piece.text,
            style: piece.style,
            recognizer: piece.onTap != null
                ? (TapGestureRecognizer()..onTap = piece.onTap)
                : null,
          );
        }).toList(),
      ),
    );
  }
}

class TextStyles {
  static TextStyle subtitle(BuildContext context) =>
      TextStyle(fontSize: 14, color: AppColors.subtitleColor(context));

  static const TextStyle clickable = TextStyle(
    color: AppColors.midNightBlue500,
    decoration: TextDecoration.underline,
  );

  static const TextStyle bold = TextStyle(fontWeight: FontWeight.bold);

  static TextStyle primary(BuildContext context) => TextStyle(
    color: Theme.of(context).primaryColor,
    fontWeight: FontWeight.w600,
  );
}
