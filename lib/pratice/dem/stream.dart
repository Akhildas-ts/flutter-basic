//stream 

// Go channel

// Sends many values
// You can range over it
// Producer → send
// Consumer → receive
// Supports close()
// ---------------------------------------
// Dart stream

// Sends many values
// You can await for over it
// Producer → yield
// Consumer → .listen() or await for
// Closes automatically when done

void main() async{

     await for(var i in countStream()) {
        print(i);
    }
    
}   


Stream<int> countStream() async* {
    for(int i = 0; i < 5; i++) {
        
        yield i;
    }
}