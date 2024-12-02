import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CryptoPricesPage extends StatefulWidget {
  const CryptoPricesPage({Key? key}) : super(key: key);

  @override
  State<CryptoPricesPage> createState() => _CryptoPricesPageState();
}

class _CryptoPricesPageState extends State<CryptoPricesPage> {
  Map<String, dynamic> cryptoPrices = {};
  final List<String> currencies = ['idr', 'usd', 'eur', 'jpy', 'gbp'];
  String selectedCurrency = 'idr';

  @override
  void initState() {
    super.initState();
    fetchCryptoPrices();
  }

  Future<void> fetchCryptoPrices() async {
    final String apiUrl =
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,dogecoin,cardano,shiba-inu,solana,polkadot,bonk&vs_currencies=$selectedCurrency&include_platform=true';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          cryptoPrices = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error fetching crypto prices: $error');
    }
  }

  void onCurrencyChanged(String? currency) {
    if (currency != null && currency != selectedCurrency) {
      setState(() {
        selectedCurrency = currency;
        cryptoPrices = {}; // Clear old data
      });
      fetchCryptoPrices();
    }
  }

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'id_ID');
    return formatter.format(price);
  }

  // Fungsi untuk menampilkan gambar mata uang kripto berdasarkan nama
  Widget getCryptoIcon(String crypto) {
    String iconUrl = '';

    // Ambil ikon berdasarkan crypto dari API CoinGecko
    switch (crypto) {
      case 'bitcoin':
        iconUrl = 'https://cryptologos.cc/logos/bitcoin-btc-logo.png?v=035';
        break;
      case 'ethereum':
        iconUrl = 'https://cryptologos.cc/logos/ethereum-eth-logo.png?v=035';
        break;
      case 'dogecoin':
        iconUrl = 'https://cryptologos.cc/logos/dogecoin-doge-logo.png?v=035';
        break;
      case 'cardano':
        iconUrl = 'https://cryptologos.cc/logos/cardano-ada-logo.png?v=035';
        break;
      case 'shiba-inu':
        iconUrl = 'https://cryptologos.cc/logos/shiba-inu-shib-logo.png?v=035';
        break;
      case 'solana':
        iconUrl = 'https://cryptologos.cc/logos/solana-sol-logo.png?v=035';
        break;
      case 'polkadot':
        iconUrl = 'https://cryptologos.cc/logos/polkadot-new-dot-logo.png?v=035';
        break;
      case 'bonk':
        iconUrl = 'https://cryptologos.cc/logos/bonk1-bonk-logo.png?v=035';
        break;
      default:
        iconUrl = 'https://cryptingup.com/assets/images/icons/default.svg'; // URL Ikon default
    }

    return Image.network(iconUrl, height: 30, width: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harga Crypto'),
        backgroundColor: Colors.blueGrey,
        actions: [
          DropdownButton<String>(
            value: selectedCurrency,
            dropdownColor: Colors.blueGrey[700],
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: const SizedBox(),
            onChanged: onCurrencyChanged,
            items: currencies.map((currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(
                  currency.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: cryptoPrices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cryptoPrices.keys.length,
              itemBuilder: (context, index) {
                final crypto = cryptoPrices.keys.elementAt(index);
                final price = cryptoPrices[crypto][selectedCurrency];

                final double formattedPrice = price is double ? price : price.toDouble();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      child: getCryptoIcon(crypto), // Menampilkan gambar crypto
                    ),
                    title: Text(
                      crypto.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${selectedCurrency.toUpperCase()} ${formatPrice(formattedPrice)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
  