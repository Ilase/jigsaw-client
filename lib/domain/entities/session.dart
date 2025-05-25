class Session {
  String accessToken;
  String refreshToken;
  int exp;

  Session({
    required this.accessToken,
    required this.refreshToken,
    required this.exp,
  });
}
