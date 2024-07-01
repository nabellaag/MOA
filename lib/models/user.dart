class User {
  final String userId;
  final String name;
  final String email;
  final String token;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
