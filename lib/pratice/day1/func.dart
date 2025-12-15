//task 1


/// Creates a function that filters a list based on a predicate.
//created a genric function like <T> it will work for any type of list
// bool Function(T) → predicate/condition function

//The function createFilter<T> starts by receiving a predicate, which is a function that checks a condition and returns true/false.
List<T> Function(List<T>) createFilter<T>(bool Function(T) predicate) {
  return (List<T> inputList) {
    List<T> result = [];

    for (var item in inputList) {
      if (predicate(item)) {
        result.add(item);
      }
    }

    return result;
  };
}



//task 2 

//Create a function that applies another function multiple times in succession.

/// Creates a function that applies a transformation multiple times.
int Function(int) applyTimes(int Function(int) fn, int times) {
    return  (int value) {
        int result = value;
        for(int i = 0; i < times; i++) {
            result = fn(result);
        }
        return result;
    };

}


//task 3 

/// Composes two functions: compose(f, g)(x) = f(g(x))
int Function(int) compose(int Function(int) f, int Function(int) g) {
    //So compose(f, g) creates a new function where g runs first, and then f runs on the result of g.
  return (int x) => f(g(x)); // Apply g first, then f
}




// task 4 



int Function(int) memoize(int Function(int) fn) {
  // Your code here

 // Step 1: Create a cache to store computed results (map)
  final cache = <int, int>{};

  // Step 2: Return a new function that wraps the original function
  return (int x) {
    // Step 3: If result exists in cache, return it
    if (cache.containsKey(x)) {
      return cache[x]!;
    }

    // Step 4: Compute the result and store it in cache
    final result = fn(x);
    cache[x] = result;

    // Step 5: Return the computed result
    return result;
  };
}
void main() {
  List<int> numbers = [1, 2, 3, 4, 5];

  print(createFilter((int num) => num % 2 == 0)(numbers));
    //a

// task 2 
// create a simple function 
int double (int x) => x * 2;

// apply double function 3 times 
  var tripleDouble = applyTimes(double, 3);

//
  print(tripleDouble(5));


//task 3 

var res = compose(double, triple);
// here frist double function will run = 5 * 2 = 10
// then triple function will run = 10 + 3 = 13  
// these was the flow of the function 
print(res(5));


//task 4 

var memoizedDouble = memoize(double);
print(memoizedDouble(5));   // Output: 10
print(memoizedDouble(5));   // Output: 10 (cached result)

}



int multiple(int x) => x * 2;
int triple(int x) => x + 3;
// <T> → generic type, works for any type of list

// bool Function(T) → predicate/condition function

// Returned function → filters a list based on predicate

// Flow → createFilter → returns function → call with list → loop → check predicate → add to result → return filtered list