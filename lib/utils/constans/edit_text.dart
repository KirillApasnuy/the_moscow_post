import 'package:html/parser.dart';

class EditText {
  static String removeHtmlTag(String htmlText) {
    // Удаляем HTML-теги и получаем текст
    String plainText = parse(parse(htmlText).body!.text).documentElement!.text;

    // Добавляем пробелы после каждой точки
    return addSpaceAfterPeriod(plainText);
  }

  // Метод для добавления пробелов после точек
  static String addSpaceAfterPeriod(String text) {
    return text.replaceAll('.', '. '); // Заменяем каждую точку на точку с пробелом
  }
}