import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

void main() async {
  print("=== Either Operations Demo ===\n");

  // ✅ 1. fold() - Handle BOTH left and right (forces you to handle both!)
  print("--- 1. fold() ---");
  final result1 = await fetchUser("101");
  result1.fold(
    (failure) => print("Error: ${failure.message}"),
    (user) => print("Success: ${user.name}, ${user.email}"),
  );

  // ✅ 2. isRight() / isLeft() - Simple type checks (like Go's if err == nil)
  print("\n--- 2. isRight() / isLeft() ---");
  final result2 = await fetchUser("102");
  if (result2.isRight()) {
    print("✅ Success! It's a Right");
  } else {
    print("❌ Failure! It's a Left");
  }

  // ✅ 3. getOrElse() - Get value OR return fallback (like Go's defaultUser)
  print("\n--- 3. getOrElse() ---");
  final result3 = await fetchUser("");  // Empty ID will fail
  final user = result3.getOrElse(() => User("0", "Guest", "guest@gmail.com"));
  print("User: ${user.name}");  // Prints Guest because validation failed

  // ✅ 4. map() - Transform the Right (success) value only
  print("\n--- 4. map() ---");
  final result4 = await fetchUser("104");
  final greeting = result4.map((user) => "Hello ${user.name}!");
  greeting.fold(
    (failure) => print("Error: ${failure.message}"),
    (message) => print(message),  // Prints "Hello Akhil!"
  );

  // ✅ 5. leftMap() - Transform the Left (error) value only
  print("\n--- 5. leftMap() ---");
  final result5 = await fetchUser("");  // Will fail validation
  final betterError = result5.leftMap(
    (failure) => Failure("🚨 Better error: ${failure.message}")
  );
  betterError.fold(
    (failure) => print(failure.message),  // Prints enhanced error
    (user) => print("Success: ${user.name}"),
  );

  // ✅ 6. flatMap() - Chain Either operations (when next function also returns Either)
  print("\n--- 6. flatMap() ---");
  final result6 = await fetchUser("106");
  // Use fold to handle async flatMap
  await result6.fold(
    (failure) async => print("Error: ${failure.message}"),
    (user) async {
      final profileResult = await fetchProfile(user.id);
      profileResult.fold(
        (failure) => print("Error: ${failure.message}"),
        (profile) => print("Profile: ${profile.bio}"),
      );
    },
  );
}

// Mock DB class (TEMP for running)
class DB {
  Future<User> get(String id) async {
    await Future.delayed(Duration(seconds: 1));
    return User(id, "Akhil", "akhil@example.com");
  }
}

final db = DB(); // creating DB object

Future<Either<Failure, User>> fetchUser(String id) async {
  if (id.isEmpty) {
    return Left(ValidationFailure("empty id"));
  }

  try {
    final user = await db.get(id);    
    return Right(user);               
  } catch (e) {
    return Left(Failure(e.toString()));  
  }
}

// flatMap() example - Function that also returns Either
Future<Either<Failure, Profile>> fetchProfile(String userId) async {
  await Future.delayed(Duration(milliseconds: 500));
  return Right(Profile(userId, "Bio for user $userId"));
}

class Profile {
  final String userId;
  final String bio;
  
  Profile(this.userId, this.bio);
}

class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure(String msg) : super(msg);
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  const User(this.id, this.name, this.email);

  @override
  List<Object?> get props => [id, name, email];
}
