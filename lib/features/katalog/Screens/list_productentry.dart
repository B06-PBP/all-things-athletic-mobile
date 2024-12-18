class ProductEntryPage extends StatefulWidget {
  const ProductEntryPage({super.key});

  @override
  State<ProductEntryPage> createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  Future<List<AlatOlahraga>> fetchProduct(CookieRequest request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://127.0.0.1:8000/json/');

    // Decode response menjadi bentuk JSON
    var data = response;

    // Konversi data JSON menjadi list AlatOlahraga
    List<AlatOlahraga> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(AlatOlahraga.fromJson(d as Map<String, dynamic>));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk Olahraga'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot<List<AlatOlahraga>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Terjadi kesalahan, silakan coba lagi."),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data produk olahraga.',
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 6, 9, 10)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menampilkan Cabang Olahraga
                    Text(
                      snapshot.data![index].fields.cabangOlahraga,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Menampilkan Alat Olahraga
                    Text(
                      snapshot.data![index].fields.alatOlahraga,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    // Menampilkan Deskripsi
                    Text(
                      snapshot.data![index].fields.deskripsi,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 10),
                    // Menampilkan Harga
                    Text(
                      "Harga: ${snapshot.data![index].fields.harga}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    // Menampilkan Toko
                    Text(
                      "Toko: ${snapshot.data![index].fields.toko}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    // Menampilkan Rating
                    Text(
                      "Rating: ${snapshot.data![index].fields.rating}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10),
                    // Menampilkan Gambar
                    Image.network(snapshot.data![index].fields.gambar),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

