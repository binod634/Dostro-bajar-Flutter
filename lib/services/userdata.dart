class Userdata {
  String? id;
  String imageUrl;
  String firstName;
  String lastName;
  String email;

  Userdata({
    this.id,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
      id: json['id'] as String?,
      imageUrl: json['imageUrl'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
