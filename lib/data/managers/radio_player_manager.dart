import "package:shared_preferences/shared_preferences.dart";
import "package:radio_player/radio_player.dart";

class RadioPlayerManager {
  late RadioPlayer _radioPlayer;
  bool _isPlaying = false;

  RadioPlayerManager() {
    _radioPlayer = RadioPlayer();
  }

  Future<void> initialize(String title, String url) async {
    _radioPlayer.setChannel(title: title, url: url);
    await _loadPlayingState();
    if (_isPlaying) {
      play();
    }
  }

  bool get isPlaying => _isPlaying;

  Future<void> play() async {
    await _radioPlayer.play();
    _isPlaying = true;
    _savePlayingState();
  }

  Future<void> pause() async {
    await _radioPlayer.pause();
    _isPlaying = false;
    _savePlayingState();
  }

  Future<void> _loadPlayingState() async {
    final prefs = await SharedPreferences.getInstance();
    _isPlaying = prefs.getBool('isPlaying') ?? false;
  }

  Future<void> _savePlayingState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPlaying', _isPlaying);
  }
}
