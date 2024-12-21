import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:all_things_athletic_mobile/features/review_product/screens/edit_review_form_page.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/review.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Future<List<Review>> fetchReview(CookieRequest request) async {
    final response =
        await request.get("http://localhost:8000/show_review_list_json/");

    List<Review> listReview = [];
    for (var d in response) {
      if (d != null) {
        var review = Review.fromJson(d);
        final usernameResponse =
            await request.get("http://localhost:8000/username/${review.pk}");
        final alatRespone = await request
            .get("http://localhost:8000/alat/${review.fields.alatOlahraga}");

        review.username = usernameResponse["username"];
        review.namaAlat = alatRespone["nama_alat"];
        listReview.add(review);
      }
    }
    return listReview;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5d7),
      appBar: AppBar(
        title: const Text('Review'),
        backgroundColor: const Color(0xffadba5e),
      ),
      body: FutureBuilder(
          future: fetchReview(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data.isEmpty) {
              return const Center(
                  child: Text('Tidak ada data yang ditemukan.'));
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
                  Review review = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.all(20.0),
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
                                      color: Colors.red),
                                  child: Text(
                                    review.username![0],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(review.username!)
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditReviewFormPage(
                                          reviewId: review.pk,
                                        ),
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
                                    const url =
                                        "http://localhost:8000/reviews/delete-flutter/";
                                    final response = await request.postJson(
                                        url,
                                        jsonEncode(<String, int>{
                                          'review_id': review.pk,
                                        }));

                                    if (context.mounted) {
                                      if (response['status'] == 'success') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text("Review berhasil dihapus!"),
                                        ));
                                        setState(() {});
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(response['message'] ??
                                              "Terdapat kesalahan, silakan coba lagi."),
                                        ));
                                      }
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
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              Icons.star,
                              color: i < review.fields.rating.toInt()
                                  ? Colors.amber
                                  : Colors.grey,
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          review.namaAlat!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          review.fields.reviewText,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat('d MMMM', 'id_ID')
                              .format(DateTime.parse(review.fields.createdAt)),
                          style: const TextStyle(color: Colors.grey),
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