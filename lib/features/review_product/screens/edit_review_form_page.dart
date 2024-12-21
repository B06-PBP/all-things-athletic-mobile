import 'dart:convert';

import 'package:all_things_athletic_mobile/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:all_things_athletic_mobile/features/katalog/models/alat_olahraga.dart';

class EditReviewFormPage extends StatefulWidget {
  final int reviewId;
  const EditReviewFormPage({super.key, required this.reviewId});

  @override
  State<EditReviewFormPage> createState() => _EditReviewFormPageState();
}

class _EditReviewFormPageState extends State<EditReviewFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedAlatOlahragaPk;
  String _review = "";
  double _rating = 0.0;
  List<AlatOlahraga> _alatOlahragaList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      fetchReviewData(request);
    });
  }

  Future<void> fetchReviewData(CookieRequest request) async {
    final url =
        "http://localhost:8000/reviews/${widget.reviewId}/edit-flutter/";
    final response = await request.get(url);

    if (response != null && response['status'] == 'success') {
      final reviewData = response['review'];

      final alatResponse =
          await request.get("http://localhost:8000/show_alat_olahraga_json/");

      if (alatResponse != null) {
        setState(() {
          _selectedAlatOlahragaPk = reviewData['alat_olahraga_pk'];
          _review = reviewData['review_text'];
          _rating = (reviewData['rating'] as num).toDouble();

          _alatOlahragaList = (alatResponse as List)
              .map((alatJson) => AlatOlahraga.fromJson(alatJson))
              .toList();

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal memuat daftar alat olahraga."),
        ));
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Gagal memuat data review."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFe7e5d7),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Edit Review Alat Olahraga',
          ),
        ),
        backgroundColor: const Color(0xffadba5e),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Alat Olahraga",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        value: _selectedAlatOlahragaPk,
                        items: _alatOlahragaList.map((AlatOlahraga alat) {
                          return DropdownMenuItem<int>(
                            value: alat.pk,
                            child: Text(alat.fields.alatOlahraga),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedAlatOlahragaPk = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Alat olahraga harus dipilih!";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _review,
                        decoration: InputDecoration(
                          hintText: "Masukkan review Anda",
                          labelText: "Review",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _review = value ?? "";
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Review tidak boleh kosong!";
                          }
                          return null;
                        },
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: _rating.toString(),
                        decoration: InputDecoration(
                          hintText: "Masukkan rating (0 - 5)",
                          labelText: "Rating",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedAlatOlahragaPk == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Alat olahraga harus dipilih!"),
                                    ),
                                  );
                                  return;
                                }

                                final url =
                                    "http://localhost:8000/reviews/${widget.reviewId}/edit-flutter/";
                                final response = await request.postJson(
                                  url,
                                  jsonEncode({
                                    "alat_olahraga": _selectedAlatOlahragaPk,
                                    "review_text": _review,
                                    "rating": _rating,
                                  }),
                                );

                                if (context.mounted) {
                                  if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Review berhasil diperbarui!"),
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response['message'] ??
                                              "Terdapat kesalahan, silakan coba lagi.",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 9,
                              ),
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Center(
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}