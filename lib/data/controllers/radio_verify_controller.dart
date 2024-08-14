import "package:the_moscow_post/data/models/radioVerify.dart";
import "package:the_moscow_post/data/repositories/repository.dart";

class RadioVerifyController {
  final Repository _repository;

  RadioVerifyController( this._repository);

  Future<RadioVerify> fetchRadioVerify() {
    return _repository.getRadioVerify();
  }
}