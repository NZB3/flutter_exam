import 'package:lecture_1_app/model/cat_model.dart';
import 'package:dio/dio.dart';

abstract class AbstractAPI {
  Future<List<Cat>?> getCats(int limit);
  Future<Cat> getCat();
}

class API implements AbstractAPI {
  static const host = 'https://api.thecatapi.com';
  final dio = Dio();



  @override
  Future<Cat> getCat() async {
    final response = await dio.get('$host/v1/images/search');
    final data = response.data as List<dynamic>;
    final catData = data.first as Map<String, dynamic>;
    return Cat.fromJson(catData);
  }

  @override
  Future<List<Cat>?> getCats(int limit) async {
    final response = await dio.get('$host/v1/images/search?limit=$limit');
    final data = response.data as List<dynamic>;
    final first = data.isNotEmpty ? data.first : null;

    if (first is Map<String, dynamic>) {
      return (data.cast<Map<String, dynamic>>()).map((e) =>Cat.fromJson(e)).toList();
    }
  }
}