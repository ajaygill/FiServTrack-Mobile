class AppSession {
  AppSession._();

  static final AppSession _instance = AppSession._();

  static AppSession get instance => _instance;

  String? _publicKey;
  String? _accessToken;
  String? _refreshToken;
  String? _userId;

  String? get publicKey => _publicKey;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get userId => _userId;

  void setPublicKey(String key) => _publicKey = key;
  void setAccessToken(String token) => _accessToken = token;
  void setRefreshToken(String token) => _refreshToken = token;
  void setUserId(String id) => _userId = id;

  void clearSession() {
    _publicKey = null;
    _accessToken = null;
    _refreshToken = null;
    _userId = null;
  }
}
