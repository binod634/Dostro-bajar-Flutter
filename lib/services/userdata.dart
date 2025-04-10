class Userdata {
  int? id;
  String imageUrl;
  String firstName;
  String lastName;
  String email;
  int? phoneNumber;

  Userdata({
    this.id,
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
      id: json['id'] as int?,
      imageUrl: json['imageUrl'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
