class LoginHistoryEntity {
  final String username;
  final String loginTime;
  final String status;
  final String? clientIp;
  final String? userAgent;

  LoginHistoryEntity({
    required this.username,
    required this.loginTime,
    required this.status,
    this.clientIp,
    this.userAgent,
  });

  factory LoginHistoryEntity.fromJson(Map<String, dynamic> json) {
    return LoginHistoryEntity(
      username: json['username'] ?? '',
      loginTime: json['loginTime'] ?? '',
      status: json['status'] ?? '',
      clientIp: json['clientIp'],
      userAgent: json['userAgent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'loginTime': loginTime,
      'status': status,
      'clientIp': clientIp,
      'userAgent': userAgent,
    };
  }
}
