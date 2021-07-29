import 'package:flutter/foundation.dart';

class APIPath {
  static String job({@required String uid, @required String jobId}) => 'users/$uid/jobs/$jobId';
  static String jobs({@required String uid}) => 'users/$uid/jobs';
}
