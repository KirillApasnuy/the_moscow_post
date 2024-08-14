import "package:html/parser.dart";

class EditText {
  static String removeHtmlTag(String htmlText) {
    // Удаляем HTML-теги и получаем текст
    String plainText = parse(parse(htmlText).body!.text).documentElement!.text;
    return plainText;
    // Добавляем пробелы после каждой точки
  }

  // Метод для добавления пробелов после точек
  static String addHttpInUri(String text) {
    return text.replaceAll('176', 'http://176'); // Заменяем каждую точку на точку с пробелом
  }
}