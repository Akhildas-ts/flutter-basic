// 1.5 Parallel Execution with Future.wait()



Future <String> fetchUser() {
    return Future.delayed(Duration(seconds: 2), () => "User");
}   

Future <List<String>> fetchUserPost() {
    return Future.delayed(Duration(seconds: 2), () => ["Post 1", "Post 2", "Post 3"]);
}   

Future <int> fetchfollowers() {
    return Future.delayed(Duration(seconds: 2), () => 100);



}   


// aysnc we are using becuase of the using of await, dart syntax that. 
// if the function using await then it should be async
void main()async{


final stopwatch = Stopwatch()..start();



// normal one 

final user = await fetchUser();
final posts = await fetchUserPost();
final followers = await fetchfollowers();

print('User: $user');
print('Posts: $posts');
print('Followers: $followers');
  print('Time normal: ${stopwatch.elapsedMilliseconds}ms'); 



//parellel execution (compare to normal its take 3 seconds but its take 1 second)

final results = await Future.wait([
    fetchUser(),
    fetchUserPost(),
    fetchfollowers(),
]); 



print('Results: $results');
  print('Time: ${stopwatch.elapsedMilliseconds}ms');  // ~1000ms instead of ~3000ms



}