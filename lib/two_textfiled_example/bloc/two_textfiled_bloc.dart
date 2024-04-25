import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class TwoTextFieldBloc {
  final Sink<String?> firstNameSink; // write-only
  final Sink<String?> secondNameSink; // write-only
  final Stream<String> fullName; // read - only

  const TwoTextFieldBloc._({
    required this.firstNameSink,
    required this.secondNameSink,
    required this.fullName,
  });

  factory TwoTextFieldBloc() {
    final firstNameBehavior = BehaviorSubject<String?>();
    final secondNameBehavior = BehaviorSubject<String?>();

    final Stream<String> fullNameResult = Rx.combineLatest2(
      firstNameBehavior.startWith(null),
      secondNameBehavior.startWith(null),
      (firstName, secondName) {
        if (firstName != null &&
            firstName.isNotEmpty &&
            secondName != null &&
            secondName.isNotEmpty) {
          return "$firstName $secondName";
        } else {
          return "Both first and second name must be provided";
        }
      },
    );

    return TwoTextFieldBloc._(
      firstNameSink: firstNameBehavior.sink,
      secondNameSink: secondNameBehavior.sink,
      fullName: fullNameResult,
    );
  }

  void dispose() {
    firstNameSink.close();
    secondNameSink.close();
  }
}
