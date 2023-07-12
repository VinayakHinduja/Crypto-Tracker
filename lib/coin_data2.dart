import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';
import 'const.dart';

const List<String> currencieslist = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

class Coindata {
  getCoindata({String? selectedCurrency}) async {
    Map<String, String> cryptoPrices = {};
    var f = NumberFormat("##,##,##,##,###");

    for (String crypto in cryptoList) {
      final parameters = {'apikey': apiKey};

      Uri url = Uri.http('rest.coinapi.io',
          '/v1/exchangerate/$crypto/$selectedCurrency', parameters);

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
