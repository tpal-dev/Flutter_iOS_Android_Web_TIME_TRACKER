import 'package:meta/meta.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/services/api_path.dart';
import 'package:time_tracker_app/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final _service = FirestoreService.instance;

  @override
  Stream<List<Job>> jobStream() => _service.collectionStream(
        path: APIPath.jobs(uid: uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> deleteJob(Job job) async => _service.deleteData(
        path: APIPath.job(
          uid: uid,
          jobId: job.id,
        ),
      );

  @override
  Future<void> setJob(Job job) async => _service.setData(
        path: APIPath.job(
          uid: uid,
          jobId: job.id,
        ),
        data: job.toMap(),
      );
}
