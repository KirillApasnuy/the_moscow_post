import 'package:the_moscow_post/data/models/pages.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';

class PagesController {
  final Repository _repository;

  PagesController(this._repository);

  Future<List<Pages>> fetchPageList() {
    return _repository.getPageList();
  }
}