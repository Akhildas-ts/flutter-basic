//here acutally we are doing  
//for the fake- click,scroll,keypress my program create fake event,send them into stream, listen them and do something,analyis them (counting detecting pattern etc..), prints results


//why its important because before learning flutter we need to understand the concept of stream,events etc.. 


//Imagine you're building a Flutter app and need to track user actions (clicks, typing, scrolling). This code creates an event tracking system similar to what Google Analytics does on websites.

// Real-world problems it solves:
// Rage clicking - User frustratedly clicking a broken button 5 times
// Search optimization - Don't search after every keystroke, wait till they stop typing
// Performance - Don't process every scroll pixel, just sample occasionally


import 'dart:async';
import 'dart:math';

//An enum type is a custom data type that contains a fixed set of named values.
//contant typed values
//enum is used to define a set of named constants 

enum EventType { click, hover, scroll, keypress, resize }

class UIEvent {
  final EventType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  UIEvent(this.type, this.data) : timestamp = DateTime.now();

  @override
  String toString() => 'UIEvent($type, $data)';
}


// its  a machine that create events and send them into stream 
// the rest of the (analysis,logging etc..) listen to the event produce 

//create event send them into stream 

class EventEmitter {
  // Create a broadcast StreamController for UIEvent
  // use or "_" means private, its only seened or use here, its cannot access from outside, it cannot importanted anywhere else 
  

  // its a broadcase so many listener can listn 
  // only eventemitter can emit the event 
  //
  final StreamController<UIEvent> _controller = 
      StreamController<UIEvent>.broadcast();

//emit - means send out, produce  
// other class can listen the stream 
// Public stream getter, listen to the event produce 
  Stream<UIEvent> get events => _controller.stream;

//Send this event into the event stream.
// Emit an event
  void emit(UIEvent event) {
    _controller.add(event);
  }

//helper methods to create a specific event and emit it
  // Convenience methods
  void emitClick(int x, int y) {
    emit(UIEvent(EventType.click, {'x': x, 'y': y}));
  }

  void emitKeypress(String key) {
    emit(UIEvent(EventType.keypress, {'key': key}));
  }

  void emitScroll(int scrollTop) {
    emit(UIEvent(EventType.scroll, {'scrollTop': scrollTop}));
  }

//close the stream
//no more events can be emitted, clean the resources
  void dispose() {
    _controller.close();
  }
}


//analyze the event , counting event,detecting rapid clicks,debounce,throttle etc..
class EventAnalytics {

  final EventEmitter emitter;
  final List<StreamSubscription> _subscriptions = [];

  EventAnalytics(this.emitter);

  /// Counts events every X seconds and sends the count out.
  /// Returns a stream that emits counts every [windowDuration]
  Stream<Map<EventType, int>> eventCountsByWindow(Duration windowDuration) {
    final controller = StreamController<Map<EventType, int>>();
    final counts = <EventType, int>{};

    // listen to all events and count them
    final sub = emitter.events.listen((event) {
      counts[event.type] = (counts[event.type] ?? 0) + 1;
    });
    _subscriptions.add(sub);

    // windowDuration : repeats every 1 or 2 seconds 
    // on that time we are taking the counts from counts and sending it to controller

    final timer = Timer.periodic(windowDuration, (_) {
      controller.add(Map.from(counts));
      counts.clear();
    });

    controller.onCancel = () => timer.cancel();
    return controller.stream;
  }

  /// Detects rapid clicking (more than [threshold] clicks in [window])
  /// Returns stream of "rage click" events
  Stream<UIEvent> detectRageClicks({
    int threshold = 3,
    Duration window = const Duration(seconds: 1),
  }) {
    final controller = StreamController<UIEvent>();
    final clickBuffer = <UIEvent>[];

    final sub = emitter.events
        .where((event) => event.type == EventType.click)
        .listen((event) {
      final now = DateTime.now();
      
      // Remove old clicks outside the window
      clickBuffer.removeWhere(
          (e) => now.difference(e.timestamp) > window);
      
      // Add current click
      clickBuffer.add(event);
      
      // Check if threshold exceeded
      if (clickBuffer.length >= threshold) {
        controller.add(event);
      }
    });

    _subscriptions.add(sub);
    controller.onCancel = () => sub.cancel();
    return controller.stream;
  }

