import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditCommentRatingFormPage extends StatefulWidget {
  final int commentRatingId;
  const EditCommentRatingFormPage({super.key, required this.commentRatingId});

  @override
  State<EditCommentRatingFormPage> createState() =>
      _EditCommentRatingFormPageState();
}

class _EditCommentRatingFormPageState extends State<EditCommentRatingFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedArticlePk;
  String _name = "";
  double _rating = 0.0;
  String _comment = "";

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      fetchCommentRatingData(request);
    });
  }

  Future<void> fetchCommentRatingData(CookieRequest request) async {
    final url =
        "http://localhost:8000/articles/${widget.commentRatingId}/edit-flutter/";
    final response = await request.get(url);

    if (response != null && response['status'] == 'success') {
      final comratData = response['commentrating'];

      setState(() {
        _selectedArticlePk = comratData['article_id'];
        _name = comratData['name'];
        _comment = comratData['comment'];
        _rating = (comratData['rating'] as num).toDouble();

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memuat data commentrating."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Edit CommentRating Article'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: _name,
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
                      initialValue: _comment,
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
                      initialValue: _rating.toString(),
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Article harus dipilih!"),
                              ));
                              return;
                            }

                            final url =
                                "http://localhost:8000/articles/${widget.commentRatingId}/edit-flutter/";
                            final response = await request.postJson(
                              url,
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
                                  content: Text(
                                      "CommentRating berhasil diperbarui!"),
                                ));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(response['message'] ??
                                      "Terdapat kesalahan, silakan coba lagi."),
                                ));
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
