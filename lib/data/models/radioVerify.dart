class RadioVerify {
  final bool radioOn;
  final String radioHost;

  const RadioVerify({required this.radioHost, required this.radioOn});

  factory RadioVerify.fromJson(Map<dynamic, dynamic> json) {
    return RadioVerify(radioOn: json["radio_on"], radioHost: json["radio_host"]);
  }

  Map<String, dynamic> toJson() => {
        "radioOn": radioOn,
        "radioHost": radioHost,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RadioVerify &&
        radioOn == other.radioOn &&
        radioHost == other.radioHost;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;


}