  /// Debounces events - only emits after [duration] of silence
  /// Useful for search-as-you-type
  Stream<UIEvent> debounce(Duration duration) {
    final controller = StreamController<UIEvent>();
    Timer? timer;
    UIEvent? lastEvent;

    final sub = emitter.events.listen((event) {
      timer?.cancel();
      lastEvent = event;
      
      timer = Timer(duration, () {
        if (lastEvent != null) {
          controller.add(lastEvent!);
        }
      });
    });

    _subscriptions.add(sub);
    controller.onCancel = () {
      timer?.cancel();
      sub.cancel();
    };
    return controller.stream;
  }

  /// Throttles events - emits at most once per [duration]
  /// Useful for scroll events
  Stream<UIEvent> throttle(Duration duration) {
    final controller = StreamController<UIEvent>();
    bool canEmit = true;

    final sub = emitter.events.listen((event) {
      if (canEmit) {
        controller.add(event);
        canEmit = false;
        
        Timer(duration, () {
          canEmit = true;
        });
      }
    });

    _subscriptions.add(sub);
    controller.onCancel = () => sub.cancel();
    return controller.stream;
  }

  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
  }
}

class EventLogger {
  final EventEmitter emitter;
  StreamSubscription? _subscription;

  EventLogger(this.emitter);

  /// Start logging all events with timestamp
  void startLogging() {
    _subscription = emitter.events.listen((event) {
      print('[${event.timestamp}] ${event.type}: ${event.data}');
    });
  }

  /// Stop logging
  void stopLogging() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Log only specific event types
  void logOnly(Set<EventType> types) {
    stopLogging();
    _subscription = emitter.events
        .where((event) => types.contains(event.type))
        .listen((event) {
      print('[${event.timestamp}] ${event.type}: ${event.data}');
    });
  }
}

void main() async {
  print('=== Event System Demo ===\n');

  final emitter = EventEmitter();
  final analytics = EventAnalytics(emitter);
  final logger = EventLogger(emitter);

  // Start logging
  logger.startLogging();

  // Listen for rage clicks
  analytics.detectRageClicks(threshold: 3).listen((event) {
    print('RAGE CLICK DETECTED at ${event.data}');
  });

  // Simulate user interactions
  print('Simulating user activity...\n');

  // Normal clicks
  emitter.emitClick(100, 200);
  await Future.delayed(Duration(milliseconds: 500));
  emitter.emitClick(150, 250);

  // Rage clicks (rapid succession)
  await Future.delayed(Duration(milliseconds: 200));
  print('\n--- Simulating rage clicks ---');
  for (var i = 0; i < 5; i++) {
    emitter.emitClick(200 + i * 10, 300);
    await Future.delayed(Duration(milliseconds: 100));
  }

  // Some keypresses
  await Future.delayed(Duration(milliseconds: 300));
  print('\n--- Simulating typing ---');
  for (var char in 'hello'.split('')) {
    emitter.emitKeypress(char);
    await Future.delayed(Duration(milliseconds: 150));
  }

  // Test debounce
  print('\n--- Testing debounce ---');
  final debounced = analytics.debounce(Duration(milliseconds: 300));
  debounced.listen((e) => print('Debounced: $e'));

  emitter.emitKeypress('a');
  await Future.delayed(Duration(milliseconds: 100));
  emitter.emitKeypress('b');
  await Future.delayed(Duration(milliseconds: 100));
  emitter.emitKeypress('c');
  await Future.delayed(Duration(milliseconds: 500));  // Silence - should emit

  // Cleanup
  await Future.delayed(Duration(seconds: 1));
  logger.stopLogging();
  analytics.dispose();
  emitter.dispose();

  print('\n=== Demo Complete ===');
}