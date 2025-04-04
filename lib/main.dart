import 'package:flutter/material.dart';

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
  final double rate = 1.35;

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
      appBar: AppBar(title: Text("Currency Converter Page")),
      body: Padding(padding: const EdgeInsets.all(16.0), 
        child: Column(
          children: [
            Text("Welcome user to Teniel's Currency Converter App!"), 
            TextField(
              controller: _cadCon,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(label: Text('CAD: ')),
              onChanged: _convertToUSD,
            ), 
            SizedBox(height: 16,), 
            TextField(
              controller: _usdCon,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(label: Text('USD: ')),
              onChanged: _convertToCAD,
            ), 
            SizedBox(height: 16,), 
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
      appBar: AppBar(title: Text("Conversion Summary Page")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("CAD: $cad", style: TextStyle(fontSize: 20)),
            Text("USD: $usd", style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
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
