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

class Cart {
  final String Name;
  final String Username;
  final String Price;
  final String Stock;

  Cart(
      {required this.Name,
      required this.Username,
      required this.Price,
      required this.Stock});

  Map<String, dynamic> toJson() {
    return {"Name": Name, "Username": Username, "Price": Price, "Stock": Stock};
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        Name: json['Name'],
        Username: json['Username'],
        Price: json['Price'],
        Stock: json['Stock']);
  }
}

class Reviews {
  final String Review;
  final String Username;
  Reviews({
    required this.Review,
    required this.Username,
  });

  Map<String, dynamic> toJson() {
    return {"Review": Review, "Username": Username};
  }

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(Review: json['Review'], Username: json['Username']);
  }
}

class Statuses {
  final String Price;
  final String ProductName;
  final String Status;
  final String Stock;
  final String Username;

  Statuses({
    required this.Price,
    required this.ProductName,
    required this.Status,
    required this.Stock,
    required this.Username,
  });

  Map<String, dynamic> toJson() {
    return {"Price": Price, "ProductName": ProductName,"Status": Status,"Stock": Stock, "Username": Username};
  }

  factory Statuses.fromJson(Map<String, dynamic> json) {
    return Statuses(Price: json['Price'], ProductName: json['ProductName'], Status: json['Status'], Stock: json['Stock'], Username: json['Username']);
  }
}
