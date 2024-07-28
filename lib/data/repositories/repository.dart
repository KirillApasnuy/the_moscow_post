import 'package:get/get.dart';
import 'package:the_moscow_post/data/models/articles.dart';

import '../../utils/constans/strings.dart';
import '../models/news.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class Repository {
  final String _baseUrl = "https://nmapi.ru/mp/";
  Future<List<News>> getNewsList() async {
    List<News> newsList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    for (var i = 0; i < body.length; i++) {
      newsList.add(News.fromJson(body[i]));
    }
    return newsList;
  }

  Future<List<News>> getMoreNewsList(int page) async {
    List<News> moreNewsList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&page=$page");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    for (var i = 0; i < body.length; i++) {
      moreNewsList.add(News.fromJson(body[i]));
    }
    return moreNewsList;
  }

  Future<List<News>> getNewsRubricNameList(int rubricId) async {
    List<News> newsList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&rubric_id=$rubricId");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    for (var i = 0; i < body.length; i++) {
      newsList.add(News.fromJson(body[i]));
    }
    return newsList;
  }

  Future<List<News>> getMoreNewsRubricNameList(int rubricId, int page) async {
    List<News> newsList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&rubric_id=$rubricId&page=$page");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    for (var i = 0; i < body.length; i++) {
      newsList.add(News.fromJson(body[i]));
    }
    return newsList;
  }

  Future<List<News>> getNewsSearchList(String search) async {
    List<News> newsSearchList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&search=$search");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    for (var i = 0; i < body.length; i++) {
      newsSearchList.add(News.fromJson(body[i]));
    }
    return newsSearchList;
  }

  Future<News> getNewsId(int id) async {
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&id=$id");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"];
    News news = News.fromJson(body);
    return news;
  }
  Future<List<Articles>> getArticlesList() async {
    List<Articles> articlesList = [];
    var url = Uri.parse("${_baseUrl}articles?key=${Strings.apiKeyNmapi}");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["articles"];
    for (var i = 0; i < body.length; i++) {
      articlesList.add(Articles.fromJson(body[i]));
    }
    return articlesList;
  }

  Future<List<Articles>> getMoreArticlesList(int page) async {
    List<Articles> moreArticlesList = [];
    var url = Uri.parse("${_baseUrl}articles?key=${Strings.apiKeyNmapi}&page=$page");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["articles"];
    for (var i = 0; i < body.length; i++) {
      moreArticlesList.add(Articles.fromJson(body[i]));
    }
    return moreArticlesList;
  }
}
