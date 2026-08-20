import 'exceptions.dart';

abstract class Failure {
  final String message;

  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

extension ExceptionToFailure on Object {
  Failure toFailure() {
    if (this is ServerException) {
      return ServerFailure(message: (this as ServerException).message);
    } else if (this is NetworkException) {
      return NetworkFailure(message: (this as NetworkException).message);
    }
    return ServerFailure(message: toString());
  }
}