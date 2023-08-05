import 'dart:convert';

import 'package:http/http.dart' as http;


void main(List<String> arguments) {
  getUser().then((value) => value.forEach((element) {print(element.name);}));

  getPosts().then((value) => value.forEach((element) {print(element.title);}));
}

class User {
  String name;
  String email;
  String phone;
  String website;
  String company;
  String address;

  User(this.name, this.email, this.phone, this.website, this.company, this.address);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        phone = json['phone'],
        website = json['website'],
        company = json['company']['name'],
        address = json['address']['street'] + ', ' + json['address']['city'] + ', ' + json['address']['zipcode'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'website': website,
        'company': company,
        'address': address,
      };

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      json['name'],
      json['email'],
      json['phone'],
      json['website'],
      json['company'],
      json['address'],
    );
  }
}

class Post {
  int userId;
  int id;
  String title;
  String body;

  Post(this.userId, this.id, this.title, this.body);

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        body = json['body'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };

  factory Post.fromMap(Map<String, dynamic> json) {
    return Post(
      json['userId'],
      json['id'],
      json['title'],
      json['body'],
    );
  }
}

getUser () async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  List<dynamic> users = data.map((user) => User.fromJson(user)).toList();
  return users;
}

getPosts() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  List<dynamic> posts = data.map((post) => Post.fromJson(post)).toList();
  return posts;
}