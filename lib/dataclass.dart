class Users {
  final String admin;
  final String username;
  final String password;
  final String saldo;

  Users(
      {required this.admin,
      required this.password,
      required this.saldo,
      required this.username});

  Map<String, dynamic> toJson() {
    return {
      "Admin": admin,
      "Password": password,
      "Saldo": saldo,
      "Username": username
    };
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        admin: json["Admin"],
        password: json["Password"],
        saldo: json["Saldo"],
        username: json["Username"]);
  }
}

class Product {
  final String Descriptions;
  final String Name;
  final String PictureURL;
  final String Price;
  final String Stock;

  Product(
      {required this.Descriptions,
      required this.Name,
      required this.PictureURL,
      required this.Price,
      required this.Stock});

  Map<String, dynamic> toJson() {
    return {
      "Descriptions": Descriptions,
      "Name": Name,
      "PictureURL": PictureURL,
      "Price": Price,
      "Stock": Stock
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        Descriptions: json['Descriptions'],
        Name: json['Name'],
        PictureURL: json['PictureURL'],
        Price: json['Price'],
        Stock: json['Stock']);
  }
}
