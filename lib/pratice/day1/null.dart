void main(){


}


// TODO: Fix all the null safety errors in this code

class Customer {
  String name;
  String? email;
  Address? address;

  Customer(this.name, {this.email, this.address});
}

class Address {
  String street;
  String city;
  String? zipCode;

  Address(this.street, this.city, {this.zipCode});
}

// TODO: Fix this function to handle nulls properly
String getCustomerLocation(Customer? customer) {
  if (customer == null) {
    return 'Unknown location';
  }

  if (customer.address == null) {
    return 'Unknown location';
  }

  String city = customer.address!.city;
  String? zip = customer.address!.zipCode;

  if (zip == null) {
   // ZipCode missing → return city only
    return city;
  }

  // Both city and zipCode exist
  return '$city, $zip';
}

String getDisplayName(Customer? customer) {

  if (customer == null) {
    return "Guest";
  }

  if (customer.email != null) {
    return customer.email!;
  }

  if (customer.name.isNotEmpty) {
    return customer.name;
  }

  return "Guest";
}

// TODO: Fix this function
void sendNotification(Customer customer) {


    if (customer.email == null) {
        return;
    }
  // Only send if customer has email
  print('Sending to: ' + customer.email);
}