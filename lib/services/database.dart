import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  Stream<List<T>> _collectionStream<T>(
      {@required String path, @required T Function(Map<String, dynamic> data) builder}) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Stream<List<Job>> jobStream() =>
      _collectionStream(path: APIPath.jobs(uid: uid), builder: (data) => Job.fromMap(data));

  Future<void> createJob(Job job) async => _setData(
        path: APIPath.job(uid: uid, jobId: 'job_abc'),
        data: job.toMap(),
      );
}
