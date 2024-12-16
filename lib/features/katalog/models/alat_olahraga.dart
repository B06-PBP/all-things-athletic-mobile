class AlatOlahraga {
    String model;
    int pk;
    Fields fields;

    AlatOlahraga({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory AlatOlahraga.fromJson(Map<String, dynamic> json) => AlatOlahraga(
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
    String cabangOlahraga;
    String alatOlahraga;
    String deskripsi;
    String harga;
    String toko;
    int rating;
    String gambar;

    Fields({
        required this.cabangOlahraga,
        required this.alatOlahraga,
        required this.deskripsi,
        required this.harga,
        required this.toko,
        required this.rating,
        required this.gambar,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        cabangOlahraga: json["cabang_olahraga"],
        alatOlahraga: json["alat_olahraga"],
        deskripsi: json["deskripsi"],
        harga: json["harga"],
        toko: json["toko"],
        rating: json["rating"],
        gambar: json["gambar"],
    );

    Map<String, dynamic> toJson() => {
        "cabang_olahraga": cabangOlahraga,
        "alat_olahraga": alatOlahraga,
        "deskripsi": deskripsi,
        "harga": harga,
        "toko": toko,
        "rating": rating,
        "gambar": gambar,
    };

}
