void main(){

var person = Person("akhildas", 19);
person.indroduce();
print(person.isAdult);
person.birthYear = 2000;
print(person.age);
print(person.toString());
}

class Person {

    String name;
    int age;

    // constructor
    Person(this.name, this.age);

    // Instance Method 
    // these is the function inside the class 
    // its can access name and age
    void indroduce(){
        print("Hello my name is $name and i am $age years old");
    }

// A getter behaves like a read-only property.
    bool get isAdult => age >= 18;

    // A setter allows you to modify a property.
     set birthYear(int year) {
    age = DateTime.now().year - year;
  }


  @override
  String toString() {
    return 'Person(name: $name, age: $age)';
  } 



    
}