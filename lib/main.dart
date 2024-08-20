import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Conversor de Moeda'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Currency> _currencies = [
    Currency.usd,
    Currency.eur,
    Currency.inr,
    Currency.brl,
    // Adicione mais moedas conforme necessário
  ];

  Currency _fromCurrency = Currency.usd;
  Currency _toCurrency = Currency.inr;
  double _amount = 1.0;
  String? _result;

  @override
  void initState() {
    super.initState();
    _convert();
  }

  void _convert() async {
    var conversionResult = await CurrencyConverter.convert(
      from: _fromCurrency,
      to: _toCurrency,
      amount: _amount,
      withoutRounding: true,
    );
    setState(() {
      _result = conversionResult.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<Currency>(
              value: _fromCurrency,
              items: _currencies.map((Currency currency) {
                return DropdownMenuItem<Currency>(
                  value: currency,
                  child: Text(currency.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (Currency? newValue) {
                setState(() {
                  _fromCurrency = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButton<Currency>(
              value: _toCurrency,
              items: _currencies.map((Currency currency) {
                return DropdownMenuItem<Currency>(
                  value: currency,
                  child: Text(currency.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (Currency? newValue) {
                setState(() {
                  _toCurrency = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: "Quantidade",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 1.0;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Converter'),
            ),
            const SizedBox(height: 20),
            if (_result != null)
              Text(
                "$_amount ${_fromCurrency.name.toUpperCase()} = $_result ${_toCurrency.name.toUpperCase()}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
