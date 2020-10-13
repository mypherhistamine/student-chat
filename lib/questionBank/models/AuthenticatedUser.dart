class AuthenticatedUser {
  String email;

  String token;

  String get emailAddress => email;

  AuthenticatedUser({this.email, this.token});

  @override
  String toString() {
    return 'Bearer $token';
  }

  AuthenticatedUser.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'token': token,
      };
}
