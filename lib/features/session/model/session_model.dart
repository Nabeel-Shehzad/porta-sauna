class SessionModel {
  final int id;
  final String? saunaType;
  final String? temperature;
  final String? duration;
  final String? humidity;
  final bool? coldShowerPlunge;
  final bool? aufguss;
  final String? heartRate;
  final String? note;
  final DateTime? date;

  SessionModel({
    required this.id,
    required this.saunaType,
    required this.temperature,
    required this.duration,
    required this.humidity,
    required this.coldShowerPlunge,
    required this.aufguss,
    required this.heartRate,
    required this.note,
    required this.date,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      saunaType: json['sauna_type'],
      temperature: json['temperature'],
      duration: json['duration'],
      humidity: json['humidity'],
      coldShowerPlunge: json['cold_shower_plunge'],
      aufguss: json['aufguss'],
      heartRate: json['heart_rate'],
      note: json['note'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sauna_type': saunaType,
      'temperature': temperature,
      'duration': duration,
      'humidity': humidity,
      'cold_shower_plunge': coldShowerPlunge,
      'aufguss': aufguss,
      'heart_rate': heartRate,
      'note': note,
      'date': date.toString(),
    };
  }
}
