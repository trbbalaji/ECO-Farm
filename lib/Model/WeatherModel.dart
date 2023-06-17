class WeatherData {
  late String status;

  final String temp_c;
  final String h;
  final String imgurl;
  final String wind;

  WeatherData(
      {required this.status,
      required this.temp_c,
      required this.h,
      required this.imgurl,
      required this.wind});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
        status: json['name'],
        temp_c: json['main']['temp'].toDouble(),
        h: json['weather'][0]['main'],
        imgurl: json['weather'][0]['icon'],
        wind: json['wind']);
  }
}
