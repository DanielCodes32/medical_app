import 'package:chili_debug_view/chili_debug_view.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:medical_app/core/services/apis/apis.dart';
import 'package:medical_app/core/services/apis/base_response.dart';
import 'package:medical_app/core/services/apis/failures.dart';

class DioProvider {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: Apis.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.addAll([NetworkLoggerInterceptor()]);
  }

  static Future<Response<dynamic>> post({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) {
    return dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

   Future<Either<Failure, dynamic>> postApi({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    }on DioException catch (e) {
      return Left(_handleDioException(e) );
  }
  catch (e) {
      return Left(ServerFailure(message: e.toString()));
      
    }
  }
   Future<Either<Failure, dynamic>> getApi({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await dio.get(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    }on DioException catch (e) {
      return Left(_handleDioException(e) );
  }
  catch (e) {
      return Left(ServerFailure(message: e.toString()));
      
    }
  }
  
   Future<Either<Failure, dynamic>> deleteApi({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    }on DioException catch (e) {
      return Left(_handleDioException(e) );
  }
  catch (e) {
      return Left(ServerFailure(message: e.toString()));
      
    }
  }
   Future<Either<Failure, dynamic>> putApi({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      var response = await dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    }on DioException catch (e) {
      return Left(_handleDioException(e) );
  }
  catch (e) {
      return Left(ServerFailure(message: e.toString()));
      
    }
  }

  Future<Either<Failure, dynamic>> putId({
    required String endpoint,
    required String id,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    final finalEndpoint = endpoint.replaceAll(':id', id);
    return putApi(
      endpoint: finalEndpoint,
      queryParameters: queryParameters,
      data: data,
      headers: headers,
    );
  }

static Future<Either<Failure, dynamic>> _handleResponse(Response response) async{
if (response.statusCode == 200||response.statusCode == 201) {
      try {
        if (response.data["status"] !=null) {
          
        
        var data = BaseResponse.fromJson(response.data);
        return Right(data.data);
        }
        else {
          return Right(response.data);
        }
      } on Exception catch (err) {
        return Left(ParseFailure(message: err.toString()));
      }
    } 
    else {
      return Left(ServerFailure(message: response.data['message']));
    }
  
}
  

  static Failure _handleDioException(DioException err) {
switch (err.type) {
        case DioExceptionType.connectionTimeout:
          return ServerFailure(message: err.message);
        case DioExceptionType.sendTimeout:
          return ServerFailure(message: err.message);
        case DioExceptionType.receiveTimeout:
           return ServerFailure(message: err.message);
        case DioExceptionType.badCertificate:
          return ServerFailure(message: err.message);
        case DioExceptionType.badResponse:
         return ServerFailure(message:err.message);
         
        case DioExceptionType.cancel:
           return ServerFailure(message: err.message);
        case DioExceptionType.connectionError:
           return ServerFailure(message: err.message);
        case DioExceptionType.unknown:
         return ServerFailure(message: err.message);
      }
    } 
  

  static Future<Response<dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.get(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  static Future<Response<dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  static Future<Response<dynamic>> delete({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }
}
