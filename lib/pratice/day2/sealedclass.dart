/ Modern Dart approach using sealed classes


//here we are create a parent type 
// <t> means generic type, sealed means only subclass can extend this class
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppException exception;
  const Failure(this.exception);
}

sealed class AppException {
  final String message;
  const AppException(this.message);
}

final class NetworkException extends AppException {
  final int? statusCode;
  const NetworkException(super.message, {this.statusCode});
}

final class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;
  const ValidationException(super.message, {this.fieldErrors = const {}});
}

final class AuthException extends AppException {
  const AuthException(super.message);
}

// Usage with pattern matching
void handleResult(Result<User> result) {
  switch (result) {
    case Success(:final data):
      print('Got user: ${data.name}');

    case Failure(exception: NetworkException(:final statusCode)):
      print('Network error, status: $statusCode');

    case Failure(exception: ValidationException(:final fieldErrors)):
      print('Validation failed:');
      fieldErrors.forEach((field, errors) {
        print('  $field: ${errors.join(", ")}');
      });

    case Failure(exception: AuthException(:final message)):
      print('Auth error: $message');

    case Failure(:final exception):
      print('Unknown error: ${exception.message}');
  }
}

class User {
  final String name;
  User(this.name);
}

void main() {
  handleResult(Success(User('John')));
  handleResult(Failure(NetworkException('Connection refused', statusCode: 503)));
  handleResult(Failure(ValidationException(
    'Invalid input',
    fieldErrors: {
      'email': ['Invalid format', 'Already exists'],
      'password': ['Too short'],
    },
  )));
}