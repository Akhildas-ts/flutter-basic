import 'dart:async';

void main() {

// here we are creating a stream from iterable, its create single subscription stream
    final iterableStream = Stream.fromIterable([1,2,3,4,5]);
    await for (var value in iterableStream) {
       print('Iterable: $value');
    }

}