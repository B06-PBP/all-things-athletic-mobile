import 'dart:convert';
import 'package:all_things_athletic_mobile/features/artikel/models/article.dart';
import 'package:all_things_athletic_mobile/features/artikel/screens/edit_comment_rating_page.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../../auth/user.dart';
import '../models/commen_rating.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;
  const ArticleDetailPage({
    super.key,
    required this.article,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _comment = "";
  int _selectedRating = 0;
  bool _isLoading = false;

  Future<List<CommentRating>> fetchComments(CookieRequest request) async {
    final response = await request.get(
        "http://localhost:8000/show_article_comrat_json/${widget.article.pk}/");
    List<CommentRating> comments = [];
    if (response != null && response is List) {
      for (var d in response) {
        if (d != null) {
          comments.add(CommentRating.fromJson(d));
        }
      }
    }
    return comments;
  }

  Future<void> submitComment(CookieRequest request) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rating harus dipilih!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await request.postJson(
      "http://localhost:8000/articles/create-flutter/",
      jsonEncode({
        "article_id": widget.article.pk,
        "name": _name,
        "rating": _selectedRating,
        "comment": _comment,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Komentar berhasil ditambahkan!"),
      ));

      setState(() {
        _comment = "";
        _selectedRating = 0;
      });
      _formKey.currentState!.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            response['message'] ?? "Terjadi kesalahan, silakan coba lagi."),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      _name = request.jsonData['username'] ?? "";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5d7),
      appBar: AppBar(
        title: Text(widget.article.fields.title),
        backgroundColor: const Color(0xffadba5e),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.article.fields.imgUrl),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.article.fields.title,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.article.fields.fullDescription),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Komentar dan Rating",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder<List<CommentRating>>(
                future: fetchComments(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Belum ada komentar.'),
                    );
                  } else {
                    final comments = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        CommentRating c = comments[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    c.fields.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  if (c.fields.user == User.userId)
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditCommentRatingFormPage(
                                              commentRatingId: c.pk,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  c.fields.rating.toInt(),
                                  (i) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(c.fields.comment),
                              const SizedBox(height: 4),
                              Text(
                                c.fields.createdAt.toString(),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tambah Komentar",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: "Nama",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (val) {
                          _name = val;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Nama tidak boleh kosong!";
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
                          labelText: "Komentar",
                          hintText: "Tulis komentar Anda",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        maxLines: 4,
                        onChanged: (val) {
                          _comment = val;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Komentar tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: List.generate(5, (i) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRating = i + 1;
                              });
                            },
                            child: Icon(
                              Icons.star,
                              color: i < _selectedRating
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () async {
                                final request = context.read<CookieRequest>();
                                await submitComment(request);
                                setState(() {});
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: _isLoading ? Colors.grey : Colors.amber,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text(
                                  "Kirim",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
