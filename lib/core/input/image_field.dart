import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

/// Generic Image Field component with FormBuilder integration
///
/// This component provides a FormBuilder field for image selection with
/// an integrated bottom sheet modal for camera, gallery, and remove options.
/// Can be reused across multiple screens.
class InputImageField extends StatelessWidget {
  final String name;
  final String? label;
  final String? Function(File?)? validator;
  final bool enabled;
  final File? initialValue;
  final void Function(File?)? onChanged;
  final Widget Function(File? value, VoidCallback onTap)? builder;

  const InputImageField({
    required this.name,
    super.key,
    this.label,
    this.validator,
    this.enabled = true,
    this.initialValue,
    this.onChanged,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<File?>(
      name: name,
      validator: validator,
      enabled: enabled,
      initialValue: initialValue,
      onChanged: onChanged,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(8),
            ],
            builder?.call(
                  field.value,
                  () => _showImagePickerModal(context, field),
                ) ??
                _defaultBuilder(context, field),
            if (field.hasError) ...[
              const Gap(8),
              Text(
                field.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _defaultBuilder(BuildContext context, FormFieldState<File?> field) {
    return GestureDetector(
      onTap: enabled ? () => _showImagePickerModal(context, field) : null,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: field.hasError
              ? Border.all(color: Theme.of(context).colorScheme.error)
              : null,
        ),
        child: field.value != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(field.value!, fit: BoxFit.cover),
              )
            : const Icon(Iconsax.image, size: 40, color: Colors.grey),
      ),
    );
  }

  void _showImagePickerModal(
    BuildContext context,
    FormFieldState<File?> field,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return ImagePickerModal(
          onImageSelected: (image) {
            field.didChange(image);
          },
          currentImage: field.value,
        );
      },
    );
  }
}

/// Reusable Image Picker Modal
///
/// A bottom sheet modal that provides options for camera, gallery, and remove.
/// Can be used independently or with InputImageField.
class ImagePickerModal extends StatelessWidget {
  final void Function(File?) onImageSelected;
  final File? currentImage;
  final bool showRemove;

  const ImagePickerModal({
    required this.onImageSelected,
    super.key,
    this.currentImage,
    this.showRemove = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(40),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(40),

          // Options row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ImageOption(
                icon: Iconsax.camera,
                label: 'Camera',
                onTap: () async {
                  context.pop();
                  final ImagePicker picker = ImagePicker();
                  try {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      onImageSelected(File(image.path));
                    }
                  } catch (e) {
                    debugPrint('Error picking image from camera: $e');
                  }
                },
              ),
              _ImageOption(
                icon: Iconsax.gallery,
                label: 'Gallery',
                onTap: () async {
                  context.pop();
                  final ImagePicker picker = ImagePicker();
                  try {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      onImageSelected(File(image.path));
                    }
                  } catch (e) {
                    debugPrint('Error picking image from gallery: $e');
                  }
                },
              ),
              if (showRemove && currentImage != null)
                _ImageOption(
                  icon: Iconsax.trash,
                  label: 'Remove',
                  onTap: () {
                    context.pop();
                    onImageSelected(null);
                  },
                ),
            ],
          ),
          const Gap(40),
        ],
      ),
    );
  }
}

/// Individual image option button
class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24),
          ),
          const Gap(8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
