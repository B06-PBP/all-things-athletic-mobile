import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';

class CommentRatingFormPage extends StatefulWidget {
  const CommentRatingFormPage({super.key});

  @override
  State<CommentRatingFormPage> createState() => _CommentRatingFormPageState();
}

class _CommentRatingFormPageState extends State<CommentRatingFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedArticlePk;
  String _name = "";
  double _rating = 0.0;
  String _comment = "";
  List<Article> _articleList = [];

  Future<void> fetchArticle(CookieRequest request) async {
    final response =
        await request.get("http://localhost:8000/show_article_json/");

    if (response != null) {
      setState(() {
        _articleList = (response as List)
            .map((artJson) => Article.fromJson(artJson))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Gagal memuat daftar artikel."),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      fetchArticle(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5d7),
      appBar: AppBar(
        title: const Text('Form Tambah CommentRating Article'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Article",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                value: _selectedArticlePk,
                items: _articleList.map((Article art) {
                  return DropdownMenuItem<int>(
                    value: art.pk,
                    child: Text(art.fields.title),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedArticlePk = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Article harus dipilih!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Masukkan nama Anda",
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _name = value ?? "";
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Name tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Masukkan komentar Anda",
                  labelText: "Comment",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _comment = value ?? "";
                  });
                },
                maxLines: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Masukkan rating (0 - 5)",
                  labelText: "Rating",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (String? value) {
                  setState(() {
                    _rating = double.tryParse(value ?? "") ?? 0.0;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Rating tidak boleh kosong!";
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null) {
                    return "Rating harus berupa angka!";
                  }
                  if (parsed < 0 || parsed > 5) {
                    return "Rating harus antara 0 dan 5!";
                  }
                  return null;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedArticlePk == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Article harus dipilih!"),
                          ),
                        );
                        return;
                      }

                      final response = await request.postJson(
                        "http://localhost:8000/articles/create-flutter/",
                        jsonEncode({
                          "article_id": _selectedArticlePk,
                          "name": _name,
                          "rating": _rating,
                          "comment": _comment,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("CommentRating berhasil disimpan!"),
                          ));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response['message'] ??
                                  "Terdapat kesalahan, silakan coba lagi."),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
