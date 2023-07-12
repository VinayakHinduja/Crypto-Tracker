import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'const.dart';

class Currencies {
  late String name;
  late String logo;
  Currencies({required this.name, required this.logo});
}

List<Currencies> currenciesList = [
  Currencies(name: 'CNY', logo: '元'),
  Currencies(name: 'EUR', logo: '€'),
  Currencies(name: 'GBP ', logo: '£'),
  Currencies(name: 'HKD', logo: '元'),
  Currencies(name: 'IDR', logo: 'Rp'),
  Currencies(name: 'ILS', logo: '₪'),
  Currencies(name: 'INR', logo: '₹'),
  Currencies(name: 'JPY', logo: '¥'),
  Currencies(name: 'NOK', logo: 'kr'),
  Currencies(name: 'PLN', logo: 'zł'),
  Currencies(name: 'RON', logo: 'le'),
  Currencies(name: 'RUB', logo: '₽'),
  Currencies(name: 'SEK', logo: 'kr'),
  Currencies(name: 'ZAR', logo: 'R'),
  Currencies(name: 'BRL', logo: 'R\u0024'),
  Currencies(name: 'SGD', logo: '\u0024'),
  Currencies(name: 'MXN', logo: '\u0024'),
  Currencies(name: 'NZD', logo: '\u0024'),
  Currencies(name: 'CAD', logo: '\u0024'),
  Currencies(name: 'AUD', logo: '\u0024'),
  Currencies(name: 'USD', logo: '\u0024'),
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];

class CoinData {
  getCoinData({String? value}) async {
    Map<String, String> cryptoPrices = {};
    var f = NumberFormat("##,##,##,##,###");

    for (String crypto in cryptoList) {
      final parameters = {'apikey': apiKey};

      Uri url = Uri.http(
          'rest.coinapi.io', '/v1/exchangerate/$crypto/$value', parameters);

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);

        double lastPrice = decodedData['rate'];

        lastPrice.toStringAsFixed(0);

        cryptoPrices[crypto] = f.format(lastPrice);
      } else {
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
