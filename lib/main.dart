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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(122, 212, 230, 0)),
        useMaterial3: true,
      ),
      home: const listOfNews(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {required this.author,
      required this.publishTime,
      required this.title,
      required this.description,
      required this.image,
      super.key});

  final String author, publishTime, title, description, image;

  @override
  State<MyHomePage> createState() =>
      _MyHomePage(author, publishTime, title, description, image);
}

class _MyHomePage extends State<MyHomePage> {
  String author = "",
      publishTime = "",
      title = "",
      description = "",
      image = "";

  _MyHomePage(String author, String publishTime, String title,
      String description, String image) {
    this.author = author;
    this.publishTime = publishTime;
    this.title = title;
    this.description = description;
    this.image = image;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Card(
        color: theme.colorScheme.onPrimary,
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 180.0,
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "$author",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      "$publishTime",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(10),
              child: Text(
                "$title",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            FadeInImage(
                placeholder: AssetImage("asset/appel_news.png"),
                image: NetworkImage(image)),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(10),
              child: Text(
                "$description",
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class listOfNews extends StatefulWidget {
  const listOfNews({super.key});

  @override
  State<listOfNews> createState() => _listOfNewsState();
}

// ignore: camel_case_types
class _listOfNewsState extends State<listOfNews> {
  List<dynamic> data = [];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    fetchData();

    List<Widget> News = [];

    for (int i = 0; i < data.length; i++) {
      setState(() {
        News.add(MyHomePage(
          author: data[i]["author"].toString(),
          publishTime: data[i]["publishedAt"].toString(),
          title: data[i]["title"].toString(),
          description: data[i]["description"].toString(),
          image: data[i]["urlToImage"].toString(),
        ));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Appel News Application",
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: ListView(
        children: News,
      ),
    );
  }

  Future<void> fetchData() async {
    const url =
        "https://newsapi.org/v2/everything?q=apple&from=2024-02-12&to=2024-02-12&sortBy=popularity&apiKey=158744811de647f292dc20e0308c9c19";
    final uri = Uri.parse(url);
    var Response = await http.get(uri);
    var json = jsonDecode(Response.body);
    setState(() {
      data = json["articles"];
    });
  }
}
