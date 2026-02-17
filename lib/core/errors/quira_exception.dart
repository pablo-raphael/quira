import 'package:quira/core/errors/quira_error.dart';

class QuiraException implements Exception {
  final QuiraError cause;
  final Object? innerError;
  final StackTrace? innerStackTrace;

  const QuiraException(this.cause, {this.innerError, this.innerStackTrace});
}
