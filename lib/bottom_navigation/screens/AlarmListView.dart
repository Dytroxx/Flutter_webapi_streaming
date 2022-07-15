import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Alarm alarmFromJson(String str) => Alarm.fromJson(json.decode(str));

String alarmToJson(Alarm data) => json.encode(data.toJson());

class Alarm {
    Alarm({
        required this.page,
        required this.pageCount,
        required this.pageItems,
        required this.totalCount,
    });

    Page page;
    int pageCount;
    List<dynamic> pageItems;
    int totalCount;

    factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        page: Page.fromJson(json["page"]),
        pageCount: json["pageCount"],
        pageItems: List<dynamic>.from(json["pageItems"].map((x) => x)),
        totalCount: json["totalCount"],
    );

    Map<String, dynamic> toJson() => {
        "page": page.toJson(),
        "pageCount": pageCount,
        "pageItems": List<dynamic>.from(pageItems.map((x) => x)),
        "totalCount": totalCount,
    };
}

class Page {
    Page({
        required this.index,
        required this.number,
        required this.size,
    });

    int index;
    int number;
    int size;

    factory Page.fromJson(Map<String, dynamic> json) => Page(
        index: json["index"],
        number: json["number"],
        size: json["size"],
    );

    Map<String, dynamic> toJson() => {
        "index": index,
        "number": number,
        "size": size,
    };
}


class AlarmsListView extends StatelessWidget {
  const AlarmsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Alarm>>(
      future: _fetchAlarms(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Alarm>? data = snapshot.data;
          return _alarmsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<List<Alarm>> _fetchAlarms() async {

    final alarmsListAPIUrl = Uri.http('localhost:13332', 'api/1/Resources/Alarms', {'PageSizeLimit': '100', 'PageIndex': '0'});
    final response = await http.get(alarmsListAPIUrl) ;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse.map((alarm) => Alarm.fromJson(alarm)).toList();

    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _alarmsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].position, data[index].company, Icons.work);
        });
  }

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 215, 215,0),
        ),
      );
}