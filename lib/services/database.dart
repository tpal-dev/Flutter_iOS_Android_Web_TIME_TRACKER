import 'package:meta/meta.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/services/api_path.dart';
import 'package:time_tracker_app/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  final _service = FirestoreService.instance;

  Stream<List<Job>> jobStream() =>
      _service.collectionStream(path: APIPath.jobs(uid: uid), builder: (data) => Job.fromMap(data));

  Future<void> createJob(Job job) async => _service.setData(
        path: APIPath.job(uid: uid, jobId: 'job_abc'),
        data: job.toMap(),
      );
}
