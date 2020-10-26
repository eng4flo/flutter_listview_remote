import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Job {
  String company;
  String description;
  String employmentType;
  int id;
  String location;
  String position;
  List<String> skillsRequired;

  Job(
      {this.company,
      this.description,
      this.employmentType,
      this.id,
      this.location,
      this.position,
      this.skillsRequired});

  Job.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    description = json['description'];
    employmentType = json['employmentType'];
    id = json['id'];
    location = json['location'];
    position = json['position'];
    if (json['skillsRequired'] != null) {
      skillsRequired = new List<String>();
      json['skillsRequired'].forEach((v) {
        skillsRequired.add(v);
      });
    }
  }
}

class JobListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Job>>(
        future: _getJob(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Job> data = snapshot.data;
            return _listViewFormat(data);
          } else if (snapshot.hasError) {
            return Container();
          }
          return Center(
            child: Container(
              width: 50,
              height: 50,

              child: CircularProgressIndicator(),
            ),
          );
        },
      ) ,
    );
  }
}

ListView _listViewFormat(List<Job> data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(data[index].position, data[index].description, Icons.work);
      });
}

ListTile _tile(String title, String subtitle, IconData iconData) {
  return ListTile(
    title: Text(title, style: TextStyle(fontSize: 20)),
    subtitle: Text(
      subtitle,
      style: TextStyle(fontSize: 12),
    ),
    leading: Icon(iconData),
    trailing: Icon(Icons.arrow_right),
  );
}

Future<List<Job>> _getJob() async {
  String baseUrl = 'https://mock-json-service.glitch.me';
  var response = await get(baseUrl);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((job) => new Job.fromJson(job)).toList();
  }
}
