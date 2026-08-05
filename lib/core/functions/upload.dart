import 'dart:io';
import 'package:dio/dio.dart';
import 'package:medical_app/core/services/apis/apis.dart';

Future<String?> uploadToCloudinary(File imageFile) async {
  try {
    final dio = Dio();
    final url = "https://api.cloudinary.com/v1_1/${Apis.cloudinaryCloudName}/image/upload";
    
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
      'upload_preset': Apis.cloudinaryUploadPreset,
    });

    final response = await dio.post(url, data: formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data != null && data['secure_url'] != null) {
        return data['secure_url'] as String;
      }
    }
    return null;
  } catch (e) {
    return null;
  }
}
