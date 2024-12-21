import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/rating.dart';
import 'edit_rating_form_page.dart';
import 'rating_form_page.dart';

class RatingListPage extends StatefulWidget {
  const RatingListPage({super.key});

  @override
  State<RatingListPage> createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  Future<List<Rating>> fetchRatings(CookieRequest request) async {
    final response =
        await request.get("http://localhost:8000/show_rating_list_json");

    List<Rating> listRatings = [];
    for (var d in response) {
      if (d != null) {
        var rating = Rating.fromJson(d);
        final usernameResponse =
            await request.get("http://localhost:8000/username/${rating.pk}");
        final alatRespone = await request
            .get("http://localhost:8000/alat/${rating.fields.alatOlahraga}");
        rating.username = usernameResponse["username"];
        rating.namaAlat = alatRespone["nama_alat"];
        listRatings.add(rating);
      }
    }
    return listRatings;
  }

  Future<Map<String, dynamic>> deleteRating(
      CookieRequest request, int ratingId) async {
    final url = Uri.parse('http://localhost:8000/ratings/delete-flutter/');

    final response = await request.postJson(
      url.toString(),
      jsonEncode({
        'rating_id': ratingId,
      }),
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5d7),
      appBar: AppBar(
        title: const Text('Rating List'),
        backgroundColor: const Color(0xffadba5e),
      ),
      body: FutureBuilder(
        future: fetchRatings(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(child: Text('Tidak ada data yang ditemukan.'));
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Rating rating = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  rating.username.toString()[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                rating.username!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditRatingFormPage(
                                          ratingId: rating.pk),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: () async {
                                  final response =
                                      await deleteRating(request, rating.pk);

                                  if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Rating berhasil dihapus!"),
                                    ));
                                    setState(() {});
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(response['message'] ??
                                          "Terjadi kesalahan."),
                                    ));
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) {
                            return Icon(
                              Icons.star,
                              color: i < rating.fields.rating.toInt()
                                  ? Colors.amber
                                  : Colors.grey,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        rating.namaAlat!,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        rating.fields.comment,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('d MMMM yyyy', 'id_ID')
                            .format(DateTime.parse(rating.fields.createdAt)),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RatingFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
