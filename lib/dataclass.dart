class user{
  final String username;
  final String password;
  final String status;

  user({required this.username,required this.password,required this.status});

  Map<String, dynamic> toJson(){
    return {
      "username" : username,
      "password" : password,
      "status" : status
    };
  }

  factory user.fromJson(Map<String,dynamic> json){
    return user(
      username: json['username'],
      password: json['password'],
      status: json['status']
    );
  }
}