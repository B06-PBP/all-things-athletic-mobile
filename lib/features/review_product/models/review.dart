class Review {
  String model;
  int pk;
  Fields fields;
  String? username;
  String? namaAlat;
  Review({
    required this.model,
    required this.pk,
    required this.fields,
    this.username,
    this.namaAlat,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        model: json["model"],
        pk: json["pk"],
        username: json["username"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int alatOlahraga;
  int user;
  String reviewText;
  double rating;
  String createdAt;
  String updatedAt;

  Fields({
    required this.alatOlahraga,
    required this.user,
    required this.reviewText,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        alatOlahraga: json["alat_olahraga"],
        user: json["user"],
        reviewText: json["review_text"],
        rating: json["rating"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "alat_olahraga": alatOlahraga,
        "user": user,
        "review_text": reviewText,
        "rating": rating,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}