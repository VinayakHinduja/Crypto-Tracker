import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'coin_data.dart';
import 'coin_data2.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  Container androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItem = [];

    for (var currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency.name,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currency.name),
            const SizedBox(width: 200.0),
            Text(currency.logo),
          ],
        ),
      );
      dropDownItem.add(newItem);
    }

    return Container(
      padding: const EdgeInsets.all(50.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            style: const TextStyle(fontSize: 20.0),
            menuMaxHeight: 600.0,
            value: selectedCurrency,
            isExpanded: true,
            items: dropDownItem,
            onChanged: (value) {
              setState(() {
                selectedCurrency = value!;
                getData();
              });
            }),
      ),
    );
  }

  NotificationListener<Notification> iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currencieslist) {
      pickerItems.add(Text(currency));
    }

    return NotificationListener(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
            initialItem: currencieslist.indexOf(selectedCurrency)),
        itemExtent: 42.0,
        onSelectedItemChanged: (selectedIndex) =>
            selectedCurrency = currencieslist[selectedIndex],
        children: pickerItems,
      ),
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          getdata();
          return true;
        } else {
          return false;
        }
      },
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(value: selectedCurrency);
      isWaiting = false;
      setState(() => coinValues = data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getdata() async {
    isWaiting = true;
    try {
      var data =
          await Coindata().getCoindata(selectedCurrency: selectedCurrency);
      isWaiting = false;
      setState(() => coinValues = data);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('🤑 Crypto Ticker'),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CryptoCard(
              cryptoCurrency: 'BTC',
              value: isWaiting ? '?' : coinValues['BTC'],
              selectedCurrency: selectedCurrency,
            ),
            CryptoCard(
              cryptoCurrency: 'ETH',
              value: isWaiting ? '?' : coinValues['ETH'],
              selectedCurrency: selectedCurrency,
            ),
            CryptoCard(
              cryptoCurrency: 'LTC',
              value: isWaiting ? '?' : coinValues['LTC'],
              selectedCurrency: selectedCurrency,
            )
          ],
        ),
        Container(
          height: 150.0,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 30.0),
          color: const Color(0xFF212121),
          child: Platform.isIOS ? iOSPicker() : androidDropdown(),
        ),
      ]),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final String? value;
  final String? selectedCurrency;
  final String? cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: const Color(0xFF212121),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
