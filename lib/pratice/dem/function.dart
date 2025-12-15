void main() {
  print(add(2, 5));
  print(addDiff(2, 5));

}


// 1. basic function go vs dart 

// In go lang we can write like this
// func add(a int, b int) int {
//   return a + b;
// }

// IN dart we can write like this
// frist we decleare the return type 
// => expression that gets returned automatically
int add(int a, int b) => a + b;



//2. mutiple return type function go vs dart

// in go lang we can write like this
// func add(a int, b int) (int, int) {
//   return a + b;
// }

// IN dart we can write like this
// its not possible to return multiple values in dart
// if we want to return multiple values in dart we can use class


class result {
    int sum;
    int diff;
    result(this.sum, this.diff);

// with override we can print the object value
    @override
    String toString() {
      return 'result(sum: $sum, diff: $diff)';
    }
}

result  addDiff(int a, int b) {
    // when you return a object its does not print the filed like go lang struct, its print the default value of the object //object.toString()
    return result(a + b, a - b);
}


// ?. optional parameters go vs dart
//In go lang we dont skip parameters, 
//IN dart we can use optional parameters and named parameters


//optional parameters (used for small functions)
void logpositioal(String message,[String level = "info"]){
    print("[$level] $message");

}

//named parameters (used for large functions)

void lognamed(String message,{String level = "info"}){
    print("[$level] $message");
}
