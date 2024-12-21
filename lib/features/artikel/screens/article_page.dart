import 'package:all_things_athletic_mobile/features/artikel/screens/article_detail_page.dart';
import 'package:all_things_athletic_mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _HomePageState();
}

class _HomePageState extends State<ArticlePage> {
  Future<List<Article>> fetchKatalog(CookieRequest request) async {
    final response =
        await request.get("http://localhost:8000/show_article_json/");

    var data = response;

    List<Article> listArticle = [];
    for (var d in data) {
      if (d != null) {
        listArticle.add(Article.fromJson(d));
      }
    }
    return listArticle;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5d7),
      appBar: AppBar(
        title: const Text('Article'),
        backgroundColor: const Color(0xffadba5e),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchKatalog(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data.isEmpty) {
              return const Center(
                child: Text('Tidak ada data yang ditemukan.'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  var alat = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(alat.fields.imgUrl),
                        Text(
                          alat.fields.title,
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          alat.fields.fullDescription,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailPage(
                                  article: alat,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              "Lihat",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
