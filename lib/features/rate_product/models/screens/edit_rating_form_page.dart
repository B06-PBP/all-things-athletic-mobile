import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../../../home.dart';
import '../../katalog/models/alat_olahraga.dart';

class EditRatingFormPage extends StatefulWidget {
  final int ratingId;
  const EditRatingFormPage({super.key, required this.ratingId});

  @override
  State<EditRatingFormPage> createState() => _EditRatingFormPageState();
}

class _EditRatingFormPageState extends State<EditRatingFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedAlatOlahragaPk;
  String _comment = "";
  double _rating = 0.0;
  List<AlatOlahraga> _alatOlahragaList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      fetchRatingData(request);
    });
  }

  Future<void> fetchRatingData(CookieRequest request) async {
    final url =
        "http://localhost:8000/ratings/${widget.ratingId}/edit-flutter/";
    final response = await request.get(url);

    if (response != null && response['status'] == 'success') {
      final ratingData = response['rating'];

      final alatResponse =
          await request.get("http://localhost:8000/show_alat_olahraga_json/");

      if (alatResponse != null) {
        setState(() {
          _selectedAlatOlahragaPk = ratingData['alat_olahraga'];
          _comment = ratingData['comment'];
          _rating = (ratingData['rating'] as num).toDouble();

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
        content: Text("Gagal memuat data rating."),
      ));
    }
  }

  Future<Map<String, dynamic>> updateRating(CookieRequest request, int ratingId,
      int alatOlahragaId, double rating, String comment) async {
    final url =
        Uri.parse('http://localhost:8000/ratings/$ratingId/edit-flutter/');

    final response = await request.postJson(
      url.toString(),
      jsonEncode({
        'alat_olahraga': alatOlahragaId,
        'rating': rating,
        'comment': comment,
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
        title: const Text('Form Edit Rating Alat Olahraga'),
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
                      initialValue: _comment,
                      decoration: InputDecoration(
                        hintText: "Masukkan komentar Anda",
                        labelText: "Komentar",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _comment = value ?? "";
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Komentar tidak boleh kosong!";
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
                    const SizedBox(height: 20),
                    Align(
                      child: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedAlatOlahragaPk == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Alat olahraga harus dipilih!"),
                                ),
                              );
                              return;
                            }

                            final response = await updateRating(
                              request,
                              widget.ratingId,
                              _selectedAlatOlahragaPk!,
                              _rating,
                              _comment,
                            );

                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Rating berhasil diperbarui!"),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response['message'] ??
                                      "Terjadi kesalahan."),
                                ),
                              );
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
                    )
                  ],
                ),
              )),
            ),
    );
  }
}
