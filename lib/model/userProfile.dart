class userProfile {
   String displayName;
   String domain;
   String email;
   String userid;
   String token;
  userProfile(
      {this.displayName, this.domain, this.email, this.userid, this.token});

   factory userProfile.fromJson(Map<String, dynamic> json) {
    return userProfile(
      displayName: json['DisplayName'],
      domain: json['Domain'],
      email: json['Email'],
      userid: json['UserId'],
      token: json['Token'],
    );
  }
}
