

void main(){

// create object 
var user1 = User("John", "john@example.com", 30);
var user2 = User.guest();

print(user1.greet());
print(user2.greet());
}


//1. class and object go vs dart

// type User struct {
//     Name  string
//     Email string
//     Age   int
// }

// // Constructor-like function
// func NewUser(name, email string) *User {
//     return &User{
//         Name:  name,
//         Email: email,
//         Age:   0,
//     }
// }

// // Method
// func (u *User) Greet() string {
//     return "Hello " + u.Name
// }


//In dart we can write like this
class User {
  String name;
  String email;
  int age;
  
  // Constructor (define the object how to create)
  User(this.name, this.email, this.age);
  
  // Named constructor (define the object how to create)
  User.guest()
    : name = "Guest",
      email = "",
      age = 0;
  
  // Method like go lang, only the class object can call these method 
  String greet() {
    return "Hello $name";
  }
}
