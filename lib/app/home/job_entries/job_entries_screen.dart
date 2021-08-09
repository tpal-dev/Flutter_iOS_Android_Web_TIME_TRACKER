import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/home/job_entries/entry_list_item.dart';
import 'package:time_tracker_app/app/home/job_entries/entry_page.dart';
import 'package:time_tracker_app/app/home/jobs/edit_job_screen.dart';
import 'package:time_tracker_app/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_app/app/home/models/entry.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/custom_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/database.dart';

class JobEntriesScreen extends StatelessWidget {
  const JobEntriesScreen({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesScreen(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  onPressed: () => EditJobScreen.show(context, database: database, job: job),
                ),
              ],
            ),
            body: _buildContent(context, job),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => EntryPage.show(context: context, database: database, job: job),
            ),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
