

import 'dart:math' as Math;
import 'dart:async';

void main() async {
  print('=== Testing fetchUserWithTimeout ===');
  try {
    final user = await fetchUserWithTimeout('user1', Duration(milliseconds: 50));
    print('Success: $user');
  } on TimeoutException {
    print('Request timed out (expected)');
  }

  print('\n=== Testing fetchUserWithRetry ===');
  try {
    final user = await fetchUserWithRetry('user1', maxRetries: 3);
    print('Success after retries: $user');
  } catch (e) {
    print('Failed after all retries: $e');
  }

  print('\n=== Testing fetchUsersParallel ===');
  final users = await fetchUsersParallel(['user1', 'user2', 'user3']);
  print('Results: $users');

  print('\n=== Testing fetchDashboard ===');
  final dashboard = await fetchDashboard('user1');
  print('User: ${dashboard.user}');
  print('Posts: ${dashboard.posts}');
  print('Notifications: ${dashboard.notificationCount}');

  print('\n=== Testing CachedFetcher ===');
  final cache = CachedFetcher();
  final stopwatch = Stopwatch()..start();

  await cache.fetchUser('user1');  // Should be slow (network)
  print('First fetch: ${stopwatch.elapsedMilliseconds}ms');

  stopwatch.reset();
  await cache.fetchUser('user1');  // Should be fast (cache)
  print('Second fetch: ${stopwatch.elapsedMilliseconds}ms');  // Should be ~0
}

// Simulates network latency
Future<T> simulateNetwork<T>(T data, {int delayMs = 100}) async {
  await Future.delayed(Duration(milliseconds: delayMs));
  return data;
}

// Sometimes fails
Future<T> unreliableNetwork<T>(T data, {double failureRate = 0.3}) async {
  await Future.delayed(Duration(milliseconds: 100));
  if (Math.Random().nextDouble() < failureRate) {
    throw NetworkException('Connection failed');
  }
  return data;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

// TODO: Implement these functions


// task 1 

/// Fetches user data with timeout. If the request takes longer than
/// [timeout], throw a TimeoutException.
Future<Map<String, dynamic>> fetchUserWithTimeout(
  String userId,
  Duration timeout,
) async {
  return simulateNetwork({"userId": userId}).timeout(timeout);
}

// task 2 

/// Fetches user data with retry. If the request fails, retry up to
/// [maxRetries] times with [delay] between attempts.
Future<Map<String, dynamic>> fetchUserWithRetry(
  String userId, {
  int maxRetries = 3,
  Duration delay = const Duration(milliseconds: 500),
}) async {
  int attempt = 0;

  while (attempt < maxRetries) {
    try {
      print('Attempt ${attempt + 1}/$maxRetries...');

      final result = await unreliableNetwork(
        {'id': userId, 'name': 'User $userId'},
      );

      print('✓ Success on attempt ${attempt + 1}');
      return result;

    } catch (e) {

      attempt++;

      if (attempt >= maxRetries) {
        print('❌ Failed after $maxRetries retries');
        rethrow;
      }

      await Future.delayed(delay);
    }
  }

  throw NetworkException("Failed after $maxRetries retries");
}

//task 3 

/// Fetches multiple users in parallel. Returns a list of results,
/// where each result is either the user data or an error message.
Future<List<dynamic>> fetchUsersParallel(List<String> userIds) async {
  final futures = userIds.map((userId) async {
    try {
      return await unreliableNetwork({
        "userId": userId,
        "name": "User $userId",
      });
    } catch (e) {
      return 'Error fetching user $userId: $e';
    }
  }).toList();

  return Future.wait(futures);
}


//task 4

/// Fetches user dashboard data: user info, posts, and notifications
/// in parallel. Returns all data as a record.
Future<({Map<String, dynamic> user, List<String> posts, int notificationCount})>
    fetchDashboard(String userId) async {
  final results = await Future.wait([
    simulateNetwork({'id': userId, 'name': 'User $userId'}),
    simulateNetwork(['Post 1', 'Post 2', 'Post 3']),
    simulateNetwork(5),
  ]);
    return (
    user: results[0] as Map<String, dynamic>,
    posts: results[1] as List<String>,
    notificationCount: results[2] as int,
  );
}

//task 5

/// Implements a simple cache. First checks cache, if not found,
class CachedFetcher {
    // here creating a nexted map to store the data for cache
  final Map<String, Map<String, dynamic>> _cache = {};

  Future<Map<String, dynamic>> fetchUser(String userId) async {

    //frist check the cache if the data is already there
    if(_cache.containsKey(userId)){
      return _cache[userId]!;
    }

    //if not in cache print the cache 
     print('🌐 Cache miss, fetching from network...');
    final userData = await simulateNetwork({'id': userId, 'name': 'User $userId'});
    
    //store in cache
    _cache[userId] = userData;
    return userData;
    
 

  }
}
