import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Dokter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Jadwal Dokter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3001/profiles'));

      if (response.statusCode == 200) {
        setState(() {
          doctors = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF8AC6A3),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Dokter yang Kamu Mau',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return _DoctorCard(
                    name: doctors[index]['name'] ?? 'Unknown',
                    unit: doctors[index]['unit'] ?? 'Unknown',
                    specialis: doctors[index]['specialis'] ?? 'Unknown',
                    jadwal: doctors[index]['jadwal'] ?? 'Unknown',
                    hari: doctors[index]['hari'] ?? 'Unknown',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String unit;
  final String specialis;
  final String jadwal;
  final String hari;

  const _DoctorCard({
    Key? key,
    required this.name,
    required this.unit,
    required this.specialis,
    required this.jadwal,
    required this.hari,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC6E6D3),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            'Unit: $unit',
            style: TextStyle(fontSize: 14.0),
          ),
          Text(
            'Spesialis: $specialis',
            style: TextStyle(fontSize: 14.0),
          ),
          Text(
            'Jadwal: $jadwal',
            style: TextStyle(fontSize: 14.0),
          ),
          Text(
            'Hari: $hari',
            style: TextStyle(fontSize: 14.0),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8AC6A3),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('Booking'),
            ),
          ),
        ],
      ),
    );
  }
}
