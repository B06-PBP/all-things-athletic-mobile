class Article {
    String model;
    int pk;
    Fields fields;

    Article({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );
}

class Fields {
    String title;
    String imgUrl;
    String fullDescription;

    Fields({
        required this.title,
        required this.imgUrl,
        required this.fullDescription,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        imgUrl: json["image_url"],
        fullDescription: json["full_description"],
    );
}
