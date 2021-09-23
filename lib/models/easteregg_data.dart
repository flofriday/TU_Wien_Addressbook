class EastereggData {
  // I am sorry but finding these eastereggs is unfortunatly not as easy as
  // just reading the sourcecode ;)
  Map _secretData = {
    "c7ab8fad3f1c9f106552470d17aa127d7175515f14e4305eeaf741edd240be54": [
      "💻",
      "Damn, would I have known how hard it is to write this app, I would "
          "never have started."
    ],
    "ed2b39afbee09da8914f48f60acc9324e0e03319f3a77084e0eb545803cdcf02": [
      "🎒",
      "Thank you for carrying me through the HTL :)"
    ],
    "a26ae7102a0455abde45ca44fe8ddb650426eadd33e6b4b9caf49696bd6d38a5": [
      "👩🏻‍🏫",
      "You can never quote too much New Girl."
    ],
    "216c68396fa165455d855cb044815074b4a00e3f23ac05baa974568d592e0212": [
      "😍👾",
      "You will always be me first nerd-crush (and thank you for coining "
          "the term nerd-crush)."
    ],
    "5d8144f1445a4e551b9f443c0e6e1dfec31f1d397e7d45ce8127c12ecc916a6f": [
      "🚀🔥",
      "Life is more fun beeing a pyromaniac."
    ]
  };

  String? getHeader(String key) {
    if (!_secretData.containsKey(key)) return null;
    return _secretData[key]![0];
  }

  String? getBody(String key) {
    if (!_secretData.containsKey(key)) return null;
    return _secretData[key]![1];
  }
}
