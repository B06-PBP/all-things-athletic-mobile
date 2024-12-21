class CommentRating {
  String model;
  int pk;
  Fields fields;

  CommentRating({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory CommentRating.fromJson(Map<String, dynamic> json) => CommentRating(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );
}

class Fields {
  int article;
  int user;
  String name;
  double rating;
  String comment;
  String createdAt;
  String updatedAt;

  Fields({
    required this.article,
    required this.user,
    required this.name,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        article: json["article"],
        user: json["user"],
        name: json["name"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
