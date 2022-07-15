import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GcoreServer {
  Page? page;
  int? pageCount;
  List<PageItems>? pageItems;
  int? totalCount;

  GcoreServer({this.page, this.pageCount, this.pageItems, this.totalCount});

  GcoreServer.fromJson(Map<String, dynamic> json) {
    page = json['page'] != null ? Page.fromJson(json['page']) : null;
    pageCount = json['pageCount'];
    if (json['pageItems'] != null) {
      pageItems = <PageItems>[];
      json['pageItems'].forEach((v) {
        pageItems!.add(PageItems.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.page != null) {
      data['page'] = this.page!.toJson();
    }
    data['pageCount'] = this.pageCount;
    if (this.pageItems != null) {
      data['pageItems'] = this.pageItems!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class Page {
  int? index;
  int? number;
  int? size;

  Page({this.index, this.number, this.size});

  Page.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    number = json['number'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['index'] = this.index;
    data['number'] = this.number;
    data['size'] = this.size;
    return data;
  }
}

class PageItems {
  String? regNode;
  int? offset;
  int? remoteServerID;
  String? alias;
  String? hostname;
  String? login;
  String? pass;
  bool? replicateServer;
  bool? liveStreamProxyEnabled;
  Info? info;

  PageItems(
      {this.regNode,
      this.offset,
      this.remoteServerID,
      this.alias,
      this.hostname,
      this.login,
      this.pass,
      this.replicateServer,
      this.liveStreamProxyEnabled,
      this.info});

  PageItems.fromJson(Map<String, dynamic> json) {
    regNode = json['regNode'];
    offset = json['offset'];
    remoteServerID = json['remoteServerID'];
    alias = json['alias'];
    hostname = json['hostname'];
    login = json['login'];
    pass = json['pass'];
    replicateServer = json['replicateServer'];
    liveStreamProxyEnabled = json['liveStreamProxyEnabled'];
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['regNode'] = this.regNode;
    data['offset'] = this.offset;
    data['remoteServerID'] = this.remoteServerID;
    data['alias'] = this.alias;
    data['hostname'] = this.hostname;
    data['login'] = this.login;
    data['pass'] = this.pass;
    data['replicateServer'] = this.replicateServer;
    data['liveStreamProxyEnabled'] = this.liveStreamProxyEnabled;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Info {
  String? server;
  String? database;

  Info({this.server, this.database});

  Info.fromJson(Map<String, dynamic> json) {
    server = json['server'];
    database = json['database'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['server'] = this.server;
    data['database'] = this.database;
    return data;
  }
}


class GcoreServerListView extends StatelessWidget {
  const GcoreServerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PageItems>>(
      future: _fetchgcoreServer(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PageItems>? data = snapshot.data;
          return _gcoreServerListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<List<PageItems>> _fetchgcoreServer() async {

    final gcoreserverListAPIUrl = Uri.http('localhost:13332', 'api/1/Resources/RemoteServers', {'PageSizeLimit': '100', 'PageIndex': '0'});
    final response = await http.get(gcoreserverListAPIUrl) ;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      var foo = GcoreServer.fromJson(jsonResponse);
      return Future<List<PageItems>>.value(foo.pageItems);

    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _gcoreServerListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].remoteServerID.toString(), data[index].hostname, Icons.computer);
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