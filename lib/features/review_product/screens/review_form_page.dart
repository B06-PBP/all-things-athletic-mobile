import 'dart:convert';

import 'package:all_things_athletic_mobile/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:all_things_athletic_mobile/features/katalog/models/alat_olahraga.dart';

class ReviewFormPage extends StatefulWidget {
  const ReviewFormPage({super.key});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedAlatOlahragaPk;
  String _review = "";
  double _rating = 0.0;
  List<AlatOlahraga> _alatOlahragaList = [];

  Future<void> fetchAlatOlahraga(CookieRequest request) async {
    final response =
        await request.get("http://localhost:8000/show_alat_olahraga_json/");

    if (response != null) {
      setState(() {
        _alatOlahragaList = (response as List)
            .map((alatJson) => AlatOlahraga.fromJson(alatJson))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Gagal memuat daftar alat olahraga."),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      fetchAlatOlahraga(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating Alat Olahraga'),
        backgroundColor: const Color(0xffadba5e),
      ),
      backgroundColor: const Color(0xFFe7e5d7),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DropdownButtonFormField<int>(
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.amber,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedAlatOlahragaPk == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Alat olahraga harus dipilih!"),
                              ));
                              return;
                            }

                            final response = await request.postJson(
                              "http://localhost:8000/reviews/create-flutter/",
                              jsonEncode({
                                "alat_olahraga": _selectedAlatOlahragaPk,
                                "review": _review,
                                "rating": _rating,
                              }),
                            );

                            if (context.mounted) {
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Review berhasil disimpan!"),
                                ));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
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
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}