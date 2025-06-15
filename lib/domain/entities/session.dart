class Session {
  String accessToken;
  String refreshToken;
  int exp;
  // final String nickname;
  // final String role;

  Session({
    required this.accessToken,
    required this.refreshToken,
    required this.exp,
    // required this.nickname,
    // required this.role,
  });
}
