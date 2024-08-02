import 'package:the_moscow_post/data/models/news.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';

class NewsController {
  final Repository _repository;

  NewsController(this._repository);

  Future<List<News>> fetchNewsList() async {
    return _repository.getNewsList();
  }

  Future<List<News>> fetchMoreNewsList(int page) async {
    return _repository.getMoreNewsList(page);
  }

  Future<List<News>> fetchNewsRubricNameList(int rubricId) async{
    return _repository.getNewsRubricNameList(rubricId);
  }

  Future<List<News>> fetchMoreNewsRubricNameList(int rubricId, int page) async {
    return _repository.getMoreNewsRubricNameList(rubricId, page);
  }

  Future<List<News>> fetchNewsSearchList(String search) async {
    return _repository.getNewsSearchList(search);
  }

  Future<List<News>> fetchMoreNewsSearchList(String search, int page) async {
    return _repository.getMoreNewsSearchList(search, page);
  }

  Future<News> fetchNewsId(int id) async {
    return _repository.getNewsId(id);
  }

  Future<News> fetchNewsHour() async {
    return _repository.getNewsHour();
  }
}