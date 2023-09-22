class Contact {
  final String id;
  final int age;
  final String name;
  final String gender;
  final String company;
  final String email;
  final String photo;
  bool isHovered;

  Contact({
    required this.id,
    required this.age,
    required this.name,
    required this.gender,
    required this.company,
    required this.email,
    required this.photo,
    this.isHovered = false,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      age: json['age'],
      name: json['name'],
      gender: json['gender'],
      company: json['company'],
      email: json['email'],
      photo: json['photo'],
    );
  }

  setHovered(bool value) {
    isHovered = value;
  }
}