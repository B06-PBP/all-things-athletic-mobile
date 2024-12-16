class Rating {
    String model;
    int pk;
    Fields fields;

    Rating({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        model: json["model"],
        pk: json["pk"],
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
    int rating;
    String comment;
    DateTime createdAt;
    DateTime updatedAt;

    Fields({
        required this.alatOlahraga,
        required this.user,
        required this.rating,
        required this.comment,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        alatOlahraga: json["alat_olahraga"],
        user: json["user"],
        rating: json["rating"],
        comment: json["rating"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "alat_olahraga": alatOlahraga,
        "user": user,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };

}
