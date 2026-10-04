sealed class Failure {
  final String code;
  final String message;
  const Failure(this.code, this.message);
}

class NetworkFailure extends Failure {
  /// The raw API error code (e.g. 'clinical.investigation.request.error.editWindowExpired').
  /// Populated when the server returns a parseable JSON error body.
  final String? errorCode;
  const NetworkFailure(String m, {this.errorCode}) : super('network', m);
}

class AuthFailure extends Failure {
  const AuthFailure(String m) : super('auth', m);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String m) : super('unknown', m);
}

class ServerFailure extends Failure {
  const ServerFailure(String m) : super('server', m);
}

/// Emitted when the server returns HTTP 404 — resource does not exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure(String m) : super('not_found', m);
}

