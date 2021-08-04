import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);

  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(job.name),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        tileColor: Colors.grey.shade200,
        onTap: onTap,
      ),
    );
  }
}
