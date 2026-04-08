import 'package:flutter/material.dart';

// --- GLOBAL VERİLER ---
List<Map<String, dynamic>> tumUrunler = [
  {"ad": "Premium Saat", "fiyat": "1250 TL", "img": "https://picsum.photos/400?random=101", "satici": "Mustafa", "kategori": "Aksesuar"},
  {"ad": "Spor Ayakkabı", "fiyat": "2400 TL", "img": "https://picsum.photos/400?random=102", "satici": "Admin", "kategori": "Giyim"},
  {"ad": "Laptop", "fiyat": "25000 TL", "img": "https://picsum.photos/400?random=105", "satici": "Admin", "kategori": "Elektronik"},
];

List<Map<String, dynamic>> sepetListesi = [];
List<String> favoriUrunler = [];
ValueNotifier<ThemeMode> temaModu = ValueNotifier(ThemeMode.light);
Map<String, String>? aktifKullanici = {"ad": "Mustafa", "email": "m@atauni.edu.tr"};

void main() { runApp(const BenimUygulamam()); }

class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaModu,
      builder: (context, guncelMod, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: guncelMod,
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue, brightness: Brightness.light),
          darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue, brightness: Brightness.dark),
          home: const AnaSayfa(),
        );
      },
    );
  }
}

// --- ANA SAYFA ---
class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  void sayfaYenile() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zora"),
        actions: [
          IconButton(
            icon: Icon(temaModu.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              temaModu.value = temaModu.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
              sayfaYenile();
            },
          ),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const FavorilerSayfasi())).then((v) => sayfaYenile())),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SepetSayfasi())).then((v) => sayfaYenile())),
              if (sepetListesi.isNotEmpty)
                Positioned(right: 5, top: 5, child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text(sepetListesi.length.toString(), style: const TextStyle(fontSize: 10, color: Colors.white)))),
            ],
          ),
          IconButton(icon: const Icon(Icons.person), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfilSayfasi()))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10), child: Align(alignment: Alignment.centerLeft, child: Text("Kategoriler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  kategoriIkonu("Elektronik", Icons.devices),
                  kategoriIkonu("Giyim", Icons.checkroom),
                  kategoriIkonu("Aksesuar", Icons.watch),
                  kategoriIkonu("Ev & Yaşam", Icons.home),
                ],
              ),
            ),
            const Divider(),
            const Padding(padding: EdgeInsets.all(10), child: Align(alignment: Alignment.centerLeft, child: Text("Tüm İlanlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
            
            // ÜRÜN GRİDİ
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65, // Butonlar için biraz uzattık
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: tumUrunler.length,
              itemBuilder: (context, index) {
                var urun = tumUrunler[index];
                bool favorideMi = favoriUrunler.contains(urun["ad"]);
                bool benimUrunum = urun["satici"] == aktifKullanici?["ad"];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Üst Kısım: Resim ve Silme Butonu
                      Stack(
                        children: [
                          Image.network(urun["img"], fit: BoxFit.cover, width: double.infinity, height: 120),
                          if (benimUrunum)
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => setState(() => tumUrunler.removeAt(index)),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(urun["ad"], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(urun["fiyat"], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            
                            // HIZLI BUTONLAR (İstediğin Güncelleme Burada)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Hızlı Favori
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(favorideMi ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 22),
                                  onPressed: () => setState(() => favorideMi ? favoriUrunler.remove(urun["ad"]) : favoriUrunler.add(urun["ad"])),
                                ),
                                // Hızlı Sepet
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    minimumSize: const Size(60, 30),
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    int fiyatNum = int.parse(urun["fiyat"].replaceAll(" TL", ""));
                                    setState(() => sepetListesi.add({"ad": urun["ad"], "fiyat": fiyatNum, "img": urun["img"]}));
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sepete Eklendi!"), duration: Duration(milliseconds: 500)));
                                  },
                                  child: const Icon(Icons.add_shopping_cart, size: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const UrunEklemeSayfasi())).then((v) => sayfaYenile()),
        label: const Text("İlan Ver"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget kategoriIkonu(String ad, IconData ikon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.blue.withOpacity(0.1), child: Icon(ikon, color: Colors.blue)),
        const SizedBox(height: 5),
        Text(ad, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}

// --- SEPET SAYFASI ---
class SepetSayfasi extends StatefulWidget {
  const SepetSayfasi({super.key});
  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
  @override
  Widget build(BuildContext context) {
    num toplam = sepetListesi.fold(0, (sum, item) => sum + item["fiyat"]);
    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: sepetListesi.isEmpty ? const Center(child: Text("Sepetiniz boş.")) : Column(children: [
        Expanded(child: ListView.builder(itemCount: sepetListesi.length, itemBuilder: (c, i) => ListTile(
          leading: Image.network(sepetListesi[i]["img"], width: 50),
          title: Text(sepetListesi[i]["ad"]),
          subtitle: Text("${sepetListesi[i]["fiyat"]} TL"),
          trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => sepetListesi.removeAt(i))),
        ))),
        Padding(padding: const EdgeInsets.all(20), child: Text("Toplam: $toplam TL", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}

// --- FAVORİLER SAYFASI ---
class FavorilerSayfasi extends StatelessWidget {
  const FavorilerSayfasi({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorilerim")),
      body: favoriUrunler.isEmpty ? const Center(child: Text("Favori yok.")) : ListView.builder(
        itemCount: favoriUrunler.length,
        itemBuilder: (c, i) => ListTile(leading: const Icon(Icons.favorite, color: Colors.red), title: Text(favoriUrunler[i])),
      ),
    );
  }
}

// --- ÜRÜN EKLEME ---
class UrunEklemeSayfasi extends StatefulWidget {
  const UrunEklemeSayfasi({super.key});
  @override
  State<UrunEklemeSayfasi> createState() => _UrunEklemeSayfasiState();
}

class _UrunEklemeSayfasiState extends State<UrunEklemeSayfasi> {
  final _ad = TextEditingController(); final _fiyat = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İlan Oluştur")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: _ad, decoration: const InputDecoration(labelText: "Ne satıyorsun?")),
          TextField(controller: _fiyat, decoration: const InputDecoration(labelText: "Fiyat"), keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {
            tumUrunler.add({"ad": _ad.text, "fiyat": "${_fiyat.text} TL", "img": "https://picsum.photos/400?random=${_ad.text.length}", "satici": aktifKullanici!["ad"], "kategori": "Genel"});
            Navigator.pop(context);
          }, child: const Text("Hemen Yayınla")),
        ]),
      ),
    );
  }
}

// --- PROFİL VE GİRİŞ ---
class ProfilSayfasi extends StatelessWidget {
  const ProfilSayfasi({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Center(child: Text("${aktifKullanici!["ad"]} Hoş Geldin!")),
    );
  }
}