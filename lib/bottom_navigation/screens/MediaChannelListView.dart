import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MediaChannel {
  Page? page;
  int? pageCount;
  List<PageItems>? pageItems;
  int? totalCount;

  MediaChannel({this.page, this.pageCount, this.pageItems, this.totalCount});

  MediaChannel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (page != null) {
      data['page'] = page!.toJson();
    }
    data['pageCount'] = pageCount;
    if (pageItems != null) {
      data['pageItems'] = pageItems!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = totalCount;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['number'] = number;
    data['size'] = size;
    return data;
  }
}

class PageItems {
  String? nodeId;
  int? globalChannelNumber;
  int? mediaChannelID;
  String? name;
  String? description;
  bool? isTelecontrol;

  PageItems(
      {this.nodeId,
      this.globalChannelNumber,
      this.mediaChannelID,
      this.name,
      this.description,
      this.isTelecontrol});

  PageItems.fromJson(Map<String, dynamic> json) {
    nodeId = json['nodeId'];
    globalChannelNumber = json['globalChannelNumber'];
    mediaChannelID = json['mediaChannelID'];
    name = json['name'];
    description = json['description'];
    isTelecontrol = json['isTelecontrol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nodeId'] = nodeId;
    data['globalChannelNumber'] = globalChannelNumber;
    data['mediaChannelID'] = mediaChannelID;
    data['name'] = name;
    data['description'] = description;
    data['isTelecontrol'] = isTelecontrol;
    return data;
  }
}

class MediaChannelsListView extends StatelessWidget {
  const MediaChannelsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PageItems>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PageItems>? data = snapshot.data;
          return _mediaChannelsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<List<PageItems>> _fetchJobs() async {

    final mediaChannelsListAPIUrl = Uri.http('localhost:13332', 'api/1/Resources/MediaChannels', {'PageSizeLimit': '100', 'PageIndex': '0'});
    final response = await http.get(mediaChannelsListAPIUrl) ;

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      var foo = MediaChannel.fromJson(jsonResponse);
      return Future<List<PageItems>>.value(foo.pageItems);

    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _mediaChannelsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].globalChannelNumber.toString(), data[index].name, Icons.camera);
        });
  }

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white),),
        leading: Icon(
          icon,
          color: const Color.fromARGB(230, 215, 215,0),
        ),
      );
}