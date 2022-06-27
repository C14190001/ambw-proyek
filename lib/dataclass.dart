class Users{
  final String admin;
  final String username;
  final String password;
  final String saldo;

  Users({
    required this.admin,
    required this.password,
    required this.saldo,
    required this.username
  });

  Map<String, dynamic> toJson(){
    return{
      "Admin":admin,
      "Password":password,
      "Saldo":saldo,
      "Username":username
    };
  }

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(admin: json["Admin"], password: json["Password"], 
    saldo: json["Saldo"], username: json["Username"]);
  }
}