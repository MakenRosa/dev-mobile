class AccountProfile {
  final String accountId;
  final String? emailAddress;
  final String? nickname;
  
  AccountProfile({
    required this.accountId,
    required this.emailAddress,
    this.nickname,
  });

  AccountProfile.anonymous({required this.accountId})
      : emailAddress = null,
        nickname = null;

  factory AccountProfile.fromMap(Map<String, dynamic> map) {
    return AccountProfile(
      accountId: map['accountId'],
      emailAddress: map['emailAddress'],
      nickname: map['nickname'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'emailAddress': emailAddress,
      'nickname': nickname,
    };
  }
}
