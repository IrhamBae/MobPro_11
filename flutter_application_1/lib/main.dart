import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1302220063_Irham Baehaqi_TPMOD11',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final data = await DBHelper.getUsers();
    setState(() {
      _users = data;
    });
  }

  Future<void> addUser(String name) async {
    await DBHelper.addUser(name);
    fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    await DBHelper.deleteUser(id);
    fetchUsers();
  }

  Future<void> resetUsers() async {
    await DBHelper.resetTable();
    fetchUsers();
  }

  void showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Anda yakin akan menghapus data ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                deleteUser(id);
                Navigator.of(context).pop();
              },
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '1302220063_Irham Baehaqi_TPMOD11',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[300],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: 'Masukan Nama',
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        addUser(value);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.loop,
                    color: Colors.blue[300],
                  ),
                  onPressed: () {
                    resetUsers();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue[300]!, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.blue, width: 1),
                      ),
                      child: Text(
                        _users[index]['id'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    title: Text(_users[index]['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.dangerous, color: Colors.blue[300]),
                      onPressed: () {
                        showDeleteDialog(_users[index]['id']);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
