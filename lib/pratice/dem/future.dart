
// INDRODUCTION FUTURE 

//1. future go vs dart

//In go lang we can write like this
// func main() {
//     go func() {
//         fmt.Println("Hello from goroutine!")
//     }()
//     fmt.Println("Hello from main!")  
// }

//In dart we can write like this

void main() async {
    //await waits until the Future completes, similar to <-ch in Go.
   // main() must be async because we are using await.

//with_await
    // String data = await fetchData();
    // print(data);

//without_await
    // fetchData().then((data) {
    //     print(data);
    // });

//.then() without blocking .catchError()

    // fetchData().then((data) {
    //     print(data);
    // }).catchError((e) {
    //     print(e);
    // });

    print("hello1");
    print("hello2");
    print("hello3");
    
   
  
}

  // future <string > this function will return string data in future 
    //async  mark as a function asynchronus
  
 Future<String> fetchData() async{
    await Future.delayed(Duration(seconds: 2));
    throw Exception("Failed to fetch data");
    return "Data fetched";  
   }


   //2.  method - 1 future error handling go vs dart (try catch)withblocking

   Future<void> fetchUserData() async {
    try {
       final user =  await fetchData();
    } catch (e) {
        print(e);
    }
   }


   //3. method 3 future error handling go vs dart (.catchError() used when .then())like without blocking 

