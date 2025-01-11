class User {
  final String email;
  final String password;
  final String userId;

  User({required this.email, required this.password, required this.userId});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['user']['email'],
      password: json['user']['password'],
      userId: json['user']['_id'],
    );
  }
}
