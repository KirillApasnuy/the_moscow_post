import 'package:get/get.dart';
import 'package:the_moscow_post/data/models/pages.dart';
import 'package:the_moscow_post/data/models/radioVerify.dart';

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
    var body = json.decode(response.body);
    newsList.add(News.fromJson(body["topic_hour"], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == true ? true : false));
    body = body["data"]["all"];
    for (var i = 0; i < body.length; i++) {
      newsList.add(News.fromJson(body[i], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == true ? true : false));
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
      moreNewsList.add(News.fromJson(body[i], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == "true" ? true : false));
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
      newsList.add(News.fromJson(body[i], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == "true" ? true : false));
    }
    print(body);
    return newsList;
  }

  Future<List<News>> getMoreNewsRubricNameList(int rubricId, int page) async {
    List<News> newsList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&rubric_id=$rubricId&page=$page");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    for (var i = 0; i < body.length; i++) {
      newsList.add(News.fromJson(body[i], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == "true" ? true : false));
    }
    return newsList;
  }

  Future<List<News>> getNewsSearchList(String search) async {
    List<News> newsSearchList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&search=$search");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    print(body[0]);
    for (var i = 0; i < body.length; i++) {
      newsSearchList.add(News.fromJson(body[i], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == "true" ? true : false));
    }
    return newsSearchList;
  }

  Future<List<News>> getMoreNewsSearchList(String search, int page) async {
    List<News> moreNewsSearchList = [];
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&search=$search&page=$page");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["all"];
    print(body[0]);
    for (var i = 0; i < body.length; i++) {
      moreNewsSearchList.add(News.fromJson(body[i], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == "true" ? true : false));
    }
    return moreNewsSearchList;
  }

  Future<News> getNewsId(int id) async {
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}&id=$id");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"];
    News news = News.fromJson(body, json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == "true" ? true : false);
    return news;
  }

  Future<RadioVerify> getRadioVerify() async {
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body);
    RadioVerify radioVerify = RadioVerify.fromJson(body);
    return radioVerify;
  }

  Future<News> getNewsHour() async {
    var url = Uri.parse("${_baseUrl}all?key=${Strings.apiKeyNmapi}");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body);
    News newsHour = News.fromJson(body["topic_hour"], json.decode(response.body)["view_count_display"] == "true" ? true : false, json.decode(response.body)["serverHost"], json.decode(response.body)["topMenu_on"] == "true" ? true : false);
    return newsHour;
  }

  Future<List<Pages>> getPageList() async {
    List<Pages> pageList = [];
    var url = Uri.parse("${_baseUrl}pages?key=${Strings.apiKeyNmapi}");
    var response = await http.get(url);
    printInfo(info: "status code: ${response.statusCode}");
    var body = json.decode(response.body)["data"]["pages"];
    for (var i = 0; i < body.length; i++) {
      pageList.add(Pages.fromJson(body[i]));
    }
    print(pageList[0]);
    return pageList;
  }
}
