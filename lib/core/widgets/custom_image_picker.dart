import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/core/styles/app_colors.dart';


class CustomImagePicker extends StatefulWidget {
  final void Function(File?) onImagePicked;
  final String? initialImagePath;

  const CustomImagePicker({
    super.key,
    required this.onImagePicked,
    this.initialImagePath,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        widget.onImagePicked(_image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.imagecolor,
                border: Border.all(color: AppColors.primaryColor, width: 2),
                image: _image != null
                    ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : (widget.initialImagePath != null
                        ? DecorationImage(
                            image: widget.initialImagePath!.startsWith('http')
                                ? NetworkImage(widget.initialImagePath!)
                                : FileImage(File(widget.initialImagePath!)) as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null),
              ),
              child: _image == null && widget.initialImagePath == null
                  ? const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    )
                  : null,
            ),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
