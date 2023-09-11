class stateProcess {
  bool? mystate;
  String? message;

  stateProcess({required mystate, required this.message});

  stateProcess.fromJson(Map<String, dynamic> json)
      : mystate = json['mystate'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
        'mystate': mystate,
        'message': message,
      };

  @override
  String toString() {
    return 'stateProcess{mystate: $mystate, message: $message}';
  }
}
