class DayWeather {
  late String status = "null";

  late String tempc = "null";

  late String h = "null";
  late String imgurl = "null";
  late String wind = "null";
  get getStatus => this.status;

  set setStatus(status) => this.status = status;
  get getTempc => this.tempc;

  set setTempc(tempc) => this.tempc = tempc;

  get getH => this.h;

  set setH(h) => this.h = h;

  get getImgurl => this.imgurl;

  set setImgurl(imgurl) => this.imgurl = imgurl;

  get getWind => this.wind;

  set setWind(wind) => this.wind = wind;
}
