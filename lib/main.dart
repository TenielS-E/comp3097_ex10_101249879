//imported needed libraries
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _cadCon = TextEditingController();
  final TextEditingController _usdCon = TextEditingController();
  double rate = 1.35; // For static exchange rate implementation - add final
  // if using api - double rate = 1.35

  // API Implementation
  @override
  void initState() {
    super.initState();
    fetchRate();
  }

  Future<void> fetchRate() async {
    final uri = Uri.parse('https://open.er-api.com/v6/latest/USD');
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final r = json.decode(res.body);
      setState(() {
        rate = r['rates']['CAD'];
      });
    }
  }

  // conversion methods
  void _convertToCAD(String val) {
    if (val.isNotEmpty){
      double usd = double.tryParse(val) ?? 0;
      _cadCon.text = (usd * rate).toStringAsFixed(2);
    }
  }

  void _convertToUSD(String val) {
    if (val.isNotEmpty){
      double cad = double.tryParse(val) ?? 0;
      _usdCon.text = (cad / rate).toStringAsFixed(2);
    }
  }

  // navigtion method
  void _navigateToSummaryPage () {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => SummaryPage(cad: _cadCon.text, usd: _usdCon.text, rate: rate)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(166, 200, 178, 239),
      appBar: AppBar(title: Text("Currency Converter Page"), backgroundColor: const Color.fromARGB(180, 200, 178, 239)),
      body: Padding(padding: const EdgeInsets.all(16.0), 
        child: Column(
          children: [
            Text("Welcome user to Teniel's Currency Converter App!", style: TextStyle(color: Colors.deepPurple, fontSize: 25.0)), 
            TextFormField(
              controller: _cadCon,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(label: Text('CAD: ')),
              onChanged: _convertToUSD,
            ), 
            SizedBox(height: 20), 
            TextFormField(
              controller: _usdCon,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(label: Text('USD: ')),
              onChanged: _convertToCAD,
            ), 
            SizedBox(height: 20), 
            ElevatedButton(onPressed: _navigateToSummaryPage, child: Text("View Summary")),
          ],
        ),
      ),
    );
  }    
}

class SummaryPage extends StatelessWidget {
  final String cad;
  final String usd;
  final double rate;

  const SummaryPage({super.key, required this.cad, required this.usd, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(166, 200, 178, 239),
      appBar: AppBar(title: Text("Conversion Summary Page"), backgroundColor: const Color.fromARGB(180, 200, 178, 239)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text("Summary", style: TextStyle(color: Colors.deepPurple, fontSize: 45.0)),
            ),
            Text("CAD: $cad", style: TextStyle(color: Colors.deepPurple, fontSize: 30.0)),
            SizedBox(height: 5),
            Text("USD: $usd", style: TextStyle(color: Colors.deepPurple, fontSize: 30.0)),
            SizedBox(height: 5),
            Text("Exchange Rate: 1 USD = \$$rate CAD", style: TextStyle(color: Colors.deepPurple, fontSize: 20.0)),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back')
            )
          ],
        ),
      ),
    );
  }
}
